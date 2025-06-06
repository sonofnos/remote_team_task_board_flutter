import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/task_column.dart';

part 'task_column_model.g.dart';

@JsonSerializable()
class TaskColumnModel extends TaskColumn {
  const TaskColumnModel({
    required super.id,
    required super.name,
    required super.workspaceId,
    required super.position,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TaskColumnModel.fromJson(Map<String, dynamic> json) =>
      _$TaskColumnModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskColumnModelToJson(this);

  factory TaskColumnModel.fromEntity(TaskColumn column) {
    return TaskColumnModel(
      id: column.id,
      name: column.name,
      workspaceId: column.workspaceId,
      position: column.position,
      createdAt: column.createdAt,
      updatedAt: column.updatedAt,
    );
  }

  TaskColumn toEntity() {
    return TaskColumn(
      id: id,
      name: name,
      workspaceId: workspaceId,
      position: position,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
