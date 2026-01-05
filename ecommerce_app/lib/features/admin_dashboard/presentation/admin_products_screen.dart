import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../catalog/data/models/product_model.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  String _filterCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildProductList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/admin/products/add'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: Colors.white,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.neutral200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.neutral200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          filled: true,
          fillColor: AppColors.neutral50,
        ),
      ),
    );
  }

  Widget _buildProductList() {
    // Demo data - replace with actual API call
    final products = _getDemoProducts();

    if (products.isEmpty) {
      return EmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'No products found',
        message: 'Add your first product to get started',
        actionLabel: 'Add Product',
        onAction: () => context.push('/admin/products/add'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.neutral100,
            borderRadius: BorderRadius.circular(8),
            image: product.imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(product.imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: product.imageUrl == null
              ? const Icon(Icons.image, color: AppColors.neutral400)
              : null,
        ),
        title: Text(
          product.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Stock: ${product.stock}',
              style: TextStyle(
                color: product.stock < 10 ? AppColors.error : AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const ListTile(
                leading: Icon(Icons.edit, size: 20),
                title: Text('Edit'),
                contentPadding: EdgeInsets.zero,
              ),
              onTap: () {
                Future.delayed(Duration.zero, () {
                  context.push('/admin/products/edit/${product.id}');
                });
              },
            ),
            PopupMenuItem(
              child: const ListTile(
                leading: Icon(Icons.delete, size: 20, color: AppColors.error),
                title: Text('Delete', style: TextStyle(color: AppColors.error)),
                contentPadding: EdgeInsets.zero,
              ),
              onTap: () {
                Future.delayed(Duration.zero, () {
                  _showDeleteConfirmation(product);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Products'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All'),
              leading: Radio<String>(
                value: 'All',
                groupValue: _filterCategory,
                onChanged: (value) {
                  setState(() => _filterCategory = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Electronics'),
              leading: Radio<String>(
                value: 'Electronics',
                groupValue: _filterCategory,
                onChanged: (value) {
                  setState(() => _filterCategory = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Fashion'),
              leading: Radio<String>(
                value: 'Fashion',
                groupValue: _filterCategory,
                onChanged: (value) {
                  setState(() => _filterCategory = value!);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement delete
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product deleted successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  List<Product> _getDemoProducts() {
    return [
      Product(
        id: 1,
        name: 'Wireless Headphones',
        price: 89.99,
        description: 'Premium wireless headphones',
        categoryId: 1,
        stock: 45,
        imageUrl: 'https://via.placeholder.com/200',
        createdAt: DateTime.now(),
      ),
      Product(
        id: 2,
        name: 'Smart Watch',
        price: 199.99,
        description: 'Advanced fitness tracker',
        categoryId: 1,
        stock: 8,
        imageUrl: 'https://via.placeholder.com/200',
        createdAt: DateTime.now(),
      ),
      Product(
        id: 3,
        name: 'Running Shoes',
        price: 129.99,
        description: 'Comfortable running shoes',
        categoryId: 2,
        stock: 23,
        imageUrl: 'https://via.placeholder.com/200',
        createdAt: DateTime.now(),
      ),
    ];
  }
}
