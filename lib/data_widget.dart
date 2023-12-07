import 'storage.dart';
import 'package:flutter/material.dart';

const Color blue = Color(0xFF4285F4);
const Color red = Color(0xFFEA4335);
const Color yellow = Color(0xFFFBBC05);
const Color green = Color(0xFF34A853);

class DataWidget extends StatelessWidget {
  DataWidget({Key? key, required this.item}) : super(key: key);

  final ColoredDashboardItem item;

  final Map<String, Widget Function(ColoredDashboardItem i)> _map = {
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
