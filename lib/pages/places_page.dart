import 'package:flutter/material.dart';

class PlacesPage extends StatelessWidget {
  const PlacesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Places'),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Kansenshi'),
          ),
          ListTile(
            title: Text('Northrise'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement your add place logic here
          // Example: navigate to a new page to add a place
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPlacePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Example page for adding a new place
class AddPlacePage extends StatelessWidget {
  const AddPlacePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Place'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Place Name',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Implement your save place logic here
                Navigator.pop(context); // Return to the previous page
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
