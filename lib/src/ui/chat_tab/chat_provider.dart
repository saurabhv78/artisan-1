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
      addMessage(ChatMessage(
        text: message.toString(),
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

  /// Parse list of message objects (from server) -> ChatMessage list
  void setHistory(List<dynamic> historyList) {
    final tmp = <Map<String, dynamic>>[];

    for (var e in historyList) {
      if (e is Map) {
        DateTime dt;
        final createdAtStr = e["createdAt"]?.toString() ?? '';
        if (createdAtStr.isNotEmpty) {
          try {
            dt = DateTime.parse(createdAtStr);
          } catch (_) {
            dt = DateTime.now();
          }
        } else {
          dt = DateTime.now();
        }

        final String fromId = e["fromId"]?.toString() ?? '';
        final bool isMe = fromId ==
            ref
                .read(sharedPreferencesProvider)
                .getString(PreferenceService.userId);

        final ChatMessage cm = ChatMessage(
          text: e["message"]?.toString() ?? "",
          isMe: isMe,
          createdAt: dt, // ✅ new field
        );

        tmp.add({"dt": dt, "msg": cm});
      }
    }

    tmp.sort((a, b) => (a["dt"] as DateTime).compareTo(b["dt"] as DateTime));

    state = tmp.map<ChatMessage>((m) => m["msg"] as ChatMessage).toList();
  }

  void sendMessage(String text, {required String fromId}) {
    final socket = ref.read(webSocketProvider);

    socket.send(text, fromId);

    addMessage(ChatMessage(
      text: text,
      isMe: true,
      createdAt: DateTime.now(),
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
