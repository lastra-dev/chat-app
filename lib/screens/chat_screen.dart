import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, index) => const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Test!',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/WqZZe15hxidtiAMCQ9eJ/messages')
              .snapshots()
              .listen(
            (data) {
              for (final document in data.docs) {
                print(document['text']);
              }
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
