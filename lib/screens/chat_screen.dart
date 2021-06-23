import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats/WqZZe15hxidtiAMCQ9eJ/messages')
              .snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = snapshot.data!.docs;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (ctx, index) => Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  documents[index]['text'].toString(),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/WqZZe15hxidtiAMCQ9eJ/messages')
              .add(
            {'text': 'Dummy message'},
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
