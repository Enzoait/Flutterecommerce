
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];
  List<List<Map<String, dynamic>>> _orders = [];

  CartProvider();

  List<Map<String, dynamic>> get items => _items;
  List<List<Map<String, dynamic>>> get orders => _orders;

  void add(Map<String, dynamic> product) {
    for (var item in _items) {
      if (item['id'] == product['id']) {
        item['quantity'] = (item['quantity'] ?? 0) + 1;
        notifyListeners();
        return;
      }
    }
    _items.add({...product, 'quantity': 1});
    notifyListeners();
  }

  void remove(Map<String, dynamic> product) {
    for (var item in List.from(_items)) {
      if (item['id'] == product['id']) {
        if ((item['quantity'] ?? 0) > 1) {
          item['quantity']--;
        } else {
          _items.remove(item);
        }
        notifyListeners();
        return;
      }
    }
  }

  void removeItem(Map<String, dynamic> product) {
    _items.removeWhere((item) => item['id'] == product['id']);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  Future<void> placeOrder() async {
    _orders.add(items.map((item) => Map<String, dynamic>.from(item)).toList());
    await _saveOrders();
    clear();
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = jsonEncode(_orders);
    await prefs.setString('orders', ordersJson);
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getString('orders');
    if (ordersJson != null) {
      final decodedOrders = jsonDecode(ordersJson);
      _orders = (decodedOrders as List)
          .map((order) => (order as List)
              .map((item) => Map<String, dynamic>.from(item))
              .toList())
          .toList();
      notifyListeners();
    }
  }

  int get itemCount {
    return _items.fold(0, (total, item) => total + ((item['quantity'] as num?)?.toInt() ?? 0));
  }

  double get totalPrice {
    return _items.fold(0.0, (total, item) {
      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
      final quantity = (item['quantity'] as num?)?.toInt() ?? 0;
      return total + (price * quantity);
    });
  }
}
