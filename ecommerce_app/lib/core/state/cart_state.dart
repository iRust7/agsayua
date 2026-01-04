import 'package:flutter/foundation.dart';

/// Cart item model
class CartItem {
  final String productId;
  final String name;
  final double price;
  final String? imageUrl;
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    this.imageUrl,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

/// Cart state management
class CartState extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.total);
  
  bool get isEmpty => _items.isEmpty;

  /// Add item to cart (or increase quantity if exists)
  void addItem({
    required String productId,
    required String name,
    required double price,
    String? imageUrl,
    int quantity = 1,
  }) {
    final existingIndex = _items.indexWhere((i) => i.productId == productId);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        productId: productId,
        name: name,
        price: price,
        imageUrl: imageUrl,
        quantity: quantity,
      ));
    }
    notifyListeners();
  }

  /// Remove item from cart
  void removeItem(String productId) {
    _items.removeWhere((i) => i.productId == productId);
    notifyListeners();
  }

  /// Update item quantity
  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((i) => i.productId == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  /// Decrease quantity by 1
  void decrementQuantity(String productId) {
    final index = _items.indexWhere((i) => i.productId == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  /// Increase quantity by 1
  void incrementQuantity(String productId) {
    final index = _items.indexWhere((i) => i.productId == productId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  /// Clear all items
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
