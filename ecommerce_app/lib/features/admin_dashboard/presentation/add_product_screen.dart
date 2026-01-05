import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';

class AddProductScreen extends StatefulWidget {
  final String? productId;
  
  const AddProductScreen({super.key, this.productId});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController();
  
  String? _selectedCategory;
  List<File> _images = [];
  bool _isLoading = false;

  final List<String> _categories = [
    'Electronics',
    'Fashion',
    'Home & Garden',
    'Sports',
    'Books',
    'Toys',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _images.add(File(image.path));
      });
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Implement API call to save product
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.productId != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Product' : 'Add Product'),
        backgroundColor: AppColors.primary,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProduct,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _buildImageSection(),
            const SizedBox(height: AppSpacing.lg),
            _buildTextField(
              controller: _nameController,
              label: 'Product Name',
              hint: 'Enter product name',
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(
              controller: _priceController,
              label: 'Price',
              hint: '0.00',
              keyboardType: TextInputType.number,
              prefixText: '\$ ',
              validator: (v) {
                if (v?.isEmpty ?? true) return 'Required';
                if (double.tryParse(v!) == null) return 'Invalid price';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _buildCategoryDropdown(),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(
              controller: _stockController,
              label: 'Stock Quantity',
              hint: '0',
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v?.isEmpty ?? true) return 'Required';
                if (int.tryParse(v!) == null) return 'Invalid quantity';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Enter product description',
              maxLines: 5,
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Images',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ..._images.map((image) => _buildImageCard(image)),
              _buildAddImageCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageCard(File image) {
    return Container(
      width: 120,
      height: 120,
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: FileImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _images.remove(image);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageCard() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.neutral100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.neutral300,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, color: AppColors.neutral400, size: 32),
            const SizedBox(height: 4),
            Text(
              'Add Image',
              style: TextStyle(
                color: AppColors.neutral500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? prefixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefixText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: AppColors.neutral50,
          ),
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: InputDecoration(
            hintText: 'Select category',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: AppColors.neutral50,
          ),
          items: _categories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
          validator: (v) => v == null ? 'Please select a category' : null,
        ),
      ],
    );
  }
}
