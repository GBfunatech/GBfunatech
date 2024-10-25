import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed of to free up resources
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void saveContact() {
    // Implement your logic to save the contact information
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String phoneNumber = _phoneNumberController.text;
    final String address = _addressController.text;

    if (name.isEmpty || email.isEmpty || phoneNumber.isEmpty || address.isEmpty) {
      _showErrorDialog('Please fill in all fields.');
      return;
    }

    // Example: print to console (replace with your actual save logic)
    print('Name: $name');
    print('Email: $email');
    print('Phone Number: $phoneNumber');
    print('Address: $address');

    // Clear the fields after saving
    _nameController.clear();
    _emailController.clear();
    _phoneNumberController.clear();
    _addressController.clear();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: saveContact,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
