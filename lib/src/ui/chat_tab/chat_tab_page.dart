import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ChatTabPage extends ConsumerStatefulWidget {
  const ChatTabPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatTabPageState();
}

class _ChatTabPageState extends ConsumerState<ChatTabPage> {
  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text("Chat Page"),
        ),
      ],
    ));
  }
}
