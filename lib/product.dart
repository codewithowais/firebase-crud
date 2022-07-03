import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> deleteUser(docId) {
    return users
        .doc(docId)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<QuerySnapshot>(
          future: users.get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> abc =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  title: Text(abc['age']),
                  subtitle: Text(abc['company']),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        deleteUser(document.id);
                      });
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              }).toList());
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
