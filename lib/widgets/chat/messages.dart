import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final currentUserId = FirebaseAuth.instance.currentUser!.uid;
        final documents = snapshot.data!.docs;
        return ListView.builder(
            reverse: true,
            itemBuilder: (ctx, index) => MessageBubble(
                  documents[index]['text'].toString(),
                  userName: documents[index]['username'].toString(),
                  isMe: documents[index]['userId'] == currentUserId,
                  key: ValueKey(documents[index].id),
                ),
            itemCount: documents.length);
      },
    );
  }
}
