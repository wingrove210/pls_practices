import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  final String username;
  final Function(String) onProfileUpdated; // Callback for profile update

  const EditProfilePage({
    Key? key,
    required this.username,
    required this.onProfileUpdated,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    const String apiUrl = 'http://127.0.0.1:8000/users/profile'; // Update to your FastAPI profile update endpoint

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer',
        },
        body: json.encode({
          'username': widget.username,
          'new_password': _newPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        widget.onProfileUpdated(_newPasswordController.text); // Notify the main page
        Navigator.pop(context); // Go back to the profile page
      } else {
        setState(() {
          _errorMessage = 'Failed to update profile. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error updating profile. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _newPasswordController,
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateProfile,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Update Profile'),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}