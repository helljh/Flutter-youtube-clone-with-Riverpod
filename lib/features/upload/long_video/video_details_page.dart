import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_clone/cores/methods.dart';
import 'package:youtube_clone/cores/screens/loader.dart';
import 'package:youtube_clone/features/upload/long_video/video_repository.dart';

class VideoDetailsPage extends ConsumerStatefulWidget {
  final File? video;
  const VideoDetailsPage({super.key, this.video});

  @override
  ConsumerState<VideoDetailsPage> createState() => _VideoDetailsPageState();
}

class _VideoDetailsPageState extends ConsumerState<VideoDetailsPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  File? image;
  bool isThumbnailSelected = false;
  String randomNumber = const Uuid().v4();
  String videoId = const Uuid().v4();
  bool isPublishClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 10,
            right: 10,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "제목 입력",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "제목을 입력해주세요",
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "상세설명 입력",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "상세설명을 입력해주세요",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),

                //select thumbnail
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(11)),
                    child: TextButton(
                        onPressed: () async {
                          image = await pickImage();
                          isThumbnailSelected = true;
                          setState(() {});
                        },
                        child: const Text(
                          "썸네일 선택",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                ),

                isThumbnailSelected
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Image.file(
                          image!,
                          cacheHeight:
                              (MediaQuery.of(context).size.height * 0.3)
                                  .toInt(),
                          cacheWidth: 400,
                        ),
                      )
                    : const SizedBox(),

                // publish
                isThumbnailSelected
                    ? Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              String thumbnail = await putFileInStorage(
                                  image, randomNumber, "image");

                              String videoUrl = await putFileInStorage(
                                  widget.video, randomNumber, "video");

                              ref
                                  .read(longVideoProvider)
                                  .uploadVideoToFirestore(
                                      videoUrl: videoUrl,
                                      thumbnail: thumbnail,
                                      title: titleController.text,
                                      videoId: videoId,
                                      datePublished: DateTime.now(),
                                      userId: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      context: context);

                              setState(() {
                                isPublishClicked = true;
                              });
                            },
                            child: isPublishClicked
                                ? const Loader()
                                : const Text("등록")),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
