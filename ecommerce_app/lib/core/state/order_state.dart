import 'package:flutter/foundation.dart';

/// Order item model
class OrderItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get total => price * quantity;
}

/// Order model
class Order {
  final String id;
  final String userId;  // User who owns this order
  final List<OrderItem> items;
  final String address;
  final String paymentMethod;
  final double subtotal;
  final double shipping;
  final DateTime createdAt;
  String status;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.address,
    required this.paymentMethod,
    required this.subtotal,
    required this.shipping,
    required this.createdAt,
    this.status = 'Diproses',
  });

  double get total => subtotal + shipping;
}

/// Order state management
class OrderState extends ChangeNotifier {
  final List<Order> _orders = [];
  String? _currentUserId;

  // Only return orders for current user
  List<Order> get orders => _currentUserId == null 
      ? [] 
      : _orders.where((order) => order.userId == _currentUserId).toList();
  
  bool get isEmpty => orders.isEmpty;

  /// Set current user (call this when user logs in/out)
  void setCurrentUser(String? userId) {
    _currentUserId = userId;
    notifyListeners();
  }

  /// Clear all orders (call on logout)
  void clearOrders() {
    _orders.clear();
    _currentUserId = null;
    notifyListeners();
  }

  /// Create a new order
  String createOrder({
    required String userId,
    required List<OrderItem> items,
    required String address,
    required String paymentMethod,
    required double subtotal,
    double shipping = 15000,
  }) {
    final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    
    final order = Order(
      id: orderId,
      userId: userId,
      items: items,
      address: address,
      paymentMethod: paymentMethod,
      subtotal: subtotal,
      shipping: shipping,
      createdAt: DateTime.now(),
    );
    
    _orders.insert(0, order); // Add to top
    notifyListeners();
    
    return orderId;
  }

  /// Update order status
  void updateStatus(String orderId, String status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      _orders[index].status = status;
      notifyListeners();
    }
  }

  /// Get order by ID
  Order? getOrder(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return null;
    }
  }
}
