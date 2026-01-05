import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/state/auth_state.dart';
import '../../../core/state/cart_state.dart';
import '../../../core/state/order_state.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedAddressIndex = 0;
  int _selectedPaymentIndex = 0;
  bool _isProcessing = false;

  final _addresses = [
    {'name': 'Rumah', 'address': 'Jl. Sudirman No. 123, Jakarta Selatan', 'phone': '081234567890'},
    {'name': 'Kantor', 'address': 'Jl. Thamrin No. 456, Jakarta Pusat', 'phone': '081234567891'},
  ];

  final _paymentMethods = [
    {'name': 'COD', 'icon': Icons.local_shipping_outlined, 'desc': 'Bayar di tempat'},
    {'name': 'Transfer Bank', 'icon': Icons.account_balance_outlined, 'desc': 'BCA, Mandiri, BRI'},
    {'name': 'E-Wallet', 'icon': Icons.account_balance_wallet_outlined, 'desc': 'GoPay, OVO, DANA'},
  ];

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartState>();
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final shippingCost = 15000.0;
    final total = cart.totalPrice + shippingCost;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipping Address
            _buildSectionTitle('Alamat Pengiriman'),
            const SizedBox(height: 12),
            _buildAddressSection(),
            
            const SizedBox(height: 24),
            
            // Payment Method
            _buildSectionTitle('Metode Pembayaran'),
            const SizedBox(height: 12),
            _buildPaymentSection(),
            
            const SizedBox(height: 24),
            
            // Order Summary
            _buildSectionTitle('Ringkasan Pesanan'),
            const SizedBox(height: 12),
            _buildOrderSummary(cart, currencyFormat),
            
            const SizedBox(height: 24),
            
            // Price Breakdown
            _buildPriceBreakdown(cart, currencyFormat, shippingCost, total),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, cart, currencyFormat, total),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      children: _addresses.asMap().entries.map((entry) {
        final index = entry.key;
        final addr = entry.value;
        final isSelected = index == _selectedAddressIndex;
        
        return GestureDetector(
          onTap: () => setState(() => _selectedAddressIndex = index),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withAlpha(15) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.neutral400,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            addr['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          if (index == 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(25),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Utama',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        addr['address']!,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        addr['phone']!,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      children: _paymentMethods.asMap().entries.map((entry) {
        final index = entry.key;
        final method = entry.value;
        final isSelected = index == _selectedPaymentIndex;
        
        return GestureDetector(
          onTap: () => setState(() => _selectedPaymentIndex = index),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withAlpha(15) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withAlpha(25) : AppColors.neutral100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    method['icon'] as IconData,
                    color: isSelected ? AppColors.primary : AppColors.neutral600,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method['name'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        method['desc'] as String,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.neutral400,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrderSummary(CartState cart, NumberFormat format) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: cart.items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.neutral100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.shopping_bag_outlined, color: AppColors.neutral400),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${item.quantity}x ${format.format(item.price)}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  format.format(item.total),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPriceBreakdown(CartState cart, NumberFormat format, double shipping, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _priceRow('Subtotal (${cart.itemCount} item)', format.format(cart.totalPrice)),
          const SizedBox(height: 8),
          _priceRow('Ongkos Kirim', format.format(shipping)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                format.format(total),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, CartState cart, NumberFormat format, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Pembayaran',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  Text(
                    format.format(total),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isProcessing ? null : () => _placeOrder(context, cart),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Buat Pesanan',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _placeOrder(BuildContext context, CartState cart) async {
    setState(() => _isProcessing = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      final orderState = context.read<OrderState>();
      final selectedAddr = _addresses[_selectedAddressIndex];
      final selectedPayment = _paymentMethods[_selectedPaymentIndex]['name'] as String;
      
      // Create order items from cart
      final orderItems = cart.items.map((item) => OrderItem(
        productId: item.productId,
        name: item.name,
        price: item.price,
        quantity: item.quantity,
      )).toList();
      
      // Get current user ID
      final auth = context.read<AuthState>();
      final userId = auth.user?.id.toString() ?? '0';
      
      // Create order via OrderState
      final orderId = orderState.createOrder(
        userId: userId,
        items: orderItems,
        address: '${selectedAddr['name']}: ${selectedAddr['address']}',
        paymentMethod: selectedPayment,
        subtotal: cart.totalPrice,
        shipping: 15000,
      );
      
      // Clear cart
      cart.clear();
      
      // Navigate to success
      context.go('/order-success/$orderId');
    }
  }
}
