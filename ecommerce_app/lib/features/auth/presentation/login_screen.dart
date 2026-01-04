import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/state/auth_state.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import '../../../core/state/settings_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();  
  final _emailController = TextEditingController(text: 'user@example.com');
  final _passwordController = TextEditingController(text: 'Password123!');
  bool _isRegisterMode = false;
  final _nameController = TextEditingController();
  bool _obscurePassword = true;
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkBiometricLogin();
    });
  }

  Future<void> _checkBiometricLogin() async {
    final settings = context.read<SettingsState>();
    if (!settings.isBiometricEnabled) return;

    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) return;

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Silakan autentikasi untuk masuk',
      );

      if (didAuthenticate && mounted) {
        final auth = context.read<AuthState>();
        // logging in with pre-filled credentials for demo purposes
        final ok = await auth.login(
          _emailController.text,
          _passwordController.text,
        );
        if (ok && mounted) {
          context.go('/');
        }
      }
    } on PlatformException catch (_) {
      // Handle or ignore specific errors
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isRegisterMode = !_isRegisterMode;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthState>();
    
    bool ok;
    if (_isRegisterMode) {
      ok = await auth.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
      );
    } else {
      ok = await auth.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
    
    if (ok && mounted) {
      context.go('/');
    } else if (mounted && auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and welcome
                _buildHeader(),
                const SizedBox(height: 48),
                
                // Form card
                _buildFormCard(auth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDecorations() {
    return const SizedBox.shrink(); // Removed decorative circles
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.shopping_bag_outlined,
            size: 40,
            color: Colors.white,
          ),
        ).animate()
          .scale(duration: 500.ms, curve: Curves.elasticOut)
          .fadeIn(),
        
        const SizedBox(height: 32),
        
        Text(
          _isRegisterMode ? 'Buat Akun Baru' : 'Selamat Datang',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ).animate()
          .fadeIn(delay: 200.ms)
          .slideY(begin: 0.2, delay: 200.ms),
        
        const SizedBox(height: 8),
        
        Text(
          _isRegisterMode 
            ? 'Bergabung dan mulai belanja!' 
            : 'Masuk untuk melanjutkan',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ).animate()
          .fadeIn(delay: 300.ms)
          .slideY(begin: 0.2, delay: 300.ms),
      ],
    );
  }

  Widget _buildFormCard(AuthState auth) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name field (only for register)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isRegisterMode
                ? Column(
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: 'Nama Lengkap',
                        icon: Icons.person_outline_rounded,
                        validator: (v) => v == null || v.isEmpty 
                          ? 'Nama wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                    ],
                  )
                : const SizedBox.shrink(),
            ),
            
            // Email field
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email wajib diisi';
                if (!v.contains('@')) return 'Email tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Password field
            _buildTextField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.neutral400,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password wajib diisi';
                if (v.length < 6) return 'Minimal 6 karakter';
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // Submit button
            _buildSubmitButton(auth),
            
            // Biometric button
            if (!_isRegisterMode) _buildBiometricButton(),
            
            const SizedBox(height: 20),
            
            // Toggle mode
            _buildToggleMode(),
            
            // Forgot password (only on login)
            if (!_isRegisterMode) ...[
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: _openForgotPassword,
                  child: Text(
                    'Lupa password?',
                    style: TextStyle(
                      color: AppColors.neutral500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: 400.ms)
      .slideY(begin: 0.1, delay: 400.ms);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.neutral400),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.neutral50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF667eea),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(AuthState auth) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: auth.isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 5,
          shadowColor: AppColors.primary.withOpacity(0.4),
        ),
        child: auth.isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              _isRegisterMode ? 'Daftar' : 'Masuk',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
      ),
    );
  }

  Widget _buildBiometricButton() {
     final settings = context.read<SettingsState>();
     if (!settings.isBiometricEnabled) return const SizedBox.shrink();

     return Center(
       child: Padding(
         padding: const EdgeInsets.only(top: 16),
         child: IconButton(
           onPressed: _checkBiometricLogin,
           icon: const Icon(Icons.fingerprint, size: 32, color: AppColors.primary),
           tooltip: 'Login dengan Biometrik',
           style: IconButton.styleFrom(
             backgroundColor: AppColors.primary.withAlpha(20),
             padding: const EdgeInsets.all(12),
           ),
         ),
       ),
     );
  }

  Widget _buildToggleMode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isRegisterMode 
            ? 'Sudah punya akun?' 
            : 'Belum punya akun?',
          style: TextStyle(
            color: AppColors.neutral500,
          ),
        ),
        TextButton(
          onPressed: _toggleMode,
          child: Text(
            _isRegisterMode ? 'Masuk' : 'Daftar',
            style: const TextStyle(
              color: Color(0xFF667eea),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openForgotPassword() async {
    final email = TextEditingController(text: _emailController.text);
    final newPass = TextEditingController(text: 'Password123!');
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: AppColors.neutral50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPass,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password baru',
                filled: true,
                fillColor: AppColors.neutral50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final auth = context.read<AuthState>();
      final ok = await auth.resetPassword(
        email: email.text.trim(),
        newPassword: newPass.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ok ? 'Password diperbarui!' : 'Gagal reset password'),
            backgroundColor: ok ? AppColors.success : AppColors.error,
          ),
        );
      }
    }
  }
}
