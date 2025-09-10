import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/logic/services/preference_services.dart';
import 'package:Artisan/src/ui/chat_tab/chat_provider.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'chat_message_tile.dart';

// ✅ make sure you have ChatMessage model

@RoutePage()
class ChatTabPage extends ConsumerStatefulWidget {
  const ChatTabPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatTabPageState();
}

class _ChatTabPageState extends ConsumerState<ChatTabPage>
// with WidgetsBindingObserver
{
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);

    // Request chat history on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(webSocketProvider).getHistory(
            ref
                .read(sharedPreferencesProvider)
                .getString(PreferenceService.userId),
          );
    });

    // Auto scroll when keyboard opens
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      final msg = _controller.text.trim();
      ref.read(chatProvider.notifier).sendMessage(
            msg,
            fromId: ref
                .read(sharedPreferencesProvider)
                .getString(PreferenceService.userId)!,
          );
      _controller.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// --- Utilities for day-wise grouping ---
  String _dayLabel(DateTime localDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(localDate.year, localDate.month, localDate.day);
    final diff = today.difference(day).inDays;

    if (diff == 0) return 'Today';
    if (diff < 7) {
      // Show weekday short name (Mon, Tue, Wed, ...)
      return DateFormat.E().format(localDate);
    }
    // Older than a week → show full date
    return DateFormat('dd MMM yyyy').format(localDate);
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);

    // auto scroll when messages update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return CustomScaffold(
      topPadding: 35,
      resizeToAvoidBottomInset: true,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 40),
              Text(
                "Artisan Ally",
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w700,
                  color: bgDark,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          Expanded(
            child: GroupedListView(
              controller: _scrollController,
              elements: messages,
              groupBy: (msg) => DateTime(
                msg.createdAt.year,
                msg.createdAt.month,
                msg.createdAt.day,
              ),
              groupSeparatorBuilder: (DateTime date) => Align(
                alignment: Alignment.topCenter, // ✅ always top center
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _dayLabel(date),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500, // ✅ thin font
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              itemBuilder: (_, msg) => ChatMessageTile(message: msg),
              useStickyGroupSeparators: true, // ✅ sticky on scroll
              floatingHeader: true,
              order: GroupedListOrder.ASC,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              reverse: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextFormField(
                      focusNode: _focusNode,
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        counterStyle: GoogleFonts.outfit(fontSize: 14),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Type your message...",
                        hintStyle: GoogleFonts.nunitoSans(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onFieldSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
