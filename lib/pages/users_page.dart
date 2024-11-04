import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addUser(BuildContext context) async {
    String name = '';
    String email = '';
    String role = 'Viewer'; // Default role

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  name = value;
                },
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(labelText: 'Email'),
              ),
              DropdownButtonFormField<String>(
                value: role,
                onChanged: (value) {
                  role = value!;
                },
                items: ['Admin', 'Editor', 'Viewer'].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Role'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (name.isNotEmpty && email.isNotEmpty) {
                  await _firestore.collection('users').add({
                    'name': name,
                    'email': email,
                    'role': role,
                    'vehicles': [], // Initially no vehicles assigned
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editUser(BuildContext context, DocumentSnapshot userDoc) async {
    String name = userDoc['name'];
    String email = userDoc['email'];
    String role = userDoc['role'];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: name),
                onChanged: (value) {
                  name = value;
                },
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: TextEditingController(text: email),
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(labelText: 'Email'),
              ),
              DropdownButtonFormField<String>(
                value: role,
                onChanged: (value) {
                  role = value!;
                },
                items: ['Admin', 'Editor', 'Viewer'].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Role'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (name.isNotEmpty && email.isNotEmpty) {
                  await _firestore.collection('users').doc(userDoc.id).update({
                    'name': name,
                    'email': email,
                    'role': role,
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  Future<void> _assignVehicle(BuildContext context, DocumentSnapshot userDoc) async {
    String selectedVehicle = '';

    // Assuming you have a 'vehicles' collection in Firestore
    QuerySnapshot vehiclesSnapshot = await _firestore.collection('vehicles').get();
    List<String> vehicleList = vehiclesSnapshot.docs
        .map((doc) => doc['name'] as String?)
        .where((name) => name != null)
        .cast<String>()
        .toList();


    if (vehicleList.isEmpty) {
      // No vehicles available
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No vehicles available to assign.'),
      ));
      return;
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Assign Vehicle'),
          content: DropdownButtonFormField<String>(
            value: selectedVehicle.isEmpty ? vehicleList.first : selectedVehicle,
            onChanged: (value) {
              selectedVehicle = value!;
            },
            items: vehicleList.map((String vehicle) {
              return DropdownMenuItem<String>(
                value: vehicle,
                child: Text(vehicle),
              );
            }).toList(),
            decoration: InputDecoration(labelText: 'Vehicle'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (selectedVehicle.isNotEmpty) {
                  List<dynamic> vehicles = userDoc['vehicles'];
                  vehicles.add(selectedVehicle);
                  await _firestore.collection('users').doc(userDoc.id).update({
                    'vehicles': vehicles,
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Assign'),
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
        title: Text('Manage Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _addUser(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return ListTile(
                title: Text(document['name']),
                subtitle: Text(document['email']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: document['role'],
                      items: ['Admin', 'Editor', 'Viewer'].map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (String? newRole) {
                        _firestore.collection('users').doc(document.id).update({'role': newRole});
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editUser(context, document);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteUser(document.id);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.directions_car),
                      onPressed: () {
                        _assignVehicle(context, document);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
