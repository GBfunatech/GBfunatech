import 'package:flutter/material.dart';

class ExpenseTypePage extends StatefulWidget {
  const ExpenseTypePage({Key? key}) : super(key: key);

  @override
  _ExpenseTypePageState createState() => _ExpenseTypePageState();
}

class _ExpenseTypePageState extends State<ExpenseTypePage> {
  List<String> expenseTypes = [
    'Financing',
    'Fine',
    'Parking',
    'Payment',
    'Registration',
    'Reimbursement',
    'Tax',
    'Tolls'
  ];

  // Function to add a new expense type
  void _addExpenseType(String newType) {
    setState(() {
      expenseTypes.add(newType);
    });
  }

  // Function to show dialog for adding a new expense type
  void _showAddExpenseTypeDialog() {
    TextEditingController _expenseTypeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Expense Type'),
          content: TextField(
            controller: _expenseTypeController,
            decoration: const InputDecoration(hintText: 'Enter expense type'),
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
                String newType = _expenseTypeController.text.trim();
                if (newType.isNotEmpty) {
                  _addExpenseType(newType);
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
        title: const Text('Types of Expense'),
      ),
      body: ListView.builder(
        itemCount: expenseTypes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(expenseTypes[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseTypeDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
