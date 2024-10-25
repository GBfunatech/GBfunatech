import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MyPlacesPage extends StatefulWidget {
  const MyPlacesPage({Key? key}) : super(key: key);

  @override
  _MyPlacesPageState createState() => _MyPlacesPageState();
}

class _MyPlacesPageState extends State<MyPlacesPage> {
  GoogleMapController? _mapController;
  List<Marker> _markers = [];
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _markers = [
      Marker(
        markerId: const MarkerId('Kansenshi'),
        position: const LatLng(-12.9759, 28.6558), // Kansenshi
        infoWindow: const InfoWindow(
          title: 'Kansenshi',
          snippet: '2JQJ+QWQ, Ndola, Zambia',
        ),
      ),
      Marker(
        markerId: const MarkerId('Northrise'),
        position: const LatLng(-12.9799, 28.6645), // Northrise
        infoWindow: const InfoWindow(
          title: 'Northrise',
          snippet: 'Plot 10495 Manchinchi Northrise, Ndola, Zambia',
        ),
      ),
    ];
  }

  Future<void> _requestLocationPermission() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await location.getLocation();
    _mapController?.animateCamera(CameraUpdate.newLatLng(
      LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              if (_markers.isNotEmpty) {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngBounds(
                    _getBounds(_markers),
                    50.0,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            _currentLocation?.latitude ?? -12.9759,
            _currentLocation?.longitude ?? 28.6558,
          ),
          zoom: 10.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        markers: Set<Marker>.of(_markers),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newMarker = await Navigator.push<Marker>(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPlacePage(),
            ),
          );

          if (newMarker != null) {
            setState(() {
              _markers.add(newMarker);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  LatLngBounds _getBounds(List<Marker> markers) {
    final southwestLatLng = LatLng(
      markers.map((m) => m.position.latitude).reduce((a, b) => a < b ? a : b),
      markers.map((m) => m.position.longitude).reduce((a, b) => a < b ? a : b),
    );
    final northeastLatLng = LatLng(
      markers.map((m) => m.position.latitude).reduce((a, b) => a > b ? a : b),
      markers.map((m) => m.position.longitude).reduce((a, b) => a > b ? a : b),
    );
    return LatLngBounds(southwest: southwestLatLng, northeast: northeastLatLng);
  }
}

class AddPlacePage extends StatelessWidget {
  const AddPlacePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController latController = TextEditingController();
    final TextEditingController lngController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Place'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Place Name',
              ),
            ),
            TextField(
              controller: latController,
              decoration: const InputDecoration(
                labelText: 'Latitude',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: lngController,
              decoration: const InputDecoration(
                labelText: 'Longitude',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                final String name = nameController.text.trim();
                final double? latitude = double.tryParse(latController.text);
                final double? longitude = double.tryParse(lngController.text);

                if (name.isNotEmpty && latitude != null && longitude != null) {
                  final newMarker = Marker(
                    markerId: MarkerId(name),
                    position: LatLng(latitude, longitude),
                    infoWindow: InfoWindow(
                      title: name,
                    ),
                  );
                  Navigator.pop(context, newMarker);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid details')),
                  );
                }
              },
              child: const Text('Save Place'),
            ),
          ],
        ),
      ),
    );
  }
}
