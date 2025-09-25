import 'package:Artisan/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'chat_message.dart';

class ChatMessageTile extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageTile({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('hh:mm a').format(message.createdAt.toLocal());

    final bubbleColor = message.isMe ? primaryColor : Colors.grey[300];
    final textColor = message.isMe ? Colors.white : Colors.black87;

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75, // ✅ max 75% width
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: message.isMe
                ? const Radius.circular(16)
                : const Radius.circular(0),
            bottomRight: message.isMe
                ? const Radius.circular(0)
                : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Message text
            Text(
              message.text,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),

            // Time
            Text(
              timeString,
              style: TextStyle(
                fontSize: 11,
                color: message.isMe ? Colors.white : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
