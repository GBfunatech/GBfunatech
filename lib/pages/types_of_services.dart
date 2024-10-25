import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String iconName;  // Icon represented as a string
  final String title;

  Service({required this.iconName, required this.title});
}

class ServiceTypePage extends StatefulWidget {
  const ServiceTypePage({Key? key}) : super(key: key);

  @override
  _ServiceTypePageState createState() => _ServiceTypePageState();
}

class _ServiceTypePageState extends State<ServiceTypePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch services from Firestore
  Stream<QuerySnapshot> _getServicesStream() {
    return _firestore.collection('services').snapshots();
  }

  // Function to add new service to Firestore
  Future<void> _addServiceToFirestore(String title, String iconName) async {
    await _firestore.collection('services').add({
      'title': title,
      'iconName': iconName,
    });
  }

  // Convert string iconName to IconData
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'ac_unit':
        return Icons.ac_unit;
      case 'filter_alt':
        return Icons.filter_alt;
      case 'battery_charging_full':
        return Icons.battery_charging_full;
      case 'build':
        return Icons.build;
      case 'local_gas_station':
        return Icons.local_gas_station;
      case 'car_repair':
        return Icons.car_repair;
      case 'cleaning_services':
        return Icons.cleaning_services;
      case 'check_circle':
        return Icons.check_circle;
      case 'attach_money':
        return Icons.attach_money;
      case 'lightbulb_outline':
        return Icons.lightbulb_outline;
      default:
        return Icons.build;  // Default icon
    }
  }

  // Function to add new service
  Future<void> _addService() async {
    String serviceName = '';
    IconData selectedIcon = Icons.build;  // Default icon

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Service'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  serviceName = value;
                },
                decoration: InputDecoration(labelText: 'Service Name'),
              ),
              DropdownButton<IconData>(
                value: selectedIcon,
                onChanged: (IconData? newIcon) {
                  setState(() {
                    selectedIcon = newIcon!;
                  });
                },
                items: <IconData>[
                  Icons.ac_unit,
                  Icons.filter_alt,
                  Icons.battery_charging_full,
                  Icons.build,
                  Icons.local_gas_station,
                  Icons.car_repair,
                  Icons.cleaning_services,
                  Icons.check_circle,
                  Icons.attach_money,
                  Icons.lightbulb_outline
                ].map<DropdownMenuItem<IconData>>((IconData icon) {
                  return DropdownMenuItem<IconData>(
                    value: icon,
                    child: Icon(icon),
                  );
                }).toList(),
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
              onPressed: () {
                if (serviceName.isNotEmpty) {
                  _addServiceToFirestore(serviceName, selectedIcon.codePoint.toString());  // Save to Firestore
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Types of Service'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getServicesStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var service = snapshot.data!.docs[index];
              return ServiceItem(
                service: Service(
                  iconName: service['iconName'],
                  title: service['title'],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addService,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ServiceItem extends StatelessWidget {
  final Service service;

  const ServiceItem({required this.service});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(_getIconData(service.iconName)),
      title: Text(service.title),
    );
  }

  // Convert string iconName to IconData
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'ac_unit':
        return Icons.ac_unit;
      case 'filter_alt':
        return Icons.filter_alt;
      case 'battery_charging_full':
        return Icons.battery_charging_full;
      case 'build':
        return Icons.build;
      case 'local_gas_station':
        return Icons.local_gas_station;
      case 'car_repair':
        return Icons.car_repair;
      case 'cleaning_services':
        return Icons.cleaning_services;
      case 'check_circle':
        return Icons.check_circle;
      case 'attach_money':
        return Icons.attach_money;
      case 'lightbulb_outline':
        return Icons.lightbulb_outline;
      default:
        return Icons.build;
    }
  }
}
