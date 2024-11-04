import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ReportData {
  final String category;
  final double amount;
  final charts.Color color;

  ReportData(this.category, this.amount, Color color)
      : this.color = charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class MileageData {
  final DateTime date;
  final double mileage;

  MileageData(this.date, this.mileage);
}

class ReportsPage extends StatelessWidget {
  final List<charts.Series<ReportData, String>> expenseData = [
    charts.Series<ReportData, String>(
      id: 'Expenses',
      domainFn: (ReportData data, _) => data.category,
      measureFn: (ReportData data, _) => data.amount,
      colorFn: (ReportData data, _) => data.color,
      data: [
        ReportData('Fuel', 150.0, Colors.blue),
        ReportData('Maintenance', 80.0, Colors.red),
        ReportData('Insurance', 120.0, Colors.green),
        ReportData('Misc', 50.0, Colors.orange),
      ],
    ),
  ];

  final List<charts.Series<MileageData, DateTime>> mileageData = [
    charts.Series<MileageData, DateTime>(
      id: 'Mileage',
      domainFn: (MileageData data, _) => data.date,
      measureFn: (MileageData data, _) => data.mileage,
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      data: [
        MileageData(DateTime(2023, 1, 1), 300),
        MileageData(DateTime(2023, 2, 1), 600),
        MileageData(DateTime(2023, 3, 1), 750),
        MileageData(DateTime(2023, 4, 1), 900),
        MileageData(DateTime(2023, 5, 1), 1200),
      ],
    ),
  ];

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
                'Expense Breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 250,
                child: charts.BarChart(
                  expenseData,
                  animate: true,
                  vertical: false,
                  barRendererDecorator: charts.BarLabelDecorator<String>(),
                  domainAxis: charts.OrdinalAxisSpec(
                      renderSpec: charts.SmallTickRendererSpec()),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Mileage Over Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 250,
                child: charts.TimeSeriesChart(
                  mileageData,
                  animate: true,
                  dateTimeFactory: const charts.LocalDateTimeFactory(),
                  primaryMeasureAxis: charts.NumericAxisSpec(
                      renderSpec: charts.GridlineRendererSpec()),
                  domainAxis: charts.DateTimeAxisSpec(
                      renderSpec: charts.SmallTickRendererSpec()),
                ),
              ),
              SizedBox(height: 30),
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
