import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/task.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.columnId,
    super.assigneeId,
    super.deadline,
    required super.priority,
    required super.tags,
    required super.position,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      columnId: task.columnId,
      assigneeId: task.assigneeId,
      deadline: task.deadline,
      priority: task.priority,
      tags: task.tags,
      position: task.position,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }

  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      columnId: columnId,
      assigneeId: assigneeId,
      deadline: deadline,
      priority: priority,
      tags: tags,
      position: position,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
