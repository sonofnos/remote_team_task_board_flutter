import 'dart:convert';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../models/task_column_model.dart';

abstract class TaskColumnRemoteDataSource {
  Future<List<TaskColumnModel>> getColumns(String workspaceId);
  Future<TaskColumnModel> getColumn(String id);
  Future<TaskColumnModel> createColumn({
    required String name,
    required String workspaceId,
    required int position,
  });
  Future<TaskColumnModel> updateColumn({
    required String id,
    String? name,
    int? position,
  });
  Future<void> deleteColumn(String id);
}

class TaskColumnRemoteDataSourceImpl implements TaskColumnRemoteDataSource {
  final ApiClient apiClient;

  TaskColumnRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TaskColumnModel>> getColumns(String workspaceId) async {
    try {
      final response = await apiClient.get(
        ApiConstants.columnsEndpoint,
        queryParameters: {'workspaceId': workspaceId},
        headers: {'Content-Type': ApiConstants.contentType},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => TaskColumnModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          'Failed to fetch columns: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw ServerException('Failed to fetch columns: $e');
    }
  }

  @override
  Future<TaskColumnModel> getColumn(String id) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.columnsEndpoint}/$id',
        headers: {'Content-Type': ApiConstants.contentType},
      );

      if (response.statusCode == 200) {
        return TaskColumnModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw NotFoundException('Column not found');
      } else {
        throw ServerException('Failed to fetch column: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Failed to fetch column: $e');
    }
  }

  @override
  Future<TaskColumnModel> createColumn({
    required String name,
    required String workspaceId,
    required int position,
  }) async {
    try {
      final body = {
        'name': name,
        'workspaceId': workspaceId,
        'position': position,
      };

      final response = await apiClient.post(
        ApiConstants.columnsEndpoint,
        headers: {'Content-Type': ApiConstants.contentType},
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        return TaskColumnModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException(
          'Failed to create column: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw ServerException('Failed to create column: $e');
    }
  }

  @override
  Future<TaskColumnModel> updateColumn({
    required String id,
    String? name,
    int? position,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (position != null) body['position'] = position;

      final response = await apiClient.put(
        '${ApiConstants.columnsEndpoint}/$id',
        headers: {'Content-Type': ApiConstants.contentType},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return TaskColumnModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw NotFoundException('Column not found');
      } else {
        throw ServerException(
          'Failed to update column: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw ServerException('Failed to update column: $e');
    }
  }

  @override
  Future<void> deleteColumn(String id) async {
    try {
      final response = await apiClient.delete(
        '${ApiConstants.columnsEndpoint}/$id',
        headers: {'Content-Type': ApiConstants.contentType},
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        if (response.statusCode == 404) {
          throw NotFoundException('Column not found');
        } else {
          throw ServerException(
            'Failed to delete column: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      throw ServerException('Failed to delete column: $e');
    }
  }
}
