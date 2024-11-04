// TODO Implement this library.

import 'package:flutter/material.dart';

class HistoryEntry {
  final String title;
  final String description;
  final DateTime date;

  HistoryEntry({required this.title, required this.description, required this.date});
}

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<HistoryEntry> _historyEntries = [];

  // Function to add a new history entry
  void _addHistoryEntry(String title, String description, DateTime date) {
    setState(() {
      _historyEntries.add(HistoryEntry(title: title, description: description, date: date));
    });
  }

  // Dialog to add a new entry
  Future<void> _showAddEntryDialog() async {
    String title = '';
    String description = '';
    DateTime selectedDate = DateTime.now();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New History Entry'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  description = value;
                },
              ),
              ListTile(
                title: Text("Date: ${selectedDate.toLocal()}".split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
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
                if (title.isNotEmpty && description.isNotEmpty) {
                  _addHistoryEntry(title, description, selectedDate);
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
        title: Text('History'),
      ),
      body: _historyEntries.isEmpty
          ? Center(child: Text('No history entries yet'))
          : ListView.builder(
        itemCount: _historyEntries.length,
        itemBuilder: (context, index) {
          final entry = _historyEntries[index];
          return ListTile(
            leading: Icon(Icons.history),
            title: Text(entry.title),
            subtitle: Text(
                '${entry.description}\nDate: ${entry.date.toLocal()}'.split(' ')[0]),
            isThreeLine: true,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEntryDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
