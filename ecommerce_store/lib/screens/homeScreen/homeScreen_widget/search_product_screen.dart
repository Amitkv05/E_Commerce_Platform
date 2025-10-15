import 'package:flutter/material.dart';
import 'package:shopgram/models/products_model.dart';
import 'package:shopgram/provider/products_provider.dart';
import 'package:shopgram/screens/product_items_widget.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<ProductModel> _searchedProducts = [];
  bool _isLoading = false;

  void _searchProducts() async {
    setState(() {
      _isLoading = true; // show loading indicator
    });
    try {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        final products = await ProductsNotifier().searchProducts(query);
        setState(() {
          _searchedProducts = products;
        });
      }
    } catch (e) {
      print('Error searching product: $e');
    } finally {
      setState(() {
        _isLoading = false; // hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // set the number of colume in grid base on the screen width
    // if the screen with is less than 600pixels(w.g.. a phone), use columns
    // if the screen is 600 pixels or more(e.g.. a tablet), use 4 column
    final crossAxisCount = screenWidth < 600 ? 2 : 4;

    // set the aspect ratio ( width-to-height ration) of each grid item base on the screen width
    // for smaller screen(<600 pixels) use a ration of 3.4(taller items)
    // for larger screen(>=600 pixels), use a ration of 4.5(more square-shaped items)
    final childAspectRation = screenWidth < 600 ? 3 / 4 : 4 / 5;

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: "Search products...",
            suffixIcon: IconButton(
              onPressed: _searchProducts,
              icon: Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          if (_isLoading)
            Center(child: CircularProgressIndicator())
          else if (_searchedProducts.isEmpty)
            Center(child: Text('No Product Found'))
          else
            Expanded(
              child: GridView.builder(
                itemCount: _searchedProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: childAspectRation,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final product = _searchedProducts[index];
                  return ProductItemsWidget(product: product);
                },
              ),
            ),
        ],
      ),
    );
  }
}
