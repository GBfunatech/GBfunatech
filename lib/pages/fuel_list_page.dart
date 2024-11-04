import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fuel_form_page.dart';

class FuelListPage extends StatefulWidget {
  @override
  _FuelListPageState createState() => _FuelListPageState();
}

class _FuelListPageState extends State<FuelListPage> {
  List<String> fuelTypes = [];
  List<String> filteredFuelTypes = [];
  String selectedCategory = 'Liquids';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadFuelTypes();
  }

  Future<void> _loadFuelTypes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fuelTypes = prefs.getStringList(selectedCategory) ?? [];
      _sortFuelTypes();
      _filterFuelTypes();
    });
  }

  void _sortFuelTypes() {
    fuelTypes.sort((a, b) => a.compareTo(b));
  }

  void _filterFuelTypes() {
    setState(() {
      filteredFuelTypes = fuelTypes
          .where((fuelType) =>
          fuelType.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  Future<bool?> _deleteFuelType(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete "${filteredFuelTypes[index]}"?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        String fuelTypeToDelete = filteredFuelTypes[index];
        fuelTypes.remove(fuelTypeToDelete);
        filteredFuelTypes.removeAt(index);
        prefs.setStringList(selectedCategory, fuelTypes);
      });
      return true; // Confirm that the item should be dismissed
    }
    return false; // Cancel the dismissal if not confirmed
  }

  Future<void> _editFuelType(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FuelFormPage(
          initialFuelType: filteredFuelTypes[index],
          initialCategory: selectedCategory,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        final fuelType = result['fuelType'];
        final category = result['category'];

        fuelTypes[fuelTypes.indexOf(filteredFuelTypes[index])] = fuelType;
        _sortFuelTypes();
        _filterFuelTypes();

        SharedPreferences.getInstance().then((prefs) {
          prefs.setStringList(selectedCategory, fuelTypes);

          if (category != selectedCategory) {
            // Remove from old category and save to the new one
            List<String> newCategoryList = prefs.getStringList(category) ?? [];
            newCategoryList.add(fuelType);
            prefs.setStringList(category, newCategoryList);
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search Fuel Types',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            setState(() {
              searchQuery = query;
              _filterFuelTypes();
            });
          },
        ),
        actions: [
          DropdownButton<String>(
            value: selectedCategory,
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
                _loadFuelTypes();
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
      body: ListView.builder(
        itemCount: filteredFuelTypes.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.red),
            confirmDismiss: (direction) async {
              return await _deleteFuelType(index);
            },
            child: ListTile(
              leading: const Icon(Icons.local_gas_station),
              title: Text(filteredFuelTypes[index]),
              onTap: () {
                _editFuelType(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FuelFormPage()),
          );

          if (result != null) {
            setState(() {
              final fuelType = result['fuelType'];
              final category = result['category'];

              if (category == selectedCategory) {
                fuelTypes.add(fuelType);
                _sortFuelTypes();
                _filterFuelTypes();
              }

              SharedPreferences.getInstance().then((prefs) {
                List<String> categoryList = prefs.getStringList(category) ?? [];
                categoryList.add(fuelType);
                prefs.setStringList(category, categoryList);
              });
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
