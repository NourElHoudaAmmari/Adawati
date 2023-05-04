import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
 final TextEditingController _textEditingController = TextEditingController();
  final CollectionReference _messagesCollection = FirebaseFirestore.instance.collection('messages');
  final user =FirebaseAuth.instance.currentUser;
     
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                List<Widget> messagesWidgets = [];
                for (DocumentSnapshot document in snapshot.data!.docs) {
              Map<String, dynamic> messageData = document.data()! as Map<String, dynamic>;
                  String message = messageData['message'];
                  String sender = messageData['sender'];
                  Widget messageWidget = ListTile(
                    title: Text(sender),
                    subtitle: Text(message),
                  );
                  messagesWidgets.add(messageWidget);
                }
                return ListView(
                  children: messagesWidgets,
                );
              },
            ),
          ),
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: 'Entrer un message',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String message = _textEditingController.text.trim();
                   
         String? sender = user!.displayName;
            // change this to the current user's name
              _messagesCollection.add({
                'message': message,
                'sender': sender,
              });
              _textEditingController.clear();
            },
            child: Text('Envoyer'),
          ),
        ],
      ),
    );
  }
}