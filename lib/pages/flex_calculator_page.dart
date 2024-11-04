import 'package:flutter/material.dart' show AppBar, BuildContext, Column, CrossAxisAlignment, EdgeInsets, ElevatedButton, Expanded, FontWeight, Icon, Icons, InputDecoration, Key, Padding, Row, Scaffold, SizedBox, Slider, State, StatefulWidget, Text, TextField, TextInputType, TextStyle, Widget;

class FlexCalculatorPage extends StatefulWidget {
  const FlexCalculatorPage({Key? key}) : super(key: key);

  @override
  _FlexCalculatorPageState createState() => _FlexCalculatorPageState();
}

class _FlexCalculatorPageState extends State<FlexCalculatorPage> {
  double autonomyDifference = 70.0;  // Autonomy percentage difference between ethanol and petrol
  double petrolPrice = 0.0;
  double ethanolPrice = 0.0;
  String resultMessage = '';

  // Method to safely parse the user input
  double _parsePrice(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0;  // Return 0.0 in case of invalid input
    }
  }

  void calculate() {
    if (petrolPrice > 0 && ethanolPrice > 0) {
      double ethanolCostPerKm = ethanolPrice / (autonomyDifference / 100);
      double petrolCostPerKm = petrolPrice;

      if (ethanolCostPerKm < petrolCostPerKm) {
        setState(() {
          resultMessage = 'Ethanol is more cost-effective';
        });
      } else {
        setState(() {
          resultMessage = 'Petrol is more cost-effective';
        });
      }
    } else {
      setState(() {
        resultMessage = 'Please enter valid prices for both petrol and ethanol';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flex Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Autonomy Difference (%)'),
            Slider(
              value: autonomyDifference,
              min: 0.0,
              max: 100.0,
              divisions: 100,
              label: '${autonomyDifference.round()}%',
              onChanged: (value) {
                setState(() {
                  autonomyDifference = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.attach_money),
                const SizedBox(width: 8),
                const Text('Petrol Price:'),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter petrol price',
                    ),
                    onChanged: (value) {
                      setState(() {
                        petrolPrice = _parsePrice(value);
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.local_gas_station),
                const SizedBox(width: 8),
                const Text('Ethanol Price:'),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter ethanol price',
                    ),
                    onChanged: (value) {
                      setState(() {
                        ethanolPrice = _parsePrice(value);
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculate,
              child: const Text('CALCULATE'),
            ),
            const SizedBox(height: 16),
            Text(
              resultMessage,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
