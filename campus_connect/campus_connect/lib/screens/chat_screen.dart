import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/chat_service.dart';
import '../models/chat_message.dart';
import '../viewmodels/auth_viewmodel.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  const ChatScreen({Key? key, required this.roomId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late ChatService _chatService;

  @override
  void initState() {
    super.initState();
    _chatService = ChatService();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthViewModel>(context, listen: false).user;
    return Scaffold(
      appBar: AppBar(title: Text('Chat Room')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _chatService.getMessages(widget.roomId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return ListTile(
                      title: Text(msg.senderName),
                      subtitle: Text(msg.text),
                      trailing: Text(_formatTime(msg.timestamp)),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_controller.text.trim().isEmpty) return;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please sign in to send messages.')),
                      );
                      return;
                    }
                    final msg = ChatMessage(
                      senderId: user.uid,
                      senderName: user.email ?? 'Unknown',
                      text: _controller.text.trim(),
                      timestamp: DateTime.now(),
                    );
                    await _chatService.sendMessage(widget.roomId, msg);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) => '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
