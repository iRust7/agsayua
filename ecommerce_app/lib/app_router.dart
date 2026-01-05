import 'package:go_router/go_router.dart';
import 'core/state/auth_state.dart';
import 'core/widgets/navigation_shell.dart';
import 'core/widgets/admin_navigation_shell.dart';
import 'features/admin/presentation/account_screen.dart';
import 'features/admin/presentation/address_screen.dart';
import 'features/admin/presentation/edit_profile_screen.dart';
import 'features/admin/presentation/notification_screen.dart';
import 'features/admin/presentation/payment_methods_screen.dart';
import 'features/admin/presentation/help_screen.dart';
import 'features/admin/presentation/settings_screen.dart';
import 'features/admin_dashboard/presentation/admin_dashboard_screen.dart';
import 'features/admin_dashboard/presentation/admin_products_screen.dart';
import 'features/admin_dashboard/presentation/add_product_screen.dart';
import 'features/admin_dashboard/presentation/admin_orders_screen.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/cart/presentation/cart_screen.dart';
import 'features/catalog/presentation/home_screen.dart';
import 'features/catalog/presentation/product_detail_screen.dart';
import 'features/catalog/presentation/search_screen.dart';
import 'features/checkout/presentation/checkout_screen.dart';
import 'features/checkout/presentation/order_success_screen.dart';
import 'features/orders/presentation/orders_screen.dart';
import 'features/orders/presentation/order_detail_screen.dart';

/// App Router Configuration with persistent bottom navigation
GoRouter createRouter(AuthState authState) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authState,
    redirect: (context, state) {
      final loggedIn = authState.isLoggedIn;
      final isAdmin = authState.isAdmin;
      final loggingIn = state.matchedLocation == '/login';
      final isAdminRoute = state.matchedLocation.startsWith('/admin');
      
      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) {
        // Redirect to appropriate home based on role
        return isAdmin ? '/admin' : '/';
      }
      
      // Prevent non-admin users from accessing admin routes
      if (isAdminRoute && !isAdmin) return '/';
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/order-success/:orderId',
        name: 'order_success',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId'] ?? 'N/A';
          return OrderSuccessScreen(orderId: orderId);
        },
      ),
      // Admin sub-routes (not in navigation shell)
      GoRoute(
        path: '/admin/products/add',
        name: 'admin_add_product',
        builder: (context, state) => const AddProductScreen(),
      ),
      GoRoute(
        path: '/admin/products/edit/:id',
        name: 'admin_edit_product',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return AddProductScreen(productId: id);
        },
      ),
      // Admin Routes with Navigation Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AdminNavigationShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin',
                name: 'admin_dashboard',
                builder: (context, state) => const AdminDashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/products',
                name: 'admin_products',
                builder: (context, state) => const AdminProductsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/orders',
                name: 'admin_orders',
                builder: (context, state) => const AdminOrdersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/account',
                name: 'admin_account',
                builder: (context, state) => const AccountScreen(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'admin_edit_profile',
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                  GoRoute(
                    path: 'settings',
                    name: 'admin_settings',
                    builder: (context, state) => const SettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      // Regular User Routes with Navigation Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppNavigationShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'product/:id',
                    name: 'product',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return ProductDetailScreen(productId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',
                name: 'cart',
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/orders',
                name: 'orders',
                builder: (context, state) => const OrdersScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: 'order_detail',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return OrderDetailScreen(orderId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                name: 'account',
                builder: (context, state) => const AccountScreen(),
                routes: [
                  GoRoute(
                    path: 'addresses',
                    name: 'addresses',
                    builder: (context, state) => const AddressScreen(),
                  ),
                  GoRoute(
                    path: 'notifications',
                    name: 'notifications',
                    builder: (context, state) => const NotificationScreen(),
                  ),
                  GoRoute(
                    path: 'payment',
                    name: 'payment',
                    builder: (context, state) => const PaymentMethodsScreen(),
                  ),
                  GoRoute(
                    path: 'help',
                    name: 'help',
                    builder: (context, state) => const HelpScreen(),
                  ),
                  GoRoute(
                    path: 'settings',
                    name: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                  ),
                  GoRoute(
                    path: 'edit',
                    name: 'edit_profile',
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
