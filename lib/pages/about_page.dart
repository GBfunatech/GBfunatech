import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import FontAwesome Icons
import 'package:url_launcher/url_launcher.dart'; // For launching URLs

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Drivvo logo and rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/drivvo_logo.png', // Ensure this path is correct
                  width: 100,
                  height: 100,
                ),
                const SizedBox(width: 16.0),
                const Text(
                  'drivvo',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16.0),
                const Icon(Icons.star, color: Colors.yellow),
                const Icon(Icons.star, color: Colors.yellow),
                const Icon(Icons.star, color: Colors.yellow),
                const Icon(Icons.star, color: Colors.yellow),
                const Icon(Icons.star, color: Colors.yellow),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Please rate 5 Stars',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text('Follow us'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    _launchURL('https://www.facebook.com/drivvo');
                  },
                  icon: const FaIcon(FontAwesomeIcons.facebook),
                ),
                IconButton(
                  onPressed: () {
                    _launchURL('https://www.instagram.com/drivvo');
                  },
                  icon: const FaIcon(FontAwesomeIcons.instagram),
                ),
                IconButton(
                  onPressed: () {
                    _launchURL('https://www.twitter.com/drivvo');
                  },
                  icon: const FaIcon(FontAwesomeIcons.twitter),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text('Drivvo - 8.5.1'),
            const Text('Last Update 2024-08-16'),
            const SizedBox(height: 16.0),
            const Text('Privacy policy and terms of use'),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                _launchURL('https://www.drivvo.com');
              },
              child: const Text('www.drivvo.com'),
            ),
          ],
        ),
      ),
    );
  }
}
  