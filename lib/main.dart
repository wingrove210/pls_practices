import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'product_details.dart';
import 'cart_page.dart';
import 'favorites_page.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'edit_page.dart'; // Import the edit products page
import 'profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellowAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'JEWELRY SHOP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> products = [];
  final List<Map<String, dynamic>> cartItems = [];
  final List<Map<String, dynamic>> favoriteItems = [];
  final List<Map<String, dynamic>> orders = []; // List to store orders
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    const String apiUrl = 'http://10.0.2.2:8000/products/';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> fetchedProducts = json.decode(response.body);
        setState(() {
          products = fetchedProducts.cast<Map<String, dynamic>>();
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  void _openProductDetails(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetails(
          product: product,
          isFavorite: favoriteItems.contains(product),
          onFavoriteToggle: _toggleFavorite,
        ),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      cartItems.add(product);
    });
  }

  void _removeFromCart(Map<String, dynamic> product) {
    setState(() {
      cartItems.remove(product);
    });
  }

  void _toggleFavorite(Map<String, dynamic> product) {
    setState(() {
      if (favoriteItems.contains(product)) {
        favoriteItems.remove(product);
      } else {
        favoriteItems.add(product);
      }
    });
  }

  int _getProductCount(Map<String, dynamic> product) {
    return cartItems.where((item) => item == product).length;
  }

  void _logout() {
    setState(() {
      _userName = null; // Clear the username
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(onLoginSuccess: _onLoginSuccess),
      ),
    );
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
          cartItems: cartItems,
          onRemove: _removeFromCart,
          onOrder: _placeOrder, // Pass the order function
        ),
      ),
    );
  }

  void _openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesPage(
          favoriteItems: favoriteItems,
          onRemove: _toggleFavorite,
        ),
      ),
    );
  }

  void _onLoginSuccess(String username, String token) {
    setState(() {
      _userName = username;
    });
  }

  void _openLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(onLoginSuccess: _onLoginSuccess),
      ),
    );
  }

  void _openRegistrationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationPage(
          onRegistrationSuccess: _onLoginSuccess,
        ),
      ),
    );
  }

  void _openEditProductsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductsPage(
          products: List.from(products),
          onUpdate: _loadProducts,
        ),
      ),
    ).then((_) => _loadProducts());
  }

  void _openProfilePage() {
    if (_userName != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            username: _userName!,
            orders: orders,
            onLogout: _logout, // Pass the logout function
          ),
        ),
      );
    }
  }

  void _placeOrder(List<Map<String, dynamic>> items, DateTime orderTime) {
    final order = {
      'items': items,
      'deliveryTime': orderTime.add(const Duration(hours: 1)).toString(), // Example delivery time
    };
    setState(() {
      orders.add(order); // Add the order to the list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Order placed successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent, // Transparent background
            elevation: 0, // Remove shadow
            iconTheme: const IconThemeData(color: Colors.white), // White icons
            title: Text(
              widget.title,
              style: const TextStyle(color: Colors.white), // White text
            ),
            actions: [
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: _openCart,
                  ),
                  if (cartItems.isNotEmpty)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          '${cartItems.length}',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed: _openFavorites,
                  ),
                  if (favoriteItems.isNotEmpty)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          '${favoriteItems.length}',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: products.map((product) {
                  final isFavorite = favoriteItems.contains(product);
                  final productCount = _getProductCount(product);
                  return GestureDetector(
                    onTap: () => _openProductDetails(product),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black,
                                Colors.grey,
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Stack(
                            children: [
                              Center( // Center the content vertically and horizontally
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,  // Centers content vertically
                                    crossAxisAlignment: CrossAxisAlignment.center,  // Centers content horizontally
                                    children: [
                                      // Display the product image
                                      Image.network(
                                        product['image'], // Ensure your product contains an 'image_url' key
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        product['name'],
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        textAlign: TextAlign.center,  // Center the product name
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product['price'].toString(),
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      const SizedBox(height: 8),
                                      if (productCount == 0)
                                        ElevatedButton(
                                          onPressed: () => _addToCart(product),
                                          child: const Text("Add to Cart"),
                                        )
                                      else
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove),
                                              onPressed: () => _removeFromCart(product),
                                            ),
                                            Text('$productCount'),
                                            IconButton(
                                              icon: const Icon(Icons.add),
                                              onPressed: () => _addToCart(product),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : Colors.white,
                                  ),
                                  onPressed: () => _toggleFavorite(product),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.login),
                  onPressed: _openLoginPage,
                  tooltip: 'Login',
                ),
                IconButton(
                  icon: const Icon(Icons.app_registration),
                  onPressed: _openRegistrationPage,
                  tooltip: 'Register',
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _openEditProductsPage,
                  tooltip: 'Edit Products',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
