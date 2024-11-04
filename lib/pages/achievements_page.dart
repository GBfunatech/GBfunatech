import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AchievementsPage extends StatefulWidget {
  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  Stream<QuerySnapshot> _getAchievementsStream() {
    return _firestore
        .collection('achievements')
        .where('userId', isEqualTo: _user!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Achievements'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getAchievementsStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return ListTile(
                title: Text(document['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: (document['progress'] as double) / 100,
                      minHeight: 8.0,
                    ),
                    SizedBox(height: 8.0),
                    Text('${document['progress']}% complete'),
                  ],
                ),
                trailing: document['progress'] == 100
                    ? Icon(Icons.star, color: Colors.yellow)
                    : null,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
