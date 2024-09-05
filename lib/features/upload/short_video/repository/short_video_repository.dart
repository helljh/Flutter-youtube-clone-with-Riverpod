import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/features/upload/short_video/model/short_video_model.dart';
import 'package:youtube_clone/home_page.dart';

final shortVideoProvider = Provider((ref) {
  return ShortVideoRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

class ShortVideoRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ShortVideoRepository({
    required this.auth,
    required this.firestore,
  });

  Future<void> addShortVideoToFirestore({
    required String caption,
    required String shortVideo,
    required DateTime datePublished,
    required BuildContext context,
  }) async {
    ShortVideoModel short = ShortVideoModel(
      caption: caption,
      userId: auth.currentUser!.uid,
      shortVideo: shortVideo,
      datePublished: datePublished,
    );
    await firestore
        .collection("shorts")
        .add(short.toMap())
        .then((value) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            )));
  }
}
