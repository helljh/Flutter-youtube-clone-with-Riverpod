import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/features/upload/comments/comment_model.dart';
import 'package:youtube_clone/features/upload/comments/comment_repository.dart';

final commentsProvider = FutureProvider.family((ref, videoId) async {
  final List<CommentModel> comments =
      await ref.watch(commentProvider).fetchVideoComments(videoId);

  return comments;
});
