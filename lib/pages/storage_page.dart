import 'package:flutter/material.dart';

class StoragePage extends StatelessWidget {
  const StoragePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns text and other widgets to the start
          children: [
            // Circular progress indicator for storage usage
            Center(
              child: CircularProgressIndicator(
                value: 0.0, // Replace with actual storage usage percentage
                backgroundColor: Colors.grey,
                strokeWidth: 10.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '0.00 MB',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '250 MB',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Used',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.local_gas_station),
                    title: Text('Refueling'),
                    subtitle: Text('0.0 MB (00.0%)'),
                  ),
                  ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text('Expense'),
                    subtitle: Text('0.0 MB (00.0%)'),
                  ),
                  ListTile(
                    leading: Icon(Icons.monetization_on),
                    title: Text('Income'),
                    subtitle: Text('0.0 MB (00.0%)'),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Service'),
                    subtitle: Text('0.0 MB (00.0%)'),
                  ),
                  ListTile(
                    leading: Icon(Icons.directions),
                    title: Text('Route'),
                    subtitle: Text('0.0 MB (00.0%)'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
