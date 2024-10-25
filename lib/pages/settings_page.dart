import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool showAverageInLastRefueling = false;
  bool isKmSelected = true;
  bool isGallonUSSelected = true;
  bool isM3Selected = true;
  bool isMilesPerGallonSelected = true;
  bool distanceInAdvanceReminder = true;
  bool daysInAdvanceReminder = true;
  TimeOfDay bestNotificationTime = const TimeOfDay(hour: 10, minute: 30);

  // Toggles for various settings
  void toggleShowAverageInLastRefueling() {
    setState(() {
      showAverageInLastRefueling = !showAverageInLastRefueling;
    });
  }

  void _selectNotificationTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: bestNotificationTime,
    );
    if (pickedTime != null && pickedTime != bestNotificationTime) {
      setState(() {
        bestNotificationTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Units'),
            Row(
              children: [
                const Text('km / Miles'),
                Switch(
                  value: isKmSelected,
                  onChanged: (value) {
                    setState(() {
                      isKmSelected = value;
                    });
                  },
                ),
              ],
            ),
            const Text('Unit'),
            Row(
              children: [
                const Text('Gallon US (Gal)'),
                Switch(
                  value: isGallonUSSelected,
                  onChanged: (value) {
                    setState(() {
                      isGallonUSSelected = value;
                    });
                  },
                ),
              ],
            ),
            const Text('Unit'),
            Row(
              children: [
                const Text('m³'),
                Switch(
                  value: isM3Selected,
                  onChanged: (value) {
                    setState(() {
                      isM3Selected = value;
                    });
                  },
                ),
              ],
            ),
            const Text('Fuel efficiency'),
            Row(
              children: [
                const Text('Mile/Gallon US'),
                Switch(
                  value: isMilesPerGallonSelected,
                  onChanged: (value) {
                    setState(() {
                      isMilesPerGallonSelected = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('Show average in the last refueling'),
                Switch(
                  value: showAverageInLastRefueling,
                  onChanged: toggleShowAverageInLastRefueling,
                ),
              ],
            ),
            const Text('Reminders'),
            Row(
              children: [
                const Text('Distance in advance'),
                Switch(
                  value: distanceInAdvanceReminder,
                  onChanged: (value) {
                    setState(() {
                      distanceInAdvanceReminder = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('Days in advance'),
                Switch(
                  value: daysInAdvanceReminder,
                  onChanged: (value) {
                    setState(() {
                      daysInAdvanceReminder = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Best time for notifications'),
            Row(
              children: [
                Text(
                  '${bestNotificationTime.format(context)}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _selectNotificationTime(context),
                  child: const Text('Select Time'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
