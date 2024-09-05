// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_clone/features/upload/comments/comment_model.dart';

final commentProvider = Provider(
  (ref) => CommentRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class CommentRepository {
  final FirebaseFirestore firestore;
  CommentRepository({
    required this.firestore,
  });

  Future<void> uploadCommentToFirestore({
    required String commentText,
    required String videoId,
    required String displayName,
    required String profilePic,
    required DateTime commentRegisterd,
  }) async {
    String commentId = const Uuid().v4();
    CommentModel comment = CommentModel(
      commentText: commentText,
      videoId: videoId,
      commentId: commentId,
      displayName: displayName,
      profilePic: profilePic,
      commentRegisterd: commentRegisterd,
    );
    await firestore.collection("comments").doc(commentId).set(comment.toMap());
  }

  Future<List<CommentModel>> fetchVideoComments(videoId) async {
    final commentsMap = await firestore
        .collection("comments")
        .where("videoId", isEqualTo: videoId)
        .get();
    final List<CommentModel> comments = commentsMap.docs
        .map((comment) => CommentModel.fromMap(comment.data()))
        .toList();

    return comments;
  }
}
