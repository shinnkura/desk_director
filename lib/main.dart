import 'dart:math';

import 'screens/dashboard/dashboard_widget.dart';
import 'screens/main_page.dart';

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color getRandomColor() {
    var r = Random();
    return Color.fromRGBO(r.nextInt(256), r.nextInt(256), r.nextInt(256), 1);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard online demo',
      onGenerateInitialRoutes: (r) {
        return r == "/dashboard"
            ? [
                MaterialPageRoute(builder: (c) {
                  return const DashboardWidget();
                })
              ]
            : [
                MaterialPageRoute(builder: (c) {
                  return const MainPage();
                })
              ];
      },
      initialRoute: "/",
      routes: {
        "/": (c) => const MainPage(),
        "/dashboard": (c) => const DashboardWidget()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
