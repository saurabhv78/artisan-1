enum MessageStatus { sent, delivered, read }

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime createdAt;
  final MessageStatus status;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.createdAt,
    this.status = MessageStatus.sent,
  });
}
