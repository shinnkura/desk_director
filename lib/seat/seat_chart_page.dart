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
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: StreamBuilder(
          stream: firestore.collection('seats').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('エラーが発生しました。'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var seats = snapshot.data!.docs;
            int totalCells = rows * rows;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rows,
                crossAxisSpacing: isSmallScreen ? 0 : 4,
                mainAxisSpacing: isSmallScreen ? 0 : 4,
                childAspectRatio: isSmallScreen ? 1 / 2 : 1,
              ),
              itemCount: totalCells,
              itemBuilder: (context, index) {
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

  Widget _buildGridSelector(
      Function(int, int) onSelect, List<DocumentSnapshot> occupiedSeats) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: rows,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: rows * rows,
      itemBuilder: (context, index) {
        int row = index ~/ rows;
        int column = index % rows;

        // 既に埋まっている座席をチェック
        bool isOccupied = occupiedSeats
            .any((seat) => seat['row'] == row && seat['column'] == column);

        return GestureDetector(
          onTap: isOccupied ? null : () => onSelect(row, column),
          child: Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: isOccupied
                  ? Colors.grey
                  : Colors.orange[100], // 埋まっている座席はグレー表示
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

    // Firestoreから座席データを取得
    QuerySnapshot seatSnapshot = await firestore.collection('seats').get();
    List<DocumentSnapshot> occupiedSeats = seatSnapshot.docs;

    // グリッド上の位置を選択するダイアログを表示
    // ignore: use_build_context_synchronously
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('座席の位置を選択'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: _buildGridSelector((row, column) {
              selectedRow = row;
              selectedColumn = column;
              Navigator.of(context).pop();
            }, occupiedSeats),
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
        margin: isSmallScreen
            ? EdgeInsets.zero
            : const EdgeInsets.all(4.0), // スマホではマージンを0に
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
            if (!hasText)
              Icon(
                Icons.event_seat,
                size: isSmallScreen ? 18 : 24,
                color: Colors.orange[800],
              ),
            if (hasText && isSmallScreen)
              for (var char in seatName.split(''))
                Text(
                  char,
                  style: TextStyle(
                    fontSize: seatName.length > 2 ? 10 : 16,
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
