import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_clone/cores/screens/error_page.dart';
import 'package:youtube_clone/cores/screens/loader.dart';
import 'package:youtube_clone/features/content/Long_video/parts/post.dart';
import 'package:youtube_clone/features/upload/long_video/video_model.dart';

class LongVideoScreen extends StatelessWidget {
  const LongVideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("videos").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty ||
              snapshot.data == null) {
            return const ErrorPage();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          final videoMaps = snapshot.data!.docs;

          if (videoMaps.isEmpty) {
            return const Center(
              child: Text("No videos available"),
            ); // 문서가 비어 있을 때 표시할 내용
          }

          final videos = videoMaps
              .map((video) {
                final videoData = video.data() as Map<String, dynamic>?;

                // null 체크 추가
                if (videoData == null) {
                  return null;
                }

                return VideoModel.fromMap(videoData);
              })
              .whereType<VideoModel>()
              .toList(); // null이 아닌 비디오만 리스트에 추가

          if (videos.isEmpty) {
            return const Center(
              child: Text("No valid videos available"),
            ); // 유효한 비디오가 없을 때 표시할 내용
          }
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              return Post(
                video: videos[index],
              );
            },
          );
        },
      ),
    );
  }
}
