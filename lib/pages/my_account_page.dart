import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  // Define variables for user's personal information
  String _name = '';
  String _email = '';
  String _password = '';
  String _newPassword = '';
  String _confirmPassword = '';

  // Define a function to update user's personal information
  void _updateUserInfo() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Update the user's email
        await user.updateEmail(_email);

        // Update the user's password
        if (_newPassword.isNotEmpty && _newPassword == _confirmPassword) {
          await user.updatePassword(_newPassword);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Passwords do not match. Please try again.')),
          );
          return;  // Exit the function if passwords don't match
        }

        // Update the user's display name
        await user.updateProfile(displayName: _name);

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User information updated successfully.')),
        );
      } else {
        // Show an error message if no user is signed in
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user is currently signed in.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle the error
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Weak password. Please choose a stronger password.')),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email already in use. Please choose a different email.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An error occurred while updating user information.')),
        );
      }
    } catch (e) {
      // Handle any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while updating user information.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'New Password'),
              onChanged: (value) {
                setState(() {
                  _newPassword = value;
                });
              },
              obscureText: true,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Confirm New Password'),
              onChanged: (value) {
                setState(() {
                  _confirmPassword = value;
                });
              },
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateUserInfo,
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
