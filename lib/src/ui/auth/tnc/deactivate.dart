import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage()
class TnCPages extends ConsumerWidget {
  const TnCPages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse("https://artisan-admin.handsandbrushes.com/deactivate-user"),
      );

    return Scaffold(
      appBar: AppBar(
          // title: const Text("Terms & Conditions"
          ),
      body: WebViewWidget(controller: controller),
    );
  }
}
