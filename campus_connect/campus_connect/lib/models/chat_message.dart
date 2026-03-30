class ChatMessage {
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'senderName': senderName,
    'text': text,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
    senderId: map['senderId'] ?? '',
    senderName: map['senderName'] ?? '',
    text: map['text'] ?? '',
    timestamp: DateTime.parse(map['timestamp']),
  );
}