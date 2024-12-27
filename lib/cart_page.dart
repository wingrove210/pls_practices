import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(Map<String, dynamic>) onRemove;
  final Function(List<Map<String, dynamic>>, DateTime) onOrder; // Callback for placing an order

  const CartPage({
    Key? key,
    required this.cartItems,
    required this.onRemove,
    required this.onOrder,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _placeOrder() {
    if (widget.cartItems.isNotEmpty) {
      DateTime orderTime = DateTime.now();
      widget.onOrder(widget.cartItems, orderTime); // Pass the cart items and order time
      widget.cartItems.clear(); // Clear the cart after placing the order
      Navigator.pop(context); // Go back to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your cart is empty")),
      );
    }
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
          backgroundColor: Colors.transparent, // Ensure the gradient shows
          appBar: AppBar(
            backgroundColor: Colors.transparent, // Transparent AppBar
            elevation: 0, // Remove the shadow
            title: const Text(
              "Your Cart",
              style: TextStyle(color: Colors.white), // White text for the title
            ),
            iconTheme: const IconThemeData(color: Colors.white), // White icons
          ),
          body: widget.cartItems.isEmpty
              ? const Center(child: Text("Your cart is empty", style: TextStyle(color: Colors.white)))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = widget.cartItems[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item['image'], // Display the product image
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(item['name'], style: const TextStyle(color: Colors.white)),
                                subtitle: Text("\$${item['price']}", style: const TextStyle(color: Colors.white)), // Display price
                                trailing: IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
                                  onPressed: () {
                                    widget.onRemove(item);
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _placeOrder,
                      child: const Text("Order", style: TextStyle(color: Colors.white)), // Button to place the order
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
