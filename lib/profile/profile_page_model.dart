import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePageModel extends ChangeNotifier {
  bool isLoading = false;
  String infoText = 'ログアウトしました。';
  String? email;
  String? username;
  String? rep;
  String? genre;
  String? imgURL;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future signOut() async {
    final _auth = FirebaseAuth.instance;
    await _auth.signOut();
  }

  Future launchUrl() async {
    var url = "https://plantapp-eae67.web.app/";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'アクセスできません。';
    }
  }

  void fetchUser() async {
    final user = FirebaseAuth.instance.currentUser;
    this.email = user?.email;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    this.username = data?['username'];
    this.genre = data?['genre'];
    this.rep = data?['rep'];
    this.imgURL = data?['imgURL'];

    notifyListeners();
  }
}
