import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/cores/screens/loader.dart';
import 'package:youtube_clone/features/auth/provider/user_provider.dart';
import 'package:youtube_clone/features/content/comment/comment_tile.dart';
import 'package:youtube_clone/features/upload/comments/comment_model.dart';
import 'package:youtube_clone/features/upload/comments/comment_repository.dart';
import 'package:youtube_clone/features/upload/long_video/video_model.dart';

import '../../auth/model/user_model.dart';

class CommentSheet extends ConsumerStatefulWidget {
  final VideoModel video;
  const CommentSheet({
    super.key,
    required this.video,
  });

  @override
  ConsumerState<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends ConsumerState<CommentSheet> {
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AsyncValue<UserModel> user =
        ref.watch(currentUserProvider).whenData((user) => user);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    "댓글",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.close))
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
            ),
            child: const Text(
                "Remember to keep comments respectful and to follow our community and guideline"),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("comments")
                  .where("videoId", isEqualTo: widget.video.videoId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No Comment"),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Loader();
                }

                final commentsMap = snapshot.data!.docs;
                final comments = commentsMap
                    .map((comment) => CommentModel.fromMap(comment.data()))
                    .toList();

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return CommentTile(comment: comments[index]);
                  },
                );
              },
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(user.value!.profilePic),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: "댓글을 입력하세요",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      await ref
                          .watch(commentProvider)
                          .uploadCommentToFirestore(
                              commentText: commentController.text,
                              videoId: widget.video.videoId,
                              displayName: user.value!.displayName,
                              profilePic: user.value!.profilePic,
                              commentRegisterd: DateTime.now())
                          .then((value) => commentController.text = "");
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.green,
                      size: 30,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
