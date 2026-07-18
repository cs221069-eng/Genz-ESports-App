import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/shop_product.dart';

class ProductService {
  ProductService._();

  static final ProductService instance = ProductService._();
  static const String _baseUrl = 'https://final-year-backend-pi.vercel.app';

  Future<List<ShopProduct>> fetchProducts() async {
    final uri = Uri.parse('$_baseUrl/api/products');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Unable to fetch products');
    }

    final body = jsonDecode(response.body) as List<dynamic>;
    return body
        .map((item) => ShopProduct.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
