import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class FormsPage extends StatefulWidget {
  @override
  _FormsPageState createState() => _FormsPageState();
}

class _FormsPageState extends State<FormsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String selectedFormType = 'All';
  bool sortByAmount = false;

  Stream<QuerySnapshot> _getFormsStream() {
    User? user = _auth.currentUser;

    Query query = _firestore.collection('forms').where('userId', isEqualTo: user!.uid);

    if (selectedFormType != 'All') {
      query = query.where('formType', isEqualTo: selectedFormType);
    }

    if (sortByAmount) {
      query = query.orderBy('amount', descending: true);
    } else {
      query = query.orderBy('timestamp', descending: true);
    }

    return query.snapshots();
  }

  Widget _buildAnalytics(List<DocumentSnapshot> forms) {
    double totalAmount = forms.fold(0.0, (sum, doc) => sum + (doc['amount'] as double));
    double averageAmount = forms.isNotEmpty ? totalAmount / forms.length : 0.0;
    double maxAmount = forms.isNotEmpty ? forms.map((doc) => doc['amount'] as double).reduce((a, b) => a > b ? a : b) : 0.0;
    double minAmount = forms.isNotEmpty ? forms.map((doc) => doc['amount'] as double).reduce((a, b) => a < b ? a : b) : 0.0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Average Amount: \$${averageAmount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Highest Amount: \$${maxAmount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Lowest Amount: \$${minAmount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(List<DocumentSnapshot> forms) {
    List<charts.Series<FormData, String>> series = [
      charts.Series(
        id: 'Forms',
        data: forms.map((doc) => FormData(doc['formType'], doc['amount'] as double)).toList(),
        domainFn: (FormData data, _) => data.formType,
        measureFn: (FormData data, _) => data.amount,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 200.0,
        child: charts.BarChart(
          series,
          animate: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Forms'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String formType) {
              _submitForm(formType);
            },
            itemBuilder: (BuildContext context) {
              return ['Vehicle Use', 'Expenses', 'Maintenance'].map((String formType) {
                return PopupMenuItem<String>(
                  value: formType,
                  child: Text('Submit $formType Form'),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: selectedFormType,
                  onChanged: (value) {
                    setState(() {
                      selectedFormType = value!;
                    });
                  },
                  items: ['All', 'Vehicle Use', 'Expenses', 'Maintenance'].map((String formType) {
                    return DropdownMenuItem<String>(
                      value: formType,
                      child: Text(formType),
                    );
                  }).toList(),
                ),
                Row(
                  children: [
                    Text('Sort by Amount'),
                    Switch(
                      value: sortByAmount,
                      onChanged: (value) {
                        setState(() {
                          sortByAmount = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getFormsStream(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                List<DocumentSnapshot> forms = snapshot.data!.docs;

                return Column(
                  children: [
                    _buildAnalytics(forms),
                    _buildChart(forms),
                    Expanded(
                      child: ListView(
                        children: forms.map((DocumentSnapshot document) {
                          return ListTile(
                            title: Text('${document['formType']} Form'),
                            subtitle: Text('Description: ${document['description']}\nAmount: \$${document['amount']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _editForm(context, document);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteForm(document.id);
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm(String formType) async {
    String description = '';
    double amount = 0.0;
    User? user = _auth.currentUser;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submit $formType Form'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  description = value;
                },
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                onChanged: (value) {
                  amount = double.tryParse(value) ?? 0.0;
                },
                decoration: InputDecoration(labelText: 'Amount'),
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
                if (description.isNotEmpty && amount > 0) {
                  await _firestore.collection('forms').add({
                    'userId': user!.uid,
                    'formType': formType,
                    'description': description,
                    'amount': amount,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editForm(BuildContext context, DocumentSnapshot formDoc) async {
    String description = formDoc['description'];
    double amount = formDoc['amount'];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
          Text('Edit ${formDoc['formType']} Form'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: description),
                onChanged: (value) {
                  description = value;
                },
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: TextEditingController(text: amount.toString()),
                onChanged: (value) {
                  amount = double.tryParse(value) ?? 0.0;
                },
                decoration: InputDecoration(labelText: 'Amount'),
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
                if (description.isNotEmpty && amount > 0) {
                  await _firestore.collection('forms').doc(formDoc.id).update({
                    'description': description,
                    'amount': amount,
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteForm(String formId) async {
    await _firestore.collection('forms').doc(formId).delete();
  }
}

class FormData {
  final String formType;
  final double amount;

  FormData(this.formType, this.amount);
}
