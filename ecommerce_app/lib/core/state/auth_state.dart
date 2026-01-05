import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/auth_service.dart';
import '../../features/auth/data/models/user_model.dart';
import 'cart_state.dart';
import 'order_state.dart';

class AuthState extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> login(String email, String password, {required OrderState orderState}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authService.login(email, password);
      
      // Set current user in OrderState for proper data isolation
      orderState.setCurrentUser(_user!.id.toString());
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout({
    required CartState cartState,
    required OrderState orderState,
  }) async {
    // Clear all user-specific data
    cartState.clear();
    orderState.clearOrders();
    
    // Clear profile data from SharedPreferences using USER-SCOPED keys
    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();
      final userId = _user!.id;
      await prefs.remove('profile_name_$userId');
      await prefs.remove('profile_photo_$userId');
      await prefs.remove('profile_phone_$userId');
    }
    
    _user = null;
    notifyListeners();
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authService.register(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email: email, newPassword: newPassword);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  Future<bool> updateProfile({
    required String fullName,
    String? phone,
  }) async {
    if (_user == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedUser = await _authService.updateProfile(
        userId: _user!.id,
        fullName: fullName,
        phone: phone,
      );
      
      _user = updatedUser;
      
      // Update persistent storage for offline access/fast load
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_name_${_user!.id}', updatedUser.fullName);
      if (phone != null) {
        await prefs.setString('profile_phone_${_user!.id}', phone);
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
