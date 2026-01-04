import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// App Animation Constants & Configurations
class AppAnimations {
  // ============ DURATIONS ============
  static const Duration instant = Duration(milliseconds: 50);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration slower = Duration(milliseconds: 600);
  static const Duration slowest = Duration(milliseconds: 800);
  
  // ============ MICRO-INTERACTION DURATIONS ============
  static const Duration buttonPress = Duration(milliseconds: 120);
  static const Duration ripple = Duration(milliseconds: 300);
  static const Duration fabScale = Duration(milliseconds: 200);
  static const Duration cardHover = Duration(milliseconds: 180);
  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Duration tabSwitch = Duration(milliseconds: 280);
  
  // ============ SPRING PHYSICS ============
  
  /// Bouncy spring for playful interactions
  static SpringDescription get bouncySpring => const SpringDescription(
    mass: 1.0,
    stiffness: 400.0,
    damping: 15.0,
  );
  
  /// Smooth spring for elegant transitions
  static SpringDescription get smoothSpring => const SpringDescription(
    mass: 1.0,
    stiffness: 300.0,
    damping: 25.0,
  );
  
  /// Snappy spring for quick responses
  static SpringDescription get snappySpring => const SpringDescription(
    mass: 0.8,
    stiffness: 500.0,
    damping: 20.0,
  );
  
  /// Gentle spring for subtle movements
  static SpringDescription get gentleSpring => const SpringDescription(
    mass: 1.2,
    stiffness: 200.0,
    damping: 30.0,
  );
  
  // ============ SCALE VALUES ============
  static const double pressedScale = 0.95;
  static const double hoverScale = 1.02;
  static const double selectedScale = 1.05;
  static const double bounceScale = 1.1;
  
  // ============ OFFSET VALUES ============
  static const double floatOffset = -4.0;
  static const double slideInOffset = 20.0;
  static const double tiltAngle = 0.02; // radians for 3D tilt
  
  // ============ DELAY STAGGER ============
  static const Duration staggerDelay = Duration(milliseconds: 50);
  static Duration staggeredDelay(int index) => Duration(
    milliseconds: 50 * index,
  );
}

/// Custom Curves for unique animations
class AppCurves {
  /// Bouncy curve with overshoot
  static const Curve bouncy = Curves.elasticOut;
  
  /// Smooth deceleration
  static const Curve smooth = Curves.easeOutCubic;
  
  /// Quick start, gentle end
  static const Curve snappy = Curves.easeOutQuart;
  
  /// Emphasized curve for important transitions
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;
  
  /// Spring-like curve
  static const Curve spring = Curves.easeOutBack;
  
  /// Anticipation curve (slight pullback before action)
  static const Curve anticipate = Curves.easeInBack;
}
