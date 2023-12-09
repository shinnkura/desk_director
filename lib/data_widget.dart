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
    // item.color を使用して背景色を設定
    return Container(
      color: item.color ?? Colors.transparent, // 背景色を設定
      child: (item.data != null && _map.containsKey(item.data))
          ? _map[item.data]!(item)
          : Center(
              child: Text(
                  item.text?.isEmpty ?? true ? 'No text provided' : item.text!),
            ),
    );
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
