import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/comment.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.content,
    required super.taskId,
    required super.authorId,
    required super.authorName,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  factory CommentModel.fromEntity(Comment comment) {
    return CommentModel(
      id: comment.id,
      content: comment.content,
      taskId: comment.taskId,
      authorId: comment.authorId,
      authorName: comment.authorName,
      createdAt: comment.createdAt,
      updatedAt: comment.updatedAt,
    );
  }

  Comment toEntity() {
    return Comment(
      id: id,
      content: content,
      taskId: taskId,
      authorId: authorId,
      authorName: authorName,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
