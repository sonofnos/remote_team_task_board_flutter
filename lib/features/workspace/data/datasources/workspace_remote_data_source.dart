import 'dart:convert';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../models/workspace_model.dart';

abstract class WorkspaceRemoteDataSource {
  Future<List<WorkspaceModel>> getWorkspaces();
  Future<WorkspaceModel> getWorkspace(String id);
  Future<WorkspaceModel> createWorkspace({
    required String name,
    required String description,
  });
  Future<WorkspaceModel> updateWorkspace({
    required String id,
    String? name,
    String? description,
  });
  Future<void> deleteWorkspace(String id);
}

class WorkspaceRemoteDataSourceImpl implements WorkspaceRemoteDataSource {
  final ApiClient apiClient;

  WorkspaceRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<WorkspaceModel>> getWorkspaces() async {
    try {
      final response = await apiClient.get(
        ApiConstants.workspacesEndpoint,
        headers: {'Content-Type': ApiConstants.contentType},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final workspacesJson = responseData['workspaces'] as List;
        return workspacesJson
            .map(
              (json) => WorkspaceModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Failed to get workspaces: $e');
    }
  }

  @override
  Future<WorkspaceModel> getWorkspace(String id) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.workspacesEndpoint}/$id',
        headers: {'Content-Type': ApiConstants.contentType},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return WorkspaceModel.fromJson(responseData['workspace']);
      } else if (response.statusCode == 404) {
        throw ServerException('Workspace not found');
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Failed to get workspace: $e');
    }
  }

  @override
  Future<WorkspaceModel> createWorkspace({
    required String name,
    required String description,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.workspacesEndpoint,
        headers: {'Content-Type': ApiConstants.contentType},
        body: jsonEncode({'name': name, 'description': description}),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return WorkspaceModel.fromJson(responseData['workspace']);
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Failed to create workspace: $e');
    }
  }

  @override
  Future<WorkspaceModel> updateWorkspace({
    required String id,
    String? name,
    String? description,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (description != null) body['description'] = description;

      final response = await apiClient.put(
        '${ApiConstants.workspacesEndpoint}/$id',
        headers: {'Content-Type': ApiConstants.contentType},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return WorkspaceModel.fromJson(responseData['workspace']);
      } else if (response.statusCode == 404) {
        throw ServerException('Workspace not found');
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Failed to update workspace: $e');
    }
  }

  @override
  Future<void> deleteWorkspace(String id) async {
    try {
      final response = await apiClient.delete(
        '${ApiConstants.workspacesEndpoint}/$id',
        headers: {'Content-Type': ApiConstants.contentType},
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 404) {
        throw ServerException('Workspace not found');
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Failed to delete workspace: $e');
    }
  }
}
