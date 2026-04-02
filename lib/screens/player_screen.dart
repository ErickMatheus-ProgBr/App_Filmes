import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PlayerScreen extends StatefulWidget {
  final String movieId;
  final String title;

  const PlayerScreen({super.key, required this.movieId, required this.title});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => isLoading = false);
          },
          onNavigationRequest: (NavigationRequest request) {
            // Se a URL for um desses players conhecidos, deixamos passar sempre
            if (request.url.contains("vidsrc") ||
                request.url.contains("vsembed") ||
                request.url.contains("2embed") ||
                request.url.contains("autoembed")) {
              return NavigationDecision.navigate;
            }

            // Bloqueamos apenas se tiver cara de anúncio pesado (popups)
            if (request.url.contains("ads") || request.url.contains("click")) {
              return NavigationDecision.prevent;
            }

            // Em caso de dúvida no vidsrc, permite navegar (para evitar tela preta)
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://vidsrc.xyz/embed/movie/${widget.movieId}?ds_&language=pt-BR&region=BR'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading) const Center(child: CircularProgressIndicator(color: Colors.red)),
        ],
      ),
    );
  }
}
