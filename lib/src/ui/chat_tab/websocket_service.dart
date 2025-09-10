import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketService {
  late IO.Socket socket;

  /// listen to event names
  final String onAdminReply = "admin-reply";
  final String onHistoryEvent = "chat-history";

  /// emit event names
  final String getHistoryEvent = "get-history";
  final String sendChatEvent = "admin-chat";

  WebSocketService(String url) {
    socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
    init();
  }

  void init() {
    socket.onConnect((_) {
      debugPrint("Socket connected: ${socket.id}");
    });
    socket.onDisconnect((_) {
      debugPrint("Socket disconnected");
    });
    socket.connect();
  }
  // Listen to chat history

  // Listen to single message
  void onMessage(Function(dynamic) callback) {
    invalidate(onAdminReply);
    socket.on(onAdminReply, callback);
  }

  void invalidate(String event) {
    if (socket.hasListeners(event)) {
      socket.off(event);
    }
  }

  // Listen to chat history
  void onHistory(Function(dynamic) callback) {
    invalidate(onHistoryEvent);
    socket.on(onHistoryEvent, callback);
  }

  // Request history from server
  void getHistory(String? fromId) {
    final payload = {"fromId": fromId};
    socket.emit(getHistoryEvent, payload);
  }

  // Send a message
  void send(String message, String fromId) {
    final payload = {
      "message": message,
      // "sessionId": sessionId,
      "fromId": fromId,
    };
    debugPrint("Sending message: $payload");
    socket.emit(sendChatEvent, payload);
  }

  void dispose() {
    socket.dispose();
  }
}
