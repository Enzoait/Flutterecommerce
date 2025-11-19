import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];
  final List<List<Map<String, dynamic>>> _orders = [];

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

  void placeOrder() {
    _orders.add(items.map((item) => Map<String, dynamic>.from(item)).toList());
    clear();
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
