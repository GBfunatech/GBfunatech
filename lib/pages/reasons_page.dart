import 'package:flutter/material.dart';

class ReasonsPage extends StatefulWidget {
  const ReasonsPage({Key? key}) : super(key: key);

  @override
  _ReasonsPageState createState() => _ReasonsPageState();
}

class _ReasonsPageState extends State<ReasonsPage> {
  List<String> reasons = ['Trip', 'Work'];

  // Function to add a new reason
  void _addReason(String newReason) {
    setState(() {
      reasons.add(newReason);
    });
  }

  // Function to show dialog for adding a new reason
  void _showAddReasonDialog() {
    TextEditingController _reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Reason'),
          content: TextField(
            controller: _reasonController,
            decoration: const InputDecoration(hintText: 'Enter reason'),
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
                String newReason = _reasonController.text.trim();
                if (newReason.isNotEmpty) {
                  _addReason(newReason);
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
        title: const Text('Reasons'),
      ),
      body: ListView.builder(
        itemCount: reasons.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(reasons[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReasonDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
