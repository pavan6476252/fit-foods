import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medirec/features/auth/auth_services.dart';
import 'package:medirec/features/firebase/user_class.dart';
import 'package:provider/provider.dart';

class FirestoreService with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> isDocumentPresent(BuildContext context, String docId) async {
    try {
      DocumentReference docRef = _db.collection('users').doc(docId);
      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      var snackBar = SnackBar(
        content: Text('Error while checking documenet. $e'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return false;
  }

  Future<void> updateData(
    BuildContext context,
  ) async {
    try {
      CurrentUser? user = context.read<AuthService>().user;
      // print( user!.emailId??"");
      DocumentReference docRef = _db.collection('users').doc(user!.emailId);

      await docRef.set({
        'name': user.name,
        'photoUrl': user.photoUrl,
        'emailId': user.emailId,
        'mobileNumber': user.mobileNumber,
      });
  var snackBar =const SnackBar(
    backgroundColor: Colors.greenAccent,
        content: Text('User Data updatiom Success.'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar,);
      // notifyListeners();
    } catch (e) {
      // print('Error updating data: $e');
      var snackBar = SnackBar(
         backgroundColor: Colors.redAccent,
        content: Text('User Data updatiom failed. $e'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<CurrentUser?> getData(String docId) async {
    try {
      DocumentReference docRef = _db.collection('users').doc(docId);
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        return CurrentUser().mapDocSnapshotToCurrentUser(
            docSnapshot.data() as DocumentSnapshot<Map<String, dynamic>>);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting data: $e');
      throw Exception('Failed to get data');
    }
  }
}
