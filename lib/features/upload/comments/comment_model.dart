// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommentModel {
  final String commentText;
  final String videoId;
  final String commentId;
  final String displayName;
  final String profilePic;
  final DateTime commentRegisterd;

  CommentModel({
    required this.commentText,
    required this.videoId,
    required this.commentId,
    required this.displayName,
    required this.profilePic,
    required this.commentRegisterd,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentText': commentText,
      'videoId': videoId,
      'commentId': commentId,
      'displayName': displayName,
      'profilePic': profilePic,
      'commentRegistered': commentRegisterd.millisecondsSinceEpoch,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentText: map['commentText'] as String,
      videoId: map['videoId'] as String,
      commentId: map['commentId'] as String,
      displayName: map['displayName'] as String,
      profilePic: map['profilePic'] as String,
      commentRegisterd:
          DateTime.fromMillisecondsSinceEpoch(map['commentRegistered'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
