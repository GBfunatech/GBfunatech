import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SynchronizeDataPage extends StatefulWidget {
  @override
  _SynchronizeDataPageState createState() => _SynchronizeDataPageState();
}

class _SynchronizeDataPageState extends State<SynchronizeDataPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _syncNow() async {
    try {
      // Logic for syncing data across devices (e.g., updating Firestore)
      User? user = _auth.currentUser;
      if (user != null) {
        // Example: Fetch and update user data
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        // Add your sync logic here
        print("Data synced successfully.");
      }
    } catch (e) {
      print("Error syncing data: $e");
    }
  }

  Future<void> _backupData() async {
    try {
      // Logic for backing up data to the cloud
      User? user = _auth.currentUser;
      if (user != null) {
        // Example: Backup user data to Firestore
        await _firestore.collection('backups').doc(user.uid).set({
          'data': 'Sample data', // Replace with actual data
          'timestamp': FieldValue.serverTimestamp(),
        });
        print("Data backed up successfully.");
      }
    } catch (e) {
      print("Error backing up data: $e");
    }
  }

  Future<void> _restoreData() async {
    try {
      // Logic for restoring data from the cloud
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot backupDoc = await _firestore.collection('backups').doc(user.uid).get();
        if (backupDoc.exists) {
          // Example: Restore data
          print("Data restored successfully: ${backupDoc.data()}");
        } else {
          print("No backup found.");
        }
      }
    } catch (e) {
      print("Error restoring data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Synchronize Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _syncNow,
              icon: Icon(Icons.sync),
              label: Text('Sync Now'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _backupData,
              icon: Icon(Icons.backup),
              label: Text('Backup Data'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _restoreData,
              icon: Icon(Icons.restore),
              label: Text('Restore Data'),
            ),
          ],
        ),
      ),
    );
  }
}
