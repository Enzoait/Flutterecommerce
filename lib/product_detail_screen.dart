import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'viewmodels/cart_view_model.dart';
import 'viewmodels/product_detail_view_model.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductDetailViewModel()..fetchProduct(productId),
      child: const ProductDetailView(),
    );
  }
}

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  static final bool isIOS = !kIsWeb && Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);
    final productDetailViewModel = Provider.of<ProductDetailViewModel>(context);
    final product = productDetailViewModel.product;

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
                      if (cartViewModel.itemCount > 0)
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
                              '${cartViewModel.itemCount}',
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
          child: Column(children: [
            const SizedBox(height: 10),
            CupertinoButton(
              onPressed: () => context.go('/catalogue'),
              child: const Text('Return to the catalogue'),
            ),
            const SizedBox(height: 10),
            productDetailViewModel.isLoading
                ? const Center(child: CupertinoActivityIndicator())
                : product == null
                    ? const Center(child: Text('Product not found.'))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.network(
                                product.image,
                                height: 200,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              product.title,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '\$${product.price}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Text(product.description),
                            const SizedBox(height: 20),
                            Center(
                              child: CupertinoButton.filled(
                                onPressed: () {
                                  cartViewModel.add(product);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Product added to cart!'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: const Text('Add to cart'),
                              ),
                            ),
                          ],
                        ),
                      )
          ]));
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
              label: Text('${cartViewModel.itemCount}'),
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
          productDetailViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : product == null
                  ? const Center(child: Text('Product not found.'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.network(
                              product.image,
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            product.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '\$${product.price}',
                            style:
                                Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          const SizedBox(height: 10),
                          Text(product.description),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                cartViewModel.add(product);
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
                    )
        ],
      ),
    );
  }
}
