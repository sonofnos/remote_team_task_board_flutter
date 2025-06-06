import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/auth_wrapper.dart';
import '../../features/task/presentation/pages/board_page.dart';
import '../../features/task/presentation/pages/task_details_page.dart';
import '../../features/workspace/presentation/pages/workspace_list_page.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(path: '/', builder: (context, state) => const AuthWrapper()),
      GoRoute(
        path: '/workspaces',
        builder: (context, state) => const WorkspaceListPage(),
      ),
      GoRoute(
        path: '/board/:workspaceId',
        builder: (context, state) {
          final workspaceId = state.pathParameters['workspaceId']!;
          return BoardPage(workspaceId: workspaceId);
        },
      ),
      GoRoute(
        path: '/task/:taskId',
        builder: (context, state) {
          final taskId = state.pathParameters['taskId']!;
          return TaskDetailsPage(taskId: taskId);
        },
      ),
    ],
  );
}
