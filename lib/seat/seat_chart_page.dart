import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeatChartPage extends StatefulWidget {
  const SeatChartPage({super.key});

  @override
  _SeatChartPageState createState() => _SeatChartPageState();
}

class _SeatChartPageState extends State<SeatChartPage> {
  final int rows = 12;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('座席表'),
        backgroundColor: Colors.orange, // アプリのカラースキームに合わせる
      ),
      body: StreamBuilder(
        stream: firestore.collection('seats').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'データの読み込みに失敗しました。\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.orange, // インジケータの色を変更
              ),
            );
          }

          var seats = snapshot.data!.docs;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: rows,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: seats.length,
            itemBuilder: (context, index) {
              var seat = seats[index];
              return _buildSeatItem(seat);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewSeat,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _editSeatName(String seatId) async {
    String newName = '';
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('座席名の編集'),
          content: TextField(
            onChanged: (value) {
              newName = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('保存'),
              onPressed: () {
                firestore
                    .collection('seats')
                    .doc(seatId)
                    .update({'name': newName});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addNewSeat() async {
    try {
      await firestore.collection('seats').add({'name': ''});
    } catch (e) {
      print('エラーが発生しました: $e');
    }
  }

  void _deleteSeat(String seatId) async {
    await firestore.collection('seats').doc(seatId).delete();
  }

  Widget _buildSeatItem(DocumentSnapshot seat) {
    bool hasText = seat['name'] != null && seat['name'].toString().isNotEmpty;

    return GestureDetector(
      onTap: () => _editSeatName(seat.id),
      onLongPress: () => _showDeleteConfirmation(seat.id),
      child: Container(
        margin: const EdgeInsets.all(4.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.orange[100],
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (!hasText) // テキストがない場合のみアイコンを表示
              Icon(Icons.event_seat, color: Colors.orange[800]),
            if (hasText) // テキストがある場合のみテキストを表示
              Flexible(
                child: Text(
                  seat['name'],
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String seatId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('座席を削除'),
          content: const Text('この座席を削除してもよろしいですか？'),
          actions: <Widget>[
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('削除'),
              onPressed: () {
                _deleteSeat(seatId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
