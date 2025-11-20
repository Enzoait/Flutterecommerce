import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartViewModel extends ChangeNotifier {
  final List<CartItem> _items = [];
  List<List<CartItem>> _orders = [];

  CartViewModel() {
    loadOrders();
  }

  List<CartItem> get items => _items;
  List<List<CartItem>> get orders => _orders;

  void add(Product product) {
    for (var item in _items) {
      if (item.product.id == product.id) {
        item.quantity++;
        notifyListeners();
        return;
      }
    }
    _items.add(CartItem(product: product));
    notifyListeners();
  }

  void remove(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
    } else {
      _items.remove(cartItem);
    }
    notifyListeners();
  }

  void removeItem(CartItem cartItem) {
    _items.remove(cartItem);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  Future<void> placeOrder() async {
    _orders.add(List.from(_items));
    await _saveOrders();
    clear();
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = jsonEncode(_orders.map((order) => order.map((item) => item.toJson()).toList()).toList());
    await prefs.setString('orders', ordersJson);
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getString('orders');
    if (ordersJson != null) {
      final decodedOrders = jsonDecode(ordersJson) as List;
      _orders = decodedOrders
          .map((order) => (order as List)
              .map((item) => CartItem.fromJson(item))
              .toList())
          .toList();
      notifyListeners();
    }
  }

  int get itemCount {
    return _items.fold(0, (total, item) => total + item.quantity);
  }

  double get totalPrice {
    return _items.fold(0.0, (total, item) => total + (item.product.price * item.quantity));
  }
}
