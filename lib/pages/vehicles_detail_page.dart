import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import the DatabaseHelper

class VehicleDetailPage extends StatefulWidget {
  final Map<String, dynamic>? vehicle;

  VehicleDetailPage({this.vehicle});

  @override
  _VehicleDetailPageState createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends State<VehicleDetailPage> {
  final _dbHelper = DatabaseHelper();

  final TextEditingController _vehicleNameController = TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _licensePlateController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _fuelCapacityController = TextEditingController();
  final TextEditingController _chassisNumberController = TextEditingController();
  final TextEditingController _vinController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isActive = true;
  String _fuelType = 'Liquids';
  String _distanceUnit = 'Kilometer (km)';
  String _tankType = 'One tank';

  @override
  void initState() {
    super.initState();
    if (widget.vehicle != null) {
      _vehicleNameController.text = widget.vehicle!['name'] ?? '';
      _manufacturerController.text = widget.vehicle!['manufacturer'] ?? '';
      _modelController.text = widget.vehicle!['model'] ?? '';
      _licensePlateController.text = widget.vehicle!['licensePlate'] ?? '';
      _yearController.text = widget.vehicle!['year'] ?? '';
      _fuelCapacityController.text = widget.vehicle!['fuelCapacity'] ?? '';
      _chassisNumberController.text = widget.vehicle!['chassisNumber'] ?? '';
      _vinController.text = widget.vehicle!['vin'] ?? '';
      _notesController.text = widget.vehicle!['notes'] ?? '';
      _isActive = widget.vehicle!['isActive'] == 1;
      _fuelType = widget.vehicle!['fuelType'] ?? 'Liquids';
      _distanceUnit = widget.vehicle!['distanceUnit'] ?? 'Kilometer (km)';
      _tankType = widget.vehicle!['tankType'] ?? 'One tank';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              final vehicle = {
                'name': _vehicleNameController.text,
                'manufacturer': _manufacturerController.text,
                'model': _modelController.text,
                'licensePlate': _licensePlateController.text,
                'year': _yearController.text,
                'tankType': _tankType,
                'fuelType': _fuelType,
                'fuelCapacity': _fuelCapacityController.text,
                'distanceUnit': _distanceUnit,
                'chassisNumber': _chassisNumberController.text,
                'vin': _vinController.text,
                'isActive': _isActive ? 1 : 0,
                'notes': _notesController.text,
              };

              if (widget.vehicle == null) {
                await _dbHelper.insertVehicle(vehicle);
              } else {
                await _dbHelper.updateVehicle(vehicle, widget.vehicle!['id']);
              }

              Navigator.pop(context, true); // Return true to indicate save/update
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _vehicleNameController,
              decoration: InputDecoration(labelText: 'Vehicle Name'),
            ),
            // Other input fields...
          ],
        ),
      ),
    );
  }
}
