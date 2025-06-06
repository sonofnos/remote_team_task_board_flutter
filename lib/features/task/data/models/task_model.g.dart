// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  columnId: json['columnId'] as String,
  assigneeId: json['assigneeId'] as String?,
  deadline:
      json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
  priority: json['priority'] as String,
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  position: (json['position'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'columnId': instance.columnId,
  'assigneeId': instance.assigneeId,
  'deadline': instance.deadline?.toIso8601String(),
  'priority': instance.priority,
  'tags': instance.tags,
  'position': instance.position,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
