import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Map<String, dynamic>> _productFuture;
  static final bool isIOS = !kIsWeb && Platform.isIOS;

  @override
  void initState() {
    super.initState();
    _productFuture = fetchProduct();
  }

  Future<Map<String, dynamic>> fetchProduct() async {
    final url = Uri.parse('https://fakestoreapi.com/products/${widget.productId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load product: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    if (isIOS) {
      return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: const Text('Product Details'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  onPressed: () => context.go('/order-history'),
                  child: const Icon(CupertinoIcons.time),
                ),
                CupertinoButton(
                  onPressed: () => context.go('/cart'),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(CupertinoIcons.shopping_cart),
                      if (cart.itemCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: Text(
                              '${cart.itemCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              CupertinoButton(
                onPressed: () => context.go('/catalogue'),
                child: const Text('Return to the catalogue'),
              ),
              const SizedBox(height: 10),
              FutureBuilder<Map<String, dynamic>>(
                future: _productFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('Product not found.'));
                  } else {
                    final product = snapshot.data!;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.network(
                              product['image'],
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            product['title'],
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '\$${product['price']}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Text(product['description']),
                          const SizedBox(height: 20),
                          Center(
                            child: CupertinoButton.filled(
                              onPressed: () {
                                cart.add(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Product added to cart!'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: const Text('Add to cart'),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ));
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product Details'),
          actions: [
            IconButton(
              onPressed: () => context.go('/order-history'),
              icon: const Icon(Icons.history),
            ),
            IconButton(
              onPressed: () => context.go('/cart'),
              icon: Badge(
                label: Text('${cart.itemCount}'),
                child: const Icon(Icons.shopping_cart),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go('/catalogue'),
              child: const Text('Return to the catalogue'),
            ),
            const SizedBox(height: 10),
            FutureBuilder<Map<String, dynamic>>(
              future: _productFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('Product not found.'));
                } else {
                  final product = snapshot.data!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.network(
                            product['image'],
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          product['title'],
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '\$${product['price']}',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        Text(product['description']),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              cart.add(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Product added to cart!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: const Text('Add to cart'),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ));
  }
}
