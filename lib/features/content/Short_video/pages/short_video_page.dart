import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_clone/cores/screens/error_page.dart';
import 'package:youtube_clone/cores/screens/loader.dart';
import 'package:youtube_clone/features/upload/short_video/model/short_video_model.dart';

import '../widgets/short_video_tile.dart';

class ShortVideoPage extends StatelessWidget {
  const ShortVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("shorts")
              .orderBy("datePublished", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const ErrorPage();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }

            final shortsMap = snapshot.data!.docs;
            final shorts = shortsMap
                .map((short) => ShortVideoModel.fromMap(short.data()))
                .toList();

            return ListView.builder(
              itemCount: shorts.length,
              itemBuilder: (context, index) {
                return ShortVideoTile(
                  shortVideo: shorts[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
