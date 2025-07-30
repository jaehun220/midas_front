// lib/kakao_map_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:convert';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    final jsKey = dotenv.env['NAVER_CLIENT_KEY']!;
    return Scaffold(
      appBar: AppBar(title: const Text("카카오 맵")),
      body: FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString('assets/naver_map.html'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final htmlString = snapshot.data!.replaceAll('{{NAVER_CLIENT_KEY}}', jsKey);

          return InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri.uri(Uri.dataFromString(
                htmlString,
                mimeType: 'text/html',
                encoding: Encoding.getByName('utf-8'),
              )),
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
          );
        },
      ),
    );
  }
}
