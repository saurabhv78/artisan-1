class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime createdAt;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.createdAt,
  });
}
