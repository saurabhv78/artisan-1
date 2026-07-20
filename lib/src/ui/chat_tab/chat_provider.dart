import 'dart:convert';
import 'dart:developer';

import 'package:Artisan/src/logic/services/preference_services.dart';
import 'package:Artisan/src/ui/chat_tab/chat_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/services/api_services/retrofit/auth_api_client/auth_api_client.dart';
import 'websocket_service.dart';

final webSocketProvider = Provider<WebSocketService>((ref) {
  return WebSocketService(baseUrl);
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier(this.ref) : super([]) {
    // final id =
    //     ref.read(sharedPreferencesProvider).getString(PreferenceService.userId);
    _listenMessages();
  }

  final Ref ref;
  bool _isListening = false;

  // TODO: replace with real user id from auth
  // ignore: constant_identifier_names
  // static const String CURRENT_USER_ID = "6852f8eba7e7b36b331b86b8";

  void _listenMessages() {
    if (_isListening) return;
    _isListening = true;

    final socket = ref.read(webSocketProvider);

    // single incoming message handler
    socket.onMessage((message) {
      log("Received message: $message");

      dynamic parsedMessage = message;
      if (message is String) {
        try {
          parsedMessage = jsonDecode(message);
        } catch (_) {}
      }

      String text = "";
      String fromId = "";

      if (parsedMessage is Map) {
        text = parsedMessage["message"]?.toString() ??
            parsedMessage["text"]?.toString() ??
            parsedMessage["msg"]?.toString() ??
            parsedMessage.toString();
        fromId = parsedMessage["fromId"]?.toString() ?? "";
      } else {
        text = parsedMessage.toString();
      }

      if (text.isEmpty) return;

      // Ignore user's own echoed messages (added locally in sendMessage)
      final String? myId = ref
          .read(sharedPreferencesProvider)
          .getString(PreferenceService.userId);
      if (fromId.isNotEmpty && fromId == myId) {
        log("Ignoring user's own message from socket broadcast, updating status to delivered");
        updateMessageStatus(text, MessageStatus.delivered);
        return;
      }

      addMessage(ChatMessage(
        text: text,
        isMe: false,
        createdAt: DateTime.now(),
      ));
    });

    // history handler
    socket.onHistory((historyData) {
      log("History received: $historyData");

      try {
        // Case A: server sends single session object with `messages` field (your example)
        if (historyData is Map && historyData.containsKey("messages")) {
          final messages = historyData["messages"] as List<dynamic>;
          setHistory(messages);
          return;
        }

        // Case B: server sends list of sessions or list of messages
        if (historyData is List) {
          if (historyData.isEmpty) {
            setHistory([]);
            return;
          }

          // if each item has messages -> pick first matching session or first entry
          bool handled = false;
          for (var item in historyData) {
            if (item is Map && item.containsKey("messages")) {
              // try to find a session matching our sessionId? (ChatNotifier doesn't have sessionId),
              // so use first one that has messages.
              final msgs = item["messages"] as List<dynamic>;
              setHistory(msgs);
              handled = true;
              break;
            }
          }

          // if none had `messages`, maybe historyData itself is list of messages
          if (!handled) {
            setHistory(historyData);
          }
          return;
        }

        log("chat-history: unknown format, raw: $historyData");
      } catch (e, st) {
        log("Error parsing history: $e\n$st");
      }
    });
  }

  /// Add single message to state (for incoming or outgoing immediate add)
  void addMessage(ChatMessage msg) {
    state = [...state, msg];
  }

  void updateMessageStatus(String text, MessageStatus newStatus) {
    state = [
      for (final msg in state)
        if (msg.isMe && msg.text == text && msg.status.index < newStatus.index)
          ChatMessage(
            text: msg.text,
            isMe: msg.isMe,
            createdAt: msg.createdAt,
            status: newStatus,
          )
        else
          msg
    ];
  }

  /// Parse list of message objects (from server) -> ChatMessage list
  void setHistory(List<dynamic> historyList) {
    final tmp = <Map<String, dynamic>>[];

    for (var e in historyList) {
      if (e is Map) {
        DateTime? dt;
        final rawCreated = e["createdAt"] ?? e["timestamp"];
        if (rawCreated != null) {
          try {
            if (rawCreated is String && rawCreated.isNotEmpty) {
              dt = DateTime.parse(rawCreated).toLocal();
            } else if (rawCreated is num) {
              if (rawCreated < 10000000000) {
                dt = DateTime.fromMillisecondsSinceEpoch(
                        (rawCreated * 1000).toInt())
                    .toLocal();
              } else {
                dt = DateTime.fromMillisecondsSinceEpoch(rawCreated.toInt())
                    .toLocal();
              }
            } else if (rawCreated is Map) {
              final seconds = rawCreated["seconds"] ?? rawCreated["_seconds"];
              if (seconds != null) {
                dt = DateTime.fromMillisecondsSinceEpoch(
                        (seconds * 1000).toInt())
                    .toLocal();
              }
            }
          } catch (_) {}
        }

        final String fromId = e["fromId"]?.toString() ?? '';
        final bool isMe = fromId ==
            ref
                .read(sharedPreferencesProvider)
                .getString(PreferenceService.userId);

        tmp.add({
          "text": e["message"]?.toString() ?? "",
          "isMe": isMe,
          "dt": dt,
          "original": e,
        });
      }
    }

    // Interpolate missing dates forward (use previous message's date)
    DateTime? lastValidDate;
    for (var i = 0; i < tmp.length; i++) {
      if (tmp[i]["dt"] != null) {
        lastValidDate = tmp[i]["dt"] as DateTime;
      } else if (lastValidDate != null) {
        tmp[i]["dt"] = lastValidDate;
      }
    }

    // Interpolate missing dates backward (for initial messages with null dates)
    DateTime? nextValidDate;
    for (var i = tmp.length - 1; i >= 0; i--) {
      if (tmp[i]["dt"] != null) {
        nextValidDate = tmp[i]["dt"] as DateTime;
      } else if (nextValidDate != null) {
        tmp[i]["dt"] = nextValidDate;
      }
    }

    final finalMessages = tmp.map<ChatMessage>((m) {
      final isMe = m["isMe"] as bool;
      MessageStatus status = MessageStatus.sent;

      if (isMe) {
        final original = m["original"];
        if (original is Map) {
          final String serverStatus = original["messageStatus"]?.toString() ?? "";
          if (serverStatus == "read") {
            status = MessageStatus.read;
          } else if (serverStatus == "delivered") {
            status = MessageStatus.delivered;
          } else if (serverStatus == "sent") {
            status = MessageStatus.sent;
          } else {
            // Fallback for history messages
            status = MessageStatus.delivered;
          }
        }
      }

      return ChatMessage(
        text: m["text"] as String,
        isMe: isMe,
        createdAt: (m["dt"] as DateTime?) ?? DateTime.now(),
        status: status,
      );
    }).toList();

    // Sort chronologically
    finalMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    state = finalMessages;
  }

  void sendMessage(String text, {required String fromId}) {
    final socket = ref.read(webSocketProvider);

    socket.send(text, fromId, messageStatus: "sent");

    addMessage(ChatMessage(
      text: text,
      isMe: true,
      createdAt: DateTime.now(),
      status: MessageStatus.sent,
    ));
  }
}

final chatProvider =
    StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier(ref);
});

// final webSocketProvider = Provider<WebSocketService>((ref) {
//   return WebSocketService(baseUrl);
// });

// class ChatNotifier extends StateNotifier<List<ChatMessage>> {
//   ChatNotifier(this.ref) : super([]) {
//     _listenMessages();
//   }

//   final Ref ref;
//   bool _isListening = false; // ✅ to prevent double subscription

//   void _listenMessages() {
//     if (_isListening) return; // stop duplicate listeners
//     _isListening = true;

//     final socket = ref.read(webSocketProvider);

//     // listen for single message
//     socket.onMessage((message) {
//       log("Received message: $message");
//       addMessage(ChatMessage(
//         text: message.toString(),
//         isMe: false,
//       ));
//     });

//     // listen for history
//     // socket.onHistory((historyList) {
//     //   setHistory(historyList);
//     // });
//   }

//   /// Add a single message to state
//   void addMessage(ChatMessage msg) {
//     state = [...state, msg];
//   }

//   /// Replace entire history
//   void setHistory(List<dynamic> historyList) {
//     final parsed = historyList.map<ChatMessage>((e) {
//       if (e is Map) {
//         return ChatMessage(
//           text: e["message"]?.toString() ?? "",
//           isMe: e["fromId"] == "68358db58f11f16670cb0ffe",
//         );
//       }
//       return ChatMessage(text: e.toString(), isMe: false);
//     }).toList();

//     state = parsed;
//   }

//   void sendMessage(String text,
//       {required  sessionId, required String fromId}) {
//     final socket = ref.read(webSocketProvider);

//     socket.send(text, sessionId, fromId);

//     addMessage(ChatMessage(
//       text: text,
//       isMe: true,
//     ));
//   }
// }

// final chatProvider =
//     StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
//   return ChatNotifier(ref);
// });
