import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getSeatsStream() {
    return _firestore.collection('seats').snapshots();
  }

  Future<void> updateSeatName(String seatId, String newName) async {
    await _firestore.collection('seats').doc(seatId).update({'name': newName});
  }
}
