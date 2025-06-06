class ApiConstants {
  static const String baseUrl = 'http://localhost:8080';
  static const String authEndpoint = '/auth';
  static const String workspacesEndpoint = '/workspaces';
  static const String columnsEndpoint = '/columns';
  static const String tasksEndpoint = '/tasks';
  static const String commentsEndpoint = '/comments';

  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}
