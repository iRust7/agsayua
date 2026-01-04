import 'package:flutter/material.dart';

/// App Color Palette - Modern & Vibrant
class AppColors {
  // Primary Brand Colors - Royal Blue / Deep Navy
  static const Color primary = Color(0xFF1A237E); // Deep Indigo/Navy
  static const Color primaryDark = Color(0xFF000051);
  static const Color primaryLight = Color(0xFF534BAE);
  
  // Accent Colors - Amber/Gold (Premium feel)
  static const Color accent = Color(0xFFFFC107);
  static const Color accentLight = Color(0xFFFFE082);
  
  // Secondary - Emerald Green (Success/Action)
  static const Color secondary = Color(0xFF10B981);
  static const Color secondaryLight = Color(0xFF6EE7B7);
  
  // Neutral Scale
  static const Color neutral50 = Color(0xFFF8F9FA); // Very light grey background
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
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFFFB800);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);
  
  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color backgroundSecondary = Colors.white;
  static const Color surface = Colors.white;
  
  // Text Colors
  static const Color textPrimary = Color(0xFF111827); // Almost black
  static const Color textSecondary = neutral600;
  static const Color textTertiary = neutral400;
  static const Color textOnPrimary = Colors.white;
  static const Color textOnAccent = Colors.black87;
  
  // Divider & Border
  static const Color divider = neutral200;
  static const Color border = neutral300;
  
  // Disabled
  static const Color disabled = neutral300;
  static const Color disabledText = neutral400;
  
  // Overlay
  static const Color overlay = Color(0x80000000); // 50% black
  static const Color overlayLight = Color(0x40000000); // 25% black
  
  // ============ DEPRECATED GRADIENTS ============
  // Kept as solid colors or simple gradients to prevent breaking build
  // but logically replaced by solid styling
  
  static const List<Color> primaryGradient = [primary, primaryLight];
  static const List<Color> accentGradient = [accent, accentLight];
  // Replaced exuberant gradients with subtle professional ones or single colors
  static const List<Color> joyfulGradient = [primary, primaryLight]; 
  static const List<Color> sunsetGradient = [warning, accent];
  static const List<Color> oceanGradient = [primary, Color(0xFF283593)];
  static const List<Color> mintGradient = [secondary, secondaryLight];
  
  // Card Shadows
  static const Color cardShadow = Color(0x0F000000); // 6% black (softer)
  static const Color elevatedShadow = Color(0x1A000000); // 10% black
  static const Color floatingShadow = Color(0x26000000); // 15% black
  
  // Effects
  static const Color primaryGlow = Color(0x401A237E); // 25% primary
  static const Color glassSurface = Color(0xB3FFFFFF); // 70% white
  static const Color glassBorder = Color(0x40FFFFFF); // 25% white
  static const Color glassBlur = Color(0x33FFFFFF); // 20% white
  
  // Gradients (Restored for compatibility)
  static const List<Color> lavenderPeach = [Color(0xFF667eea), Color(0xFFf093fb)]; 
  static const List<Color> warmSunrise = [Color(0xFFffecd2), Color(0xFFfcb69f)];
  static const List<Color> calmBlue = [Color(0xFF667eea), Color(0xFF764ba2)];
}
