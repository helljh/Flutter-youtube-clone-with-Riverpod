import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_clone/cores/screens/loader.dart';

import '../../../../cores/methods.dart';
import '../repository/short_video_repository.dart';

class ShortVideoDetailsPage extends ConsumerStatefulWidget {
  final File video;
  const ShortVideoDetailsPage({super.key, required this.video});

  @override
  ConsumerState<ShortVideoDetailsPage> createState() =>
      _ShortVideoDetailsPageState();
}

class _ShortVideoDetailsPageState extends ConsumerState<ShortVideoDetailsPage> {
  final captionController = TextEditingController();
  final DateTime date = DateTime.now();
  final randomNumber = const Uuid().v4();
  bool isPublishClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Video Details",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: captionController,
              decoration: const InputDecoration(
                hintText: "Write a caption...",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  String videoUrl = await putFileInStorage(
                      widget.video, randomNumber, "video");

                  await ref.watch(shortVideoProvider).addShortVideoToFirestore(
                        caption: captionController.text,
                        shortVideo: videoUrl,
                        datePublished: date,
                        context: context,
                      );
                  setState(() {
                    isPublishClicked = true;
                  });
                },
                child: isPublishClicked ? const Loader() : const Text("등록"),
              ),
            )
          ],
        ),
      )),
    );
  }
}
