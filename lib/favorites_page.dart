import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteItems;
  final Function(Map<String, dynamic>) onRemove;

  const FavoritesPage({Key? key, required this.favoriteItems, required this.onRemove}) : super(key: key);

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
          backgroundColor: Colors.transparent, // Transparent background for the inner Scaffold
          appBar: AppBar(
            backgroundColor: Colors.transparent, // Transparent AppBar background
            elevation: 0, // Remove shadow
            title: const Text(
              "Favorites",
              style: TextStyle(color: Colors.white), // White text
            ),
            iconTheme: const IconThemeData(color: Colors.white), // White icons
          ),
          body: favoriteItems.isEmpty
              ? const Center(
                  child: Text(
                    "No items in favorites",
                    style: TextStyle(color: Colors.white), // White text for empty list
                  ),
                )
              : ListView.builder(
                  itemCount: favoriteItems.length,
                  itemBuilder: (context, index) {
                    final item = favoriteItems[index];
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
                              item['image'], // Ensure the item contains a valid 'image' URL
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(item['name'], style: const TextStyle(color: Colors.white)),
                          subtitle: Text(item['price'].toString(), style: const TextStyle(color: Colors.white)), // Convert to string
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
                            onPressed: () {
                              onRemove(item);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
