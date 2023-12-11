import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeatChartPage extends StatefulWidget {
  const SeatChartPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SeatChartPageState createState() => _SeatChartPageState();
}

class _SeatChartPageState extends State<SeatChartPage> {
  final int rows = 12;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('座席表'),
        backgroundColor: Colors.orange, // アプリのカラースキームに合わせる
      ),
      body: StreamBuilder(
        stream: firestore.collection('seats').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            // エラーハンドリング
          }
          if (!snapshot.hasData) {
            // データがない場合の処理
          }

          var seats = snapshot.data!.docs;
          // グリッドの全セル数を設定
          int totalCells = rows * rows;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: rows,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: isSmallScreen ? 1 / 2 : 1, // スマホサイズでは縦長の比率にする
            ),
            itemCount: totalCells,
            itemBuilder: (context, index) {
              // 現在のセルの行と列を計算
              int row = index ~/ rows;
              int column = index % rows;

              var seat = seats.firstWhereOrNull(
                (s) => s['row'] == row && s['column'] == column,
              );

              return seat != null ? _buildSeatItem(seat) : Container();
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

  Widget _buildGridSelector(Function(int, int) onSelect) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: rows,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: rows * rows, // 例えば、12行12列のグリッド
      itemBuilder: (context, index) {
        int row = index ~/ rows;
        int column = index % rows;
        return GestureDetector(
          onTap: () => onSelect(row, column),
          child: Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        );
      },
    );
  }

  void _addNewSeat() async {
    int selectedRow = -1;
    int selectedColumn = -1;

    // グリッド上の位置を選択するダイアログを表示
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('座席の位置を選択'),
          content: SizedBox(
            // GridViewのサイズを設定
            width: double.maxFinite,
            height: 300, // 適切な高さに設定
            child: _buildGridSelector((row, column) {
              selectedRow = row;
              selectedColumn = column;
              Navigator.of(context).pop();
            }),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    // 位置が選択された場合、名前を入力するダイアログを表示
    if (selectedRow != -1 && selectedColumn != -1) {
      String newName = '';
      // ignore: use_build_context_synchronously
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('座席名の入力'),
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
                child: const Text('OK'),
                onPressed: () {
                  firestore.collection('seats').add({
                    'name': newName,
                    'row': selectedRow,
                    'column': selectedColumn,
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _deleteSeat(String seatId) async {
    await firestore.collection('seats').doc(seatId).delete();
  }

  Widget _buildSeatItem(DocumentSnapshot seat) {
    bool hasText = seat['name'] != null && seat['name'].toString().isNotEmpty;
    bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    String seatName = seat['name'].toString();

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (!hasText) Icon(Icons.event_seat, color: Colors.orange[800]),
            if (hasText && isSmallScreen)
              for (var char in seatName.split(''))
                Text(
                  char,
                  style: TextStyle(
                    fontSize:
                        seatName.length > 2 ? 8 : 16, // 3文字を超える場合はサイズを小さくする
                  ),
                ),
            if (hasText && !isSmallScreen)
              Text(
                seatName,
                style: const TextStyle(
                  fontSize: 16,
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
