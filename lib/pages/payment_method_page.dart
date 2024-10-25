import 'package:flutter/material.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({Key? key}) : super(key: key);

  @override
  _PaymentMethodsPageState createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  List<String> paymentMethods = ['Credit Card', 'Debit Card', 'Cash'];

  void _addPaymentMethod(String newMethod) {
    setState(() {
      paymentMethods.add(newMethod);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
      ),
      body: ListView.builder(
        itemCount: paymentMethods.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(paymentMethods[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPaymentMethodPage(),
            ),
          );
          if (result != null && result is String) {
            _addPaymentMethod(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddPaymentMethodPage extends StatelessWidget {
  const AddPaymentMethodPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Payment Method'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Payment Method Name',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                final newMethod = _controller.text.trim();
                if (newMethod.isNotEmpty) {
                  Navigator.pop(context, newMethod);
                } else {
                  // Optionally, show an error message if the input is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a payment method')),
                  );
                }
              },
              child: const Text('Save Payment Method'),
            ),
          ],
        ),
      ),
    );
  }
}
