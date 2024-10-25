import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WhereToRefuelPage extends StatefulWidget {
  const WhereToRefuelPage({Key? key}) : super(key: key);

  @override
  _WhereToRefuelPageState createState() => _WhereToRefuelPageState();
}

class _WhereToRefuelPageState extends State<WhereToRefuelPage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _isFiltering = false;

  void _toggleFiltering() {
    setState(() {
      _isFiltering = !_isFiltering;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Where to Refuel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _toggleFiltering,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Implement notification logic here
              // Example: Display a snackbar or navigate to a notifications screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification button clicked')),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(
                -12.9759, 28.6558, // Valid coordinates, ensure they are correct for your use case
              ),
              zoom: 5.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: _markers,
          ),
          if (_isFiltering)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: const Text(
                  'Filter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add gas station logic here
          // Example: Navigate to a new screen to input gas station details
          print('Add gas station button clicked');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
