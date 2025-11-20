import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class CatalogueViewModel extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;

  List<Product> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;

  CatalogueViewModel() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('https://fakestoreapi.com/products');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> productJson = jsonDecode(response.body);
        _products = productJson.map((json) => Product.fromJson(json)).toList();
        _filteredProducts = _products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
