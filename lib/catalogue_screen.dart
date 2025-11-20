import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'viewmodels/cart_view_model.dart';
import 'viewmodels/catalogue_view_model.dart';

class CatalogueScreen extends StatelessWidget {
  const CatalogueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CatalogueViewModel(),
      child: const CatalogueView(),
    );
  }
}

class CatalogueView extends StatefulWidget {
  const CatalogueView({super.key});

  @override
  State<CatalogueView> createState() => _CatalogueViewState();
}

class _CatalogueViewState extends State<CatalogueView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      Provider.of<CatalogueViewModel>(context, listen: false)
          .filterProducts(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);
    final catalogueViewModel = Provider.of<CatalogueViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue'),
        automaticallyImplyLeading: false,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Search for products by title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Go to homepage'),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Consumer<CatalogueViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (viewModel.filteredProducts.isEmpty) {
                  return const Center(child: Text('No products found.'));
                } else {
                  return ListView.builder(
                    itemCount: viewModel.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = viewModel.filteredProducts[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.network(
                            product.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(product.title),
                          subtitle: Text('\$${product.price}'),
                          onTap: () => context.go('/product/${product.id}'),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
