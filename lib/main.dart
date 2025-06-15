// import 'package:flutter/material.dart';
// import 'screens/campus_map_screen.dart';
// import 'components/bottom_Navbar.dart';
// import 'screens/sensor_test.dart';
// import 'screens/kakaoMapScreen.dart';
// // 추가!
// import 'screens/room_list_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: '캠퍼스 지도',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(useMaterial3: true),
//       home: Scaffold(
//         body: RoomListScreen(), // <- 여기를 RoomListScreen()으로!
//         // body: SensorTest(),
//         // body: Kakaomapscreen(),
//         bottomNavigationBar: BottomNavBar(
//           navigating: false,
//           onStopNavigation: () {},
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'components/bottom_Navbar.dart';

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
      home: Scaffold(
        appBar: AppBar(title: const Text('캠퍼스 지도')),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return InteractiveViewer(
                panEnabled: true,
                minScale: 1,
                maxScale: 5,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Image.asset(
                      'lib/3map.png',
                      fit: BoxFit.fitHeight, // 화면 세로에 맞춤
                      height: constraints.maxHeight,
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
      ),
    );
  }
}


