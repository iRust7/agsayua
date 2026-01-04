import 'package:flutter/material.dart';

/// App Color Palette - Modern & Vibrant
class AppColors {
  // Primary Brand Colors - Vibrant Purple/Blue
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF4D46CC);
  static const Color primaryLight = Color(0xFF9D97FF);
  
  // Accent Colors - Coral/Orange
  static const Color accent = Color(0xFFFF6584);
  static const Color accentLight = Color(0xFFFF8FA3);
  
  // Secondary - Teal
  static const Color secondary = Color(0xFF4ECDC4);
  static const Color secondaryLight = Color(0xFF7FE0D9);
  
  // Neutral Scale
  static const Color neutral50 = Color(0xFFF9FAFB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral200 = Color(0xFFE5E7EB);
  static const Color neutral300 = Color(0xFFD1D5DB);
  static const Color neutral400 = Color(0xFF9CA3AF);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral600 = Color(0xFF4B5563);
  static const Color neutral700 = Color(0xFF374151);
  static const Color neutral800 = Color(0xFF1F2937);
  static const Color neutral900 = Color(0xFF111827);
  
  // Semantic Colors
  static const Color success = Color(0xFF00D9A3);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFFFB800);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFFF5252);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFDBEAFE);
  
  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color backgroundSecondary = neutral50;
  static const Color surface = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = neutral600;
  static const Color textTertiary = neutral400;
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  // Divider & Border
  static const Color divider = neutral200;
  static const Color border = neutral300;
  
  // Disabled
  static const Color disabled = neutral300;
  static const Color disabledText = neutral400;
  
  // Overlay
  static const Color overlay = Color(0x80000000); // 50% black
  static const Color overlayLight = Color(0x40000000); // 25% black
  
  // ============ MODERN UI ENHANCEMENTS ============
  
  // Gradient Pairs for Dynamic Backgrounds
  static const List<Color> primaryGradient = [Color(0xFF6C63FF), Color(0xFF9D97FF)];
  static const List<Color> accentGradient = [Color(0xFFFF6584), Color(0xFFFFB199)];
  static const List<Color> joyfulGradient = [Color(0xFF4ECDC4), Color(0xFF44ACE8)];
  static const List<Color> sunsetGradient = [Color(0xFFFF6B6B), Color(0xFFFFE66D)];
  static const List<Color> oceanGradient = [Color(0xFF667EEA), Color(0xFF764BA2)];
  static const List<Color> mintGradient = [Color(0xFF11998E), Color(0xFF38EF7D)];
  
  // Soft Warm Gradients (joyful but not harsh)
  static const List<Color> lavenderPeach = [Color(0xFF667eea), Color(0xFFf093fb)];
  static const List<Color> roseGold = [Color(0xFFf5af19), Color(0xFFf093fb)];
  static const List<Color> softMint = [Color(0xFF89f7fe), Color(0xFF66a6ff)];
  static const List<Color> dreamy = [Color(0xFFa18cd1), Color(0xFFfbc2eb)];
  static const List<Color> warmSunrise = [Color(0xFFffecd2), Color(0xFFfcb69f)];
  static const List<Color> calmBlue = [Color(0xFF667eea), Color(0xFF764ba2)];
  
  // Glassmorphism Effects
  static const Color glassSurface = Color(0xB3FFFFFF); // 70% white
  static const Color glassBlur = Color(0x33FFFFFF); // 20% white
  static const Color glassBorder = Color(0x40FFFFFF); // 25% white
  static const Color glassDark = Color(0x80000000); // 50% black for dark glass
  
  // Glow Effects
  static const Color primaryGlow = Color(0x406C63FF); // 25% primary
  static const Color accentGlow = Color(0x40FF6584); // 25% accent
  static const Color successGlow = Color(0x4000D9A3); // 25% success
  
  // Celebration Colors (for confetti, success states)
  static const List<Color> confettiColors = [
    Color(0xFFFF6B6B), // Coral Red
    Color(0xFF4ECDC4), // Teal
    Color(0xFFFFE66D), // Yellow
    Color(0xFF6C63FF), // Purple
    Color(0xFFFF6584), // Pink
    Color(0xFF38EF7D), // Green
  ];
  
  // Card Shadows
  static const Color cardShadow = Color(0x1A000000); // 10% black
  static const Color elevatedShadow = Color(0x26000000); // 15% black
  static const Color floatingShadow = Color(0x33000000); // 20% black
}
