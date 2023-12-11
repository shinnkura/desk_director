import 'dart:async';
import 'dart:math';

import 'package:desk_director/firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';

import 'add_dialog.dart';
import 'data_widget.dart';
import 'seat/main.dart';
import 'storage.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard online demo',
      initialRoute: "/",
      routes: {
        "/": (c) => const MainPage(),
        "/dashboard": (c) => const DashboardWidget(),
        "/seat": (c) => const SeatChart()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("style_dart framework documentation coming soon...",
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/dashboard");
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                child: Text("Try dashboard demo"),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/seat");
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                child: Text("Try seat chart demo"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  final ScrollController scrollController = ScrollController();

  late var itemController =
      DashboardItemController<ColoredDashboardItem>.withDelegate(
          itemStorageDelegate: storage);

  bool refreshing = false;

  var storage = MyItemStorage();

  // slotを常に8に設定
  int slot = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4285F4),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              await storage.clear();
              setState(() {
                refreshing = true;
              });
              storage = MyItemStorage();
              itemController = DashboardItemController.withDelegate(
                  itemStorageDelegate: storage);
              Future.delayed(const Duration(milliseconds: 150)).then((value) {
                setState(() {
                  refreshing = false;
                });
              });
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              itemController.clear();
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              add(context);
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              itemController.isEditing = !itemController.isEditing;
              setState(() {});
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SafeArea(
        child: refreshing
            ? const Center(child: CircularProgressIndicator())
            : Dashboard<ColoredDashboardItem>(
                shrinkToPlace: false,
                slideToTop: true,
                absorbPointer: false,
                padding: const EdgeInsets.all(8),
                horizontalSpace: 8,
                verticalSpace: 8,
                slotAspectRatio: 2,
                animateEverytime: true,
                dashboardItemController: itemController,
                slotCount: slot, // slotの値を8に設定
                errorPlaceholder: (e, s) {
                  return Text("$e , $s");
                },
                itemStyle: ItemStyle(
                  color: Colors.transparent,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                physics: const RangeMaintainingScrollPhysics(),
                editModeSettings: EditModeSettings(
                  paintBackgroundLines: true,
                  resizeCursorSide: 15,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                  backgroundStyle: const EditModeBackgroundStyle(
                    lineColor: Colors.black38,
                    lineWidth: 0.5,
                    dualLineHorizontal: true,
                    dualLineVertical: true,
                  ),
                ),
                itemBuilder: (ColoredDashboardItem item) {
                  return DataWidget(item: item);
                },
              ),
      ),
    );
  }

  Future<void> add(BuildContext context) async {
    var res = await showDialog(
      context: context,
      builder: (c) {
        return const AddDialog();
      },
    );

    if (res != null) {
      itemController.add(
        ColoredDashboardItem(
          color: res[6],
          width: res[0],
          height: res[1],
          startX: 1,
          startY: 3,
          identifier: (Random().nextInt(100000) + 4).toString(),
          minWidth: res[2],
          minHeight: res[3],
          maxWidth: res[4] == 0 ? null : res[4],
          maxHeight: res[5] == 0 ? null : res[5],
          text: res[7],
        ),
        mountToTop: false,
      );
    }
  }
}
