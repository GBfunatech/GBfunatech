import 'package:flutter/material.dart';

class IncomeTypePage extends StatefulWidget {
  const IncomeTypePage({Key? key}) : super(key: key);

  @override
  _IncomeTypePageState createState() => _IncomeTypePageState();
}

class _IncomeTypePageState extends State<IncomeTypePage> {
  List<String> incomeTypes = ['Freight', 'Refund', 'Ride', 'Transport application', 'Vehicle sale'];

  // Function to add a new income type
  void _addIncomeType(String newType) {
    setState(() {
      incomeTypes.add(newType);
    });
  }

  // Function to show dialog for adding a new income type
  void _showAddIncomeTypeDialog() {
    TextEditingController _incomeTypeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Income Type'),
          content: TextField(
            controller: _incomeTypeController,
            decoration: const InputDecoration(hintText: 'Enter income type'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                String newType = _incomeTypeController.text.trim();
                if (newType.isNotEmpty) {
                  _addIncomeType(newType);
                  Navigator.of(context).pop();
                }
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
        title: const Text('Types of Income'),
      ),
      body: ListView.builder(
        itemCount: incomeTypes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(incomeTypes[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddIncomeTypeDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
