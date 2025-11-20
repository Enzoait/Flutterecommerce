import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductDetailViewModel extends ChangeNotifier {
  Product? _product;
  bool _isLoading = false;

  Product? get product => _product;
  bool get isLoading => _isLoading;

  Future<void> fetchProduct(String productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('https://fakestoreapi.com/products/$productId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        _product = Product.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
