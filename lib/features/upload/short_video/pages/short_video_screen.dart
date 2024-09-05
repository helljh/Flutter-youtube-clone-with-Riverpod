// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_editor/video_editor.dart';
import 'package:youtube_clone/cores/methods.dart';
import 'package:youtube_clone/features/auth/provider/user_provider.dart';
import 'package:youtube_clone/features/upload/short_video/pages/short_video_details_page.dart';
import 'package:youtube_clone/features/upload/short_video/widgets/trim_slinder.dart';

class ShortVideoScreen extends StatefulWidget {
  final File shortVideo;
  const ShortVideoScreen({
    super.key,
    required this.shortVideo,
  });

  @override
  State<ShortVideoScreen> createState() => _ShortVideoScreenState();
}

class _ShortVideoScreenState extends State<ShortVideoScreen> {
  VideoEditorController? editorController;
  final isExporting = ValueNotifier<bool>(false);
  final exportingProgress = ValueNotifier<double>(0.0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    editorController = VideoEditorController.file(
      widget.shortVideo,
      minDuration: const Duration(seconds: 3),
      maxDuration: const Duration(seconds: 60),
    );
    editorController!
        .initialize(aspectRatio: 4 / 3.35)
        .then((_) => setState(() {}));
  }

  Future<void> exportVideo() async {
    isExporting.value = true;
    final config = VideoFFmpegVideoEditorConfig(editorController!);
    final execute = await config.getExecuteConfig();
    final String command = execute.command;

    FFmpegKit.executeAsync(
        command,
        (session) async {
          final ReturnCode? code = await session.getReturnCode();
          if (ReturnCode.isSuccess(code)) {
            // export video
            isExporting.value = false;

            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ShortVideoDetailsPage(video: widget.shortVideo);
              },
            ));
          } else {
            // show some errors
            showErrorSnackBar("Failed, video can not be exported", context);
          }
        },
        null,
        (status) {
          exportingProgress.value =
              config.getFFmpegProgress(status.getTime().toInt());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: editorController!.initialized
              ? Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.1),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: double.infinity,
                            child: CropGridViewer.preview(
                              controller: editorController!,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.arrow_back)),
                              Consumer(
                                builder: (context, ref, child) {
                                  final user = ref.watch(currentUserProvider);

                                  return CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.blueGrey,
                                    backgroundImage:
                                        NetworkImage(user.value!.profilePic),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    MyTrimSlider(
                      controller: editorController!,
                      height: 45,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: TextButton(
                          onPressed: exportVideo,
                          child: const Text("Done"),
                        ),
                      ),
                    )
                  ],
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
