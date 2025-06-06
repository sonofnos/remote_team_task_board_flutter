import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String content;
  final String taskId;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Comment({
    required this.id,
    required this.content,
    required this.taskId,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [
    id,
    content,
    taskId,
    authorId,
    authorName,
    createdAt,
    updatedAt,
  ];

  Comment copyWith({
    String? id,
    String? content,
    String? taskId,
    String? authorId,
    String? authorName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Comment(
      id: id ?? this.id,
      content: content ?? this.content,
      taskId: taskId ?? this.taskId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
