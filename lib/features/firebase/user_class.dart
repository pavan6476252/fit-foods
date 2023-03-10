import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser {
  String? name;
  String? photoUrl;
  String? emailId;
  String? mobileNumber;
  CurrentUser({this.name, this.photoUrl, this.emailId, this.mobileNumber});

  CurrentUser mapDocSnapshotToCurrentUser(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return CurrentUser(
      name: data?['name'],
      photoUrl: data?['photoUrl'],
      emailId: data?['emailId'],
      mobileNumber: data?['mobileNumber'],
    );
  }
}
