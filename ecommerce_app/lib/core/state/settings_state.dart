import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Settings state with persistence
class SettingsState extends ChangeNotifier {
  static const String _darkModeKey = 'dark_mode';
  static const String _localeKey = 'locale';
  static const String _biometricKey = 'biometric_enabled';

  bool _isDarkMode = false;
  String _locale = 'id';
  bool _isBiometricEnabled = false;
  bool _isInitialized = false;

  bool get isDarkMode => _isDarkMode;
  String get locale => _locale;
  bool get isBiometricEnabled => _isBiometricEnabled;
  bool get isInitialized => _isInitialized;

  Locale get currentLocale => Locale(_locale);

  /// Initialize settings from SharedPreferences
  Future<void> init() async {
    if (_isInitialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    _locale = prefs.getString(_localeKey) ?? 'id';
    _isBiometricEnabled = prefs.getBool(_biometricKey) ?? false;
    _isInitialized = true;
    notifyListeners();
  }

  /// Toggle dark mode
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, _isDarkMode);
  }

  /// Set dark mode explicitly
  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode == value) return;
    _isDarkMode = value;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  /// Set locale
  Future<void> setLocale(String locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale);
  }

  /// Toggle biometric
  Future<void> setBiometricEnabled(bool value) async {
    if (_isBiometricEnabled == value) return;
    _isBiometricEnabled = value;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricKey, value);
  }
}
