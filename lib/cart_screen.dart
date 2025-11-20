import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'viewmodels/cart_view_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Go to homepage'),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final cartItem = cart.items[index];
                final product = cartItem.product;
                return ListTile(
                  leading: Image.network(product.image, width: 50, height: 50),
                  title: Text(product.title),
                  subtitle: Text('\$${product.price} x ${cartItem.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          cart.remove(cartItem);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          cart.add(product);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          cart.removeItem(cartItem);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (cart.items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      cart.placeOrder();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('La commande a été passée avec succès'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      context.go('/order-history');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Passer la commande'),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => cart.clear(),
                    child: const Text('Clear Cart'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
