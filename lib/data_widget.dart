import 'storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

const Color blue = Color(0xFF4285F4);
const Color red = Color(0xFFEA4335);
const Color yellow = Color(0xFFFBBC05);
const Color green = Color(0xFF34A853);

class DataWidget extends StatelessWidget {
  DataWidget({Key? key, required this.item}) : super(key: key);

  final ColoredDashboardItem item;

  final Map<String, Widget Function(ColoredDashboardItem i)> _map = {
    "add": (l) => const AddAdvice(),
    "pub": (l) => const Pub(),
  };

  @override
  Widget build(BuildContext context) {
    // item.dataがnullでないことを確認し、nullの場合は代替のウィジェットを表示
    if (item.data != null && _map.containsKey(item.data)) {
      return _map[item.data]!(item);
    } else {
      // item.dataがnullの場合やマップに存在しない場合の処理
      return const Center(child: Text('Data not available'));
    }
  }
}

class Pub extends StatelessWidget {
  const Pub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launchUrlString("https://pub.dev/packages/dashboard");
      },
      child: Container(
        color: Colors.white,
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage("assets/pub_dev.png"),
            ),
          ),
        ),
      ),
    );
  }
}

class AddAdvice extends StatelessWidget {
  const AddAdvice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: blue,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
          Text(
            "Add own colored widget with custom sizes.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
