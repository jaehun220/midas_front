// lib/kakao_map_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:convert';

class KakaoMapView extends StatefulWidget {
  const KakaoMapView({super.key});

  @override
  State<KakaoMapView> createState() => _KakaoMapViewState();
}

class _KakaoMapViewState extends State<KakaoMapView> {
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    final jsKey = dotenv.env['KAKAO_JS_KEY']!;
    return Scaffold(
      appBar: AppBar(title: const Text("카카오 맵")),
      body: FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString('assets/kakao_map_template.html'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final htmlString = snapshot.data!.replaceAll('{{KAKAO_JS_KEY}}', jsKey);

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
