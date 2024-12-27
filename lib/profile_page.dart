import 'package:flutter/material.dart';
import 'editprofile_page.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  final List<Map<String, dynamic>> orders; // List of orders
  final Function onLogout; // Callback for logout

  ProfilePage({required this.username, required this.orders, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, $username!'),
            const SizedBox(height: 16),
            const Text("Your Orders:", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return ListTile(
                    title: Text("Order #${index + 1}"),
                    subtitle: Text("Estimated delivery: ${order['deliveryTime']}"),
                    onTap: () {
                      _showOrderDetails(context, order);
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                onLogout(); // Call the logout function
              },
              child: const Text("Logout"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                      username: username,
                      onProfileUpdated: (newPassword) {
                        // Handle profile update logic if needed
                      },
                    ),
                  ),
                );
              },
              child: const Text("Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Order Details"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...order['items'].map<Widget>((item) {
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text("Price: \$${item['price']}"),
                  );
                }).toList(),
                Text("Estimated delivery time: ${order['deliveryTime']}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}