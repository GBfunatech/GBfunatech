import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class VehicleUsersPage extends StatefulWidget {
  @override
  _VehicleUsersPageState createState() => _VehicleUsersPageState();
}

class _VehicleUsersPageState extends State<VehicleUsersPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _logTrip(BuildContext context, DocumentSnapshot vehicleDoc) async {
    String tripStart = '';
    String tripEnd = '';
    double mileage = 0.0;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Trip'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  tripStart = value;
                },
                decoration: InputDecoration(labelText: 'Trip Start'),
              ),
              TextField(
                onChanged: (value) {
                  tripEnd = value;
                },
                decoration: InputDecoration(labelText: 'Trip End'),
              ),
              TextField(
                onChanged: (value) {
                  mileage = double.tryParse(value) ?? 0.0;
                },
                decoration: InputDecoration(labelText: 'Mileage (km)'),
                keyboardType: TextInputType.number,
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
              onPressed: () async {
                if (tripStart.isNotEmpty && tripEnd.isNotEmpty && mileage > 0) {
                  await _firestore
                      .collection('vehicles')
                      .doc(vehicleDoc.id)
                      .collection('trips')
                      .add({
                    'tripStart': tripStart,
                    'tripEnd': tripEnd,
                    'mileage': mileage,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Log Trip'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTripAnalytics(List<DocumentSnapshot> trips) {
    List<charts.Series<TripData, String>> series = [
      charts.Series(
        id: 'Mileage',
        data: trips
            .map((doc) => TripData(
                tripStart: doc['tripStart'],
                mileage: doc['mileage'] as double))
            .toList(),
        domainFn: (TripData trip, _) => trip.tripStart,
        measureFn: (TripData trip, _) => trip.mileage,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];

    return charts.BarChart(
      series,
      animate: true,
    );
  }

  Future<List<DocumentSnapshot>> _fetchTrips(String vehicleId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('vehicles')
        .doc(vehicleId)
        .collection('trips')
        .orderBy('timestamp', descending: true)
        .get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Usage Monitoring'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('vehicles').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return ListTile(
                title: Text(document['name']),
                subtitle: FutureBuilder<List<DocumentSnapshot>>(
                  future: _fetchTrips(document.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Loading trip data...');
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Total Mileage: ${snapshot.data!.fold(0.0, (sum, doc) => sum + (doc['mileage'] as double))} km'),
                        SizedBox(height: 10),
                        _buildTripAnalytics(snapshot.data!),
                      ],
                    );
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _logTrip(context, document);
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class TripData {
  final String tripStart;
  final double mileage;

  TripData({required this.tripStart, required this.mileage});
}
