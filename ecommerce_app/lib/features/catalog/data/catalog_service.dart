import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/network/api_client.dart';
import 'models/category_model.dart';
import 'models/product_model.dart';

class CatalogService {
  final http.Client _client;

  CatalogService({http.Client? client}) : _client = client ?? http.Client();

  /// Get all categories
  Future<List<Category>> getCategories() async {
    try {
      final response = await _client
          .get(
            Uri.parse('${ApiConfig.baseUrl}/categories'),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data'] as List;
        return data.map((item) => Category.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading categories: $e');
    }
  }

  /// Get all products
  Future<List<Product>> getProducts({int? categoryId}) async {
    try {
      String url = categoryId != null
          ? '${ApiConfig.baseUrl}/products/category/$categoryId'
          : '${ApiConfig.baseUrl}/products';

      final response = await _client
          .get(Uri.parse(url))
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data'] as List;
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading products: $e');
    }
  }

  /// Get product by ID
  Future<Product> getProductById(int id) async {
    try {
      final response = await _client
          .get(Uri.parse('${ApiConfig.baseUrl}/products/$id'))
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Product.fromJson(jsonData['data']);
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading product: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
