import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final String columnId;
  final String? assigneeId;
  final DateTime? deadline;
  final String priority;
  final List<String> tags;
  final int position;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.columnId,
    this.assigneeId,
    this.deadline,
    required this.priority,
    required this.tags,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    columnId,
    assigneeId,
    deadline,
    priority,
    tags,
    position,
    createdAt,
    updatedAt,
  ];

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? columnId,
    String? assigneeId,
    DateTime? deadline,
    String? priority,
    List<String>? tags,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      columnId: columnId ?? this.columnId,
      assigneeId: assigneeId ?? this.assigneeId,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isOverdue {
    if (deadline == null) return false;
    return DateTime.now().isAfter(deadline!);
  }

  bool get isDueSoon {
    if (deadline == null) return false;
    final now = DateTime.now();
    final daysUntilDeadline = deadline!.difference(now).inDays;
    return daysUntilDeadline <= 3 && daysUntilDeadline >= 0;
  }
}
