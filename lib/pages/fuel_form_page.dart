import 'package:flutter/material.dart';

class FuelFormPage extends StatefulWidget {
  final String? initialFuelType;
  final String? initialCategory;

  FuelFormPage({this.initialFuelType, this.initialCategory});

  @override
  _FuelFormPageState createState() => _FuelFormPageState();
}

class _FuelFormPageState extends State<FuelFormPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _fuelTypeController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fuelTypeController.text = widget.initialFuelType ?? '';
    _selectedCategory = widget.initialCategory ?? 'Liquids';
  }

  @override
  void dispose() {
    _fuelTypeController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'fuelType': _fuelTypeController.text,
        'category': _selectedCategory,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fuel'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fuelTypeController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a fuel name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Fuel type',
                ),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: ['Liquids', 'Gases'].map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
