import 'dart:convert';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<String> login({required String email, required String password});
  Future<String> register({
    required String email,
    required String password,
    required String name,
  });
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        '${ApiConstants.authEndpoint}/login',
        headers: {'Content-Type': ApiConstants.contentType},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'] as String;
      } else {
        final errorData = jsonDecode(response.body);
        throw ServerException(errorData['error'] ?? 'Login failed');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Network error: $e');
    }
  }

  @override
  Future<String> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await apiClient.post(
        '${ApiConstants.authEndpoint}/register',
        headers: {'Content-Type': ApiConstants.contentType},
        body: jsonEncode({'email': email, 'password': password, 'name': name}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['token'] as String;
      } else {
        final errorData = jsonDecode(response.body);
        throw ServerException(errorData['error'] ?? 'Registration failed');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Network error: $e');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.authEndpoint}/me',
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Authorization':
              'Bearer token', // This will be set by the interceptor
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw ServerException(errorData['error'] ?? 'Failed to get user');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Network error: $e');
    }
  }
}
