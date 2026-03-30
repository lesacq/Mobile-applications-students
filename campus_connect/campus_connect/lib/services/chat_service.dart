
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message.dart';

class ChatService {
  final CollectionReference _chatCollection = FirebaseFirestore.instance.collection('chats');

  Stream<List<ChatMessage>> getMessages(String roomId) {
    return _chatCollection.doc(roomId).collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => ChatMessage.fromMap(doc.data())).toList());
  }

  Future<void> sendMessage(String roomId, ChatMessage message) async {
    await _chatCollection.doc(roomId).collection('messages').add(message.toMap());
  }
}
