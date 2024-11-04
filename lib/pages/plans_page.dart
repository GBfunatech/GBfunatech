import 'package:flutter/material.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({Key? key}) : super(key: key);

  @override
  _PlansPageState createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  int selectedPlanIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drivvo Plans'),
      ),
      body: ListView(
        children: [
          ExpansionTile(
            title: const Text('Fleet 20'),
            subtitle: const Text('FOR FLEETS WITH UP TO 20 VEHICLES AND 20 DRIVERS'),
            children: const [
              ListTile(
                title: Text('Unlimited vehicle tracking'),
              ),
              ListTile(
                title: Text('Driver management'),
              ),
              ListTile(
                title: Text('Advanced reporting'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Fleet 30'),
            subtitle: const Text('FOR FLEETS WITH UP TO 30 VEHICLES AND 30 DRIVERS'),
            children: const [
              ListTile(
                title: Text('Unlimited vehicle tracking'),
              ),
              ListTile(
                title: Text('Driver management'),
              ),
              ListTile(
                title: Text('Priority support'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Fleet 50'),
            subtitle: const Text('FOR FLEETS WITH UP TO 50 VEHICLES AND 50 DRIVERS'),
            children: const [
              ListTile(
                title: Text('Unlimited vehicle tracking'),
              ),
              ListTile(
                title: Text('Driver management'),
              ),
              ListTile(
                title: Text('Custom reporting'),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Fleet 100'),
            subtitle: const Text('FOR FLEETS WITH UP TO 100 VEHICLES AND 100 DRIVERS'),
            children: const [
              ListTile(
                title: Text('Unlimited vehicle tracking'),
              ),
              ListTile(
                title: Text('Driver management'),
              ),
              ListTile(
                title: Text('Dedicated account manager'),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPlanIndex,
        onTap: (index) {
          setState(() {
            selectedPlanIndex = index;
            // You can add navigation logic here for each tab if needed
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
