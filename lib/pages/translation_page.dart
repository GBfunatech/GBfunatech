import 'package:flutter/material.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({Key? key}) : super(key: key);

  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  String selectedLanguage = '';

  void startReview() {
    // Implement your review logic here
    // For example, navigate to another screen or show a dialog
    print("Starting review for: $selectedLanguage");
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Help us to translate and improve the translation for your language. Your input may be available in our next release!',
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16.0),
            const Text('Select language to review'),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Language',
              ),
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value;
                });
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (selectedLanguage.isNotEmpty) {
                  startReview();
                } else {
                  _showErrorDialog("Please select a language before starting the review.");
                }
              },
              child: const Text('START REVIEW'),
            ),
          ],
        ),
      ),
    );
  }
}
