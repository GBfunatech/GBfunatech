import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Total Expenses: \$400',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Average Mileage: 850 miles/month',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Fuel Efficiency: 25 MPG',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
