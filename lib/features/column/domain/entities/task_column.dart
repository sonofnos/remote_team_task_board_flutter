import 'package:equatable/equatable.dart';

class TaskColumn extends Equatable {
  final String id;
  final String name;
  final String workspaceId;
  final int position;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskColumn({
    required this.id,
    required this.name,
    required this.workspaceId,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [
    id,
    name,
    workspaceId,
    position,
    createdAt,
    updatedAt,
  ];

  TaskColumn copyWith({
    String? id,
    String? name,
    String? workspaceId,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskColumn(
      id: id ?? this.id,
      name: name ?? this.name,
      workspaceId: workspaceId ?? this.workspaceId,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
