import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;
import 'components/bottom_Navbar.dart';

// 기존 마커 + 화살표 마커 (마커 8개)
final List<Map<String, dynamic>> markerList = [
  {"x": 200, "y": 830},
  {"x": 1650, "y": 600},
  {"x": 1650, "y": 830},
  {"x": 1650, "y": 1120},
  {"x": 2730, "y": 480},
  {"x": 2730, "y": 830},
  {"x": 3100, "y": 830},
  {"x": 2915, "y": 200, "isArrow": true}, // <-- 화살표 마커
];

// 이미지 원본 사이즈
const double imageOriginWidth = 3508;
const double imageOriginHeight = 1422;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '캠퍼스 지도',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const CampusMapPage(),
    );
  }
}

class CampusMapPage extends StatefulWidget {
  const CampusMapPage({super.key});

  @override
  State<CampusMapPage> createState() => _CampusMapPageState();
}

class _CampusMapPageState extends State<CampusMapPage> {
  double? _heading; // 방위(heading, 북쪽이 0)

  @override
  void initState() {
    super.initState();
    FlutterCompass.events?.listen((CompassEvent event) {
      setState(() {
        _heading = event.heading;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('캠퍼스 지도')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final displayHeight = constraints.maxHeight;
            final displayWidth = imageOriginWidth * (displayHeight / imageOriginHeight);

            return InteractiveViewer(
              panEnabled: true,
              minScale: 1,
              maxScale: 5,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: displayHeight,
                    minWidth: displayWidth,
                  ),
                  child: Stack(
                    children: [
                      // 지도 이미지
                      Image.asset(
                        'lib/3map.png',
                        fit: BoxFit.fitHeight,
                        height: displayHeight,
                        width: displayWidth,
                      ),
                      // 마커와 화살표
                      ...markerList.map((marker) {
                        double scaledLeft = (marker['x']! / imageOriginWidth) * displayWidth;
                        double scaledTop  = (marker['y']! / imageOriginHeight) * displayHeight;

                        // 화살표 마커(heading 표시, 18도 밑쪽 보정)
                        if (marker['isArrow'] == true) {
                          return Positioned(
                            left: scaledLeft - 16,
                            top: scaledTop - 32,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Transform.rotate(
                                  // 18도 + 180도(밑쪽) 보정
                                  angle: (((_heading ?? 0) - 18 + 180) * (math.pi / 180) * -1),
                                  child: Icon(
                                    Icons.navigation,
                                    size: 32,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "(${marker['x']}, ${marker['y']})",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // 일반 마커
                        return Positioned(
                          left: scaledLeft - 8,
                          top: scaledTop - 8,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "(${marker['x']}, ${marker['y']})",
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNavBar(
          navigating: false,
          onStopNavigation: () {},
        ),
      ),
    );
  }
}
