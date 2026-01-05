import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/empty_state.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
        backgroundColor: AppColors.primary,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Processing'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList('all'),
          _buildOrderList('pending'),
          _buildOrderList('processing'),
          _buildOrderList('completed'),
        ],
      ),
    );
  }

  Widget _buildOrderList(String status) {
    final orders = _getDemoOrders(status);

    if (orders.isEmpty) {
      return EmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'No orders found',
        message: 'Orders will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = order['status'] as String;
    Color statusColor;
    switch (status) {
      case 'pending':
        statusColor = AppColors.warning;
        break;
      case 'processing':
        statusColor = AppColors.info;
        break;
      case 'completed':
        statusColor = AppColors.success;
        break;
      default:
        statusColor = AppColors.neutral400;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order['id']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Customer: ${order['customer']}',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Date: ${order['date']}',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Total: \$${order['total']}',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                if (status == 'pending')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateOrderStatus(order['id'], 'processing'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.info,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Process'),
                    ),
                  ),
                if (status == 'processing')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _updateOrderStatus(order['id'], 'completed'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Complete'),
                    ),
                  ),
                if (status != 'completed') const SizedBox(width: AppSpacing.sm),
                if (status != 'completed')
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _viewOrderDetails(order['id']),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('View Details'),
                    ),
                  ),
                if (status == 'completed')
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _viewOrderDetails(order['id']),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('View Details'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateOrderStatus(int orderId, String newStatus) {
    // TODO: Implement API call
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order #$orderId updated to $newStatus'),
        backgroundColor: AppColors.success,
      ),
    );
    setState(() {});
  }

  void _viewOrderDetails(int orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order #$orderId Details'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: John Doe'),
            SizedBox(height: 8),
            Text('Items:'),
            Text('  • Product A x 2 - \$50.00'),
            Text('  • Product B x 1 - \$25.00'),
            SizedBox(height: 8),
            Text('Subtotal: \$75.00'),
            Text('Shipping: \$5.00'),
            Text('Total: \$80.00'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getDemoOrders(String filter) {
    final allOrders = [
      {
        'id': 1001,
        'customer': 'John Doe',
        'date': '2026-01-05',
        'total': 89.99,
        'status': 'pending',
      },
      {
        'id': 1002,
        'customer': 'Jane Smith',
        'date': '2026-01-04',
        'total': 129.50,
        'status': 'processing',
      },
      {
        'id': 1003,
        'customer': 'Bob Johnson',
        'date': '2026-01-03',
        'total': 45.00,
        'status': 'completed',
      },
      {
        'id': 1004,
        'customer': 'Alice Brown',
        'date': '2026-01-05',
        'total': 199.99,
        'status': 'pending',
      },
      {
        'id': 1005,
        'customer': 'Charlie Wilson',
        'date': '2026-01-02',
        'total': 75.25,
        'status': 'completed',
      },
    ];

    if (filter == 'all') return allOrders;
    return allOrders.where((o) => o['status'] == filter).toList();
  }
}
