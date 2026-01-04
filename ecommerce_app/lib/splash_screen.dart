import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'core/theme/colors.dart';

/// Beautiful animated splash screen
class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;
  
  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // Background pattern (optional subtle elements)
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo container
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_bag_rounded,
                    size: 64,
                    color: AppColors.primary,
                  ),
                ).animate()
                  .scale(delay: 100.ms, duration: 600.ms, curve: Curves.elasticOut)
                  .fadeIn(duration: 400.ms),
                
                const SizedBox(height: 32),
                
                // App name
                const Text(
                  'ShopJoy',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ).animate()
                  .fadeIn(delay: 400.ms, duration: 500.ms)
                  .slideY(begin: 0.3, delay: 400.ms, duration: 500.ms, curve: Curves.easeOut),
                
                const SizedBox(height: 8),
                
                // Tagline
                Text(
                  'Belanja Jadi Menyenangkan ✨',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ).animate()
                  .fadeIn(delay: 600.ms, duration: 500.ms)
                  .slideY(begin: 0.3, delay: 600.ms, duration: 500.ms, curve: Curves.easeOut),
                
                const SizedBox(height: 60),
                
                // Loading indicator
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.8),
                    ),
                  ),
                ).animate()
                  .fadeIn(delay: 800.ms, duration: 400.ms),
              ],
            ),
          ),
        ],
      ),
    );

  }
}
