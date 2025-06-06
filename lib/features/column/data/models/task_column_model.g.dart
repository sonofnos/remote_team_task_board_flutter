// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_column_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskColumnModel _$TaskColumnModelFromJson(Map<String, dynamic> json) =>
    TaskColumnModel(
      id: json['id'] as String,
      name: json['name'] as String,
      workspaceId: json['workspaceId'] as String,
      position: (json['position'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TaskColumnModelToJson(TaskColumnModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'workspaceId': instance.workspaceId,
      'position': instance.position,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
