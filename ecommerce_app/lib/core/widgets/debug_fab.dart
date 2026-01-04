import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/auth_state.dart';
import '../theme/colors.dart';

/// Global Debug FAB that appears on all screens
class GlobalDebugFab extends StatefulWidget {
  final Widget child;

  const GlobalDebugFab({super.key, required this.child});

  @override
  State<GlobalDebugFab> createState() => _GlobalDebugFabState();
}

class _GlobalDebugFabState extends State<GlobalDebugFab>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Debug menu items (shown when expanded)
        if (_isExpanded) ...[
          // Backdrop
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggle,
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
        ],
        // FAB and menu
        Positioned(
          bottom: 120,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Menu items
              if (_isExpanded) ..._buildMenuItems(context),
              const SizedBox(height: 8),
              // Main FAB
              FloatingActionButton(
                heroTag: 'globalDebugFab',
                onPressed: _toggle,
                backgroundColor: _isExpanded 
                    ? AppColors.error 
                    : const Color(0xFF667eea),
                child: AnimatedRotation(
                  turns: _isExpanded ? 0.125 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _isExpanded ? Icons.close : Icons.bug_report_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    final items = [
      _DebugMenuItem(
        icon: Icons.login_rounded,
        label: 'Quick Login',
        color: AppColors.success,
        onTap: () => _quickLogin(context),
        animation: _scaleAnimation,
        delay: 0,
      ),
      _DebugMenuItem(
        icon: Icons.person_add_rounded,
        label: 'Auto Register',
        color: AppColors.info,
        onTap: () => _autoRegister(context),
        animation: _scaleAnimation,
        delay: 1,
      ),
      _DebugMenuItem(
        icon: Icons.lock_reset_rounded,
        label: 'Reset Password',
        color: AppColors.warning,
        onTap: () => _resetPassword(context),
        animation: _scaleAnimation,
        delay: 2,
      ),
      _DebugMenuItem(
        icon: Icons.add_shopping_cart_rounded,
        label: 'Add to Cart',
        color: AppColors.accent,
        onTap: () => _addToCart(context),
        animation: _scaleAnimation,
        delay: 3,
      ),
      _DebugMenuItem(
        icon: Icons.receipt_long_rounded,
        label: 'Create Order',
        color: AppColors.secondary,
        onTap: () => _createOrder(context),
        animation: _scaleAnimation,
        delay: 4,
      ),
      _DebugMenuItem(
        icon: Icons.home_rounded,
        label: 'Go Home',
        color: AppColors.primary,
        onTap: () => _goHome(context),
        animation: _scaleAnimation,
        delay: 5,
      ),
    ];

    return items.map((item) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: item,
    )).toList();
  }

  Future<void> _quickLogin(BuildContext context) async {
    _toggle();
    final auth = context.read<AuthState>();
    final ok = await auth.login('user@example.com', 'Password123!');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? '✅ Logged in as demo user' : '❌ Login failed'),
          backgroundColor: ok ? AppColors.success : AppColors.error,
        ),
      );
      if (ok) context.go('/');
    }
  }

  Future<void> _autoRegister(BuildContext context) async {
    _toggle();
    final auth = context.read<AuthState>();
    final email = 'debug${DateTime.now().millisecondsSinceEpoch}@test.com';
    final ok = await auth.register(
      email: email,
      password: 'Password123!',
      fullName: 'Debug User',
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? '✅ Registered: $email' : '❌ Register failed'),
          backgroundColor: ok ? AppColors.success : AppColors.error,
        ),
      );
      if (ok) context.go('/');
    }
  }

  Future<void> _resetPassword(BuildContext context) async {
    _toggle();
    final auth = context.read<AuthState>();
    final ok = await auth.resetPassword(
      email: 'user@example.com',
      newPassword: 'Password123!',
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? '✅ Password reset' : '❌ Reset failed'),
          backgroundColor: ok ? AppColors.success : AppColors.error,
        ),
      );
    }
  }

  void _addToCart(BuildContext context) {
    _toggle();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🛒 Mock item added to cart'),
        backgroundColor: AppColors.accent,
      ),
    );
  }

  void _createOrder(BuildContext context) {
    _toggle();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📦 Mock order created'),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  void _goHome(BuildContext context) {
    _toggle();
    context.go('/');
  }
}

class _DebugMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final Animation<double> animation;
  final int delay;

  const _DebugMenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.animation,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final delayedValue = (animation.value - (delay * 0.1)).clamp(0.0, 1.0);
        return Transform.scale(
          scale: delayedValue,
          child: Opacity(
            opacity: delayedValue,
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
