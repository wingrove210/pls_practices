import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProductsPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function() onUpdate;

  const EditProductsPage({Key? key, required this.products, required this.onUpdate}) : super(key: key);

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
          backgroundColor: Colors.transparent, // Ensure the gradient shows
          appBar: AppBar(
            backgroundColor: Colors.transparent, // Transparent AppBar
            elevation: 0, // Remove the shadow
            title: const Text(
              "Edit Products",
              style: TextStyle(color: Colors.white), // White text for the title
            ),
            iconTheme: const IconThemeData(color: Colors.white), // White icons
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _showAddDialog(context);
                },
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product['name'], style: const TextStyle(color: Colors.white)),
                subtitle: Text('Price: ${product['price']}', style: const TextStyle(color: Colors.white)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        _showEditDialog(context, product);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        _deleteProduct(context, product);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> product) {
    final TextEditingController nameController = TextEditingController(text: product['name']);
    final TextEditingController priceController = TextEditingController(text: product['price'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Product Name"),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Product Price"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final updatedProduct = {
                  'name': nameController.text,
                  'price': double.tryParse(priceController.text) ?? 0.0,
                };

                final response = await http.put(
                  Uri.parse('http://10.0.2.2:8000/products/${product['id']}'),
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode(updatedProduct),
                );

                if (response.statusCode == 200) {
                  onUpdate(); // Update the products list
                  Navigator.of(context).pop();
                } else {
                  print('Failed to update product: ${response.body}');
                }
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Product"),
          content: const Text("Are you sure you want to delete this product?"),
          actions: [
            TextButton(
              onPressed: () async {
                final response = await http.delete(
                  Uri.parse('http://10.0.2.2:8000/products/${product['id']}'),
                );

                if (response.statusCode == 204) {
                  products.remove(product); // Remove product from the local list
                  onUpdate(); // Update the catalog
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  print('Failed to delete product: ${response.body}');
                }
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Product Name"),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Product Price"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final newProduct = {
                  'name': nameController.text,
                  'price': double.tryParse(priceController.text) ?? 0.0,
                };

                final response = await http.post(
                  Uri.parse('http://10.0.2.2:8000/products/'),
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode(newProduct),
                );

                if (response.statusCode == 201) {
                  onUpdate(); // Update the products list
                  Navigator.of(context).pop();
                } else {
                  print('Failed to add product: ${response.body}');
                }
              },
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
