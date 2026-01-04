import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/state/auth_state.dart';
import 'core/state/cart_state.dart';
import 'core/state/order_state.dart';
import 'core/state/settings_state.dart';
import 'core/theme/theme.dart';
import 'core/widgets/debug_fab.dart';
import 'app_router.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final authState = AuthState();
  final cartState = CartState();
  final orderState = OrderState();
  final settingsState = SettingsState();
  
  // Initialize settings from SharedPreferences
  await settingsState.init();
  
  runApp(MyApp(
    authState: authState,
    cartState: cartState,
    orderState: orderState,
    settingsState: settingsState,
  ));
}

class MyApp extends StatefulWidget {
  final AuthState authState;
  final CartState cartState;
  final OrderState orderState;
  final SettingsState settingsState;
  
  const MyApp({
    super.key,
    required this.authState,
    required this.cartState,
    required this.orderState,
    required this.settingsState,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplash = true;

  void _onSplashComplete() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen BEFORE MaterialApp
    if (_showSplash) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: SplashScreen(onComplete: _onSplashComplete),
      );
    }

    // Main app with router
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.authState),
        ChangeNotifierProvider.value(value: widget.cartState),
        ChangeNotifierProvider.value(value: widget.orderState),
        ChangeNotifierProvider.value(value: widget.settingsState),
      ],
      child: Consumer<SettingsState>(
        builder: (context, settings, child) {
          return MaterialApp.router(
            title: 'ShopJoy',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            // FORCE English locale to prevent issues with 'id' device locale
            locale: const Locale('en', 'US'),
            localizationsDelegates: [
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
            ],
            routerConfig: createRouter(widget.authState),
            builder: (context, child) {
              return GlobalDebugFab(child: child ?? const SizedBox());
            },
          );
        },
      ),
    );
  }
}
