import 'dart:convert';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks(String columnId);
  Future<TaskModel> getTask(String id);
  Future<TaskModel> createTask({
    required String title,
    required String description,
    required String columnId,
    String? assigneeId,
    DateTime? deadline,
    required String priority,
    required List<String> tags,
    required int position,
  });
  Future<TaskModel> updateTask({
    required String id,
    String? title,
    String? description,
    String? columnId,
    String? assigneeId,
    DateTime? deadline,
    String? priority,
    List<String>? tags,
    int? position,
  });
  Future<void> deleteTask(String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final ApiClient apiClient;

  TaskRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TaskModel>> getTasks(String columnId) async {
    try {
      final response = await apiClient.get(
        ApiConstants.tasksEndpoint,
        queryParameters: {'columnId': columnId},
        headers: {'Content-Type': ApiConstants.contentType},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Failed to load tasks: $e');
    }
  }

  @override
  Future<TaskModel> getTask(String id) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.tasksEndpoint}/$id',
        headers: {'Content-Type': ApiConstants.contentType},
      );

      if (response.statusCode == 200) {
        return TaskModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw NotFoundException('Task not found');
      } else {
        throw ServerException('Failed to get task: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Failed to get task: $e');
    }
  }

  @override
  Future<TaskModel> createTask({
    required String title,
    required String description,
    required String columnId,
    String? assigneeId,
    DateTime? deadline,
    required String priority,
    required List<String> tags,
    required int position,
  }) async {
    try {
      final body = {
        'title': title,
        'description': description,
        'columnId': columnId,
        'assigneeId': assigneeId,
        'deadline': deadline?.toIso8601String(),
        'priority': priority,
        'tags': tags,
        'position': position,
      };

      final response = await apiClient.post(
        ApiConstants.tasksEndpoint,
        headers: {'Content-Type': ApiConstants.contentType},
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        return TaskModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException('Failed to create task: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Failed to create task: $e');
    }
  }

  @override
  Future<TaskModel> updateTask({
    required String id,
    String? title,
    String? description,
    String? columnId,
    String? assigneeId,
    DateTime? deadline,
    String? priority,
    List<String>? tags,
    int? position,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;
      if (columnId != null) body['columnId'] = columnId;
      if (assigneeId != null) body['assigneeId'] = assigneeId;
      if (deadline != null) body['deadline'] = deadline.toIso8601String();
      if (priority != null) body['priority'] = priority;
      if (tags != null) body['tags'] = tags;
      if (position != null) body['position'] = position;

      final response = await apiClient.put(
        '${ApiConstants.tasksEndpoint}/$id',
        headers: {'Content-Type': ApiConstants.contentType},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return TaskModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw NotFoundException('Task not found');
      } else {
        throw ServerException('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      final response = await apiClient.delete(
        '${ApiConstants.tasksEndpoint}/$id',
        headers: {'Content-Type': ApiConstants.contentType},
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        if (response.statusCode == 404) {
          throw NotFoundException('Task not found');
        } else {
          throw ServerException(
            'Failed to delete task: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      throw ServerException('Failed to delete task: $e');
    }
  }
}
