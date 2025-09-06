import 'package:Artisan/src/ui/chat_tab/chat_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'websocket_service.dart';


final webSocketProvider = Provider<WebSocketService>((ref) {
  return WebSocketService("ws://your-server-ip:3000"); // replace with backend
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier(this.ref) : super([]) {
    _listenMessages();
  }

  final Ref ref;

  void _listenMessages() {
    final socket = ref.read(webSocketProvider);
    socket.stream.listen((message) {
      state = [...state, ChatMessage(text: message, isMe: false)];
    });
  }

  void sendMessage(String text) {
    final socket = ref.read(webSocketProvider);
    socket.send(text);
    state = [...state, ChatMessage(text: text, isMe: true)];
  }
}

final chatProvider =
    StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier(ref);
});
