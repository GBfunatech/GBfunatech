import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.settings, color: Colors.blue),
            title: Text('Settings'),
            subtitle: Text('Manage app settings'),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.green),
            title: Text('About'),
            subtitle: Text('Learn more about the app'),
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_mail, color: Colors.orange),
            title: Text('Contact Us'),
            subtitle: Text('Get in touch with support'),
            onTap: () {
              Navigator.pushNamed(context, '/contact');
            },
          ),
          ListTile(
            leading: Icon(Icons.help, color: Colors.purple),
            title: Text('Help & Support'),
            subtitle: Text('FAQs and support information'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.star, color: Colors.redAccent),
            title: Text('Rate Us'),
            subtitle: Text('Give us feedback on the app'),
            onTap: () {
              // Open the app store or feedback form
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip, color: Colors.teal),
            title: Text('Privacy Policy'),
            subtitle: Text('Read our privacy policy'),
            onTap: () {
              // Link to Privacy Policy page or open a webview
            },
          ),
        ],
      ),
    );
  }
}

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Q: How do I add a vehicle?\n'
                  'A: Go to the Vehicles section and click on the "Add Vehicle" button.\n\n'
                  'Q: How can I track fuel usage?\n'
                  'A: Use the Fuel Tracking section to log fuel purchases and monitor usage.\n\n'
                  'Q: How can I set reminders?\n'
                  'A: Navigate to the Reminders section to set maintenance and other reminders.\n\n',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
