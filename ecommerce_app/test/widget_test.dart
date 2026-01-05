// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/core/state/auth_state.dart';
import 'package:ecommerce_app/core/state/cart_state.dart';
import 'package:ecommerce_app/core/state/order_state.dart';
import 'package:ecommerce_app/core/state/settings_state.dart';

void main() {
  testWidgets('App initializes correctly', (WidgetTester tester) async {
    // Create state instances
    final authState = AuthState();
    final cartState = CartState();
    final orderState = OrderState();
    final settingsState = SettingsState();
    
    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp(
      authState: authState,
      cartState: cartState,
      orderState: orderState,
      settingsState: settingsState,
    ));

    // Verify the app widget is rendered
    expect(find.byType(MyApp), findsOneWidget);
  });
}
