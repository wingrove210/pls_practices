import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isFavorite;
  final Function(Map<String, dynamic>) onFavoriteToggle;

  const ProductDetails({
    Key? key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,  // This makes the body extend behind the AppBar
      appBar: AppBar(
        title: Text(
          product['name'],
          style: const TextStyle(color: Colors.white), // Set the text color to white
        ),
        backgroundColor: Colors.transparent, // Set the app bar to transparent
        elevation: 0, // Remove the shadow
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            color: isFavorite ? Colors.red : null,
            onPressed: () => onFavoriteToggle(product),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.grey,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // Center the column items
              children: [
                // Check if the image is a URL or an asset
                product['image'] is String && product['image']!.startsWith('http')
                    ? Image.network(
                        product['image'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        product['image'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                const SizedBox(height: 16),
                Text(
                  product['name'],
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${product['price'].toString()}', // Convert the price to a string
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                const Text(
                  'This is a detailed description of the product.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
