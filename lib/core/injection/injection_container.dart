import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:remote_team_task_board_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_constants.dart';
import '../network/network_info.dart';
import '../router/app_router.dart';

// Auth
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/domain/usecases/register.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Workspace
import '../../features/workspace/data/datasources/workspace_remote_data_source.dart';
import '../../features/workspace/data/repositories/workspace_repository_impl.dart';
import '../../features/workspace/domain/repositories/workspace_repository.dart';
import '../../features/workspace/domain/usecases/get_workspaces.dart';
import '../../features/workspace/domain/usecases/create_workspace.dart';
import '../../features/workspace/presentation/bloc/workspace_bloc.dart';
import '../../features/workspace/presentation/cubit/workspace_cubit.dart';

// Task
import '../../features/task/data/datasources/task_remote_data_source.dart';
import '../../features/task/data/repositories/task_repository_impl.dart';
import '../../features/task/domain/repositories/task_repository.dart';
import '../../features/task/domain/usecases/get_tasks.dart';
import '../../features/task/domain/usecases/get_task.dart';
import '../../features/task/domain/usecases/create_task.dart';
import '../../features/task/domain/usecases/update_task.dart';
import '../../features/task/domain/usecases/move_task.dart';
import '../../features/task/domain/usecases/delete_task.dart';
import '../../features/task/presentation/bloc/task_bloc.dart';

// Column
import '../../features/column/domain/usecases/get_task_columns.dart';
import '../../features/column/domain/usecases/create_task_column.dart';
import '../../features/column/domain/usecases/update_task_column.dart';
import '../../features/column/domain/usecases/delete_task_column.dart';
import '../../features/column/domain/repositories/task_column_repository.dart';
import '../../features/column/data/repositories/task_column_repository_impl.dart';
import '../../features/column/data/datasources/task_column_remote_data_source.dart';
import '../../features/column/presentation/bloc/task_column_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      login: sl(),
      register: sl(),
      getCurrentUser: sl(),
      logout: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => Logout(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl(), sharedPreferences: sl()),
  );

  //! Features - Workspace
  // Bloc
  sl.registerFactory(
    () => WorkspaceBloc(getWorkspaces: sl(), createWorkspace: sl()),
  );

  // Cubit
  sl.registerFactory(
    () => WorkspaceCubit(
      getWorkspaces: sl(),
      createWorkspace: sl(),
      router: AppRouter.router,
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetWorkspaces(sl()));
  sl.registerLazySingleton(() => CreateWorkspace(sl()));

  // Repository
  sl.registerLazySingleton<WorkspaceRepository>(
    () => WorkspaceRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<WorkspaceRemoteDataSource>(
    () => WorkspaceRemoteDataSourceImpl(apiClient: sl()),
  );

  //! Features - Task
  // Bloc
  sl.registerFactory(
    () => TaskBloc(
      getTasks: sl(),
      getTask: sl(),
      createTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
      moveTask: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => GetTask(sl()));
  sl.registerLazySingleton(() => CreateTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => MoveTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(apiClient: sl()),
  );

  //! Features - Column
  // Bloc
  sl.registerFactory(
    () => TaskColumnBloc(
      getTaskColumns: sl(),
      createTaskColumn: sl(),
      updateTaskColumn: sl(),
      deleteTaskColumn: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTaskColumns(sl()));
  sl.registerLazySingleton(() => CreateTaskColumn(sl()));
  sl.registerLazySingleton(() => UpdateTaskColumn(sl()));
  sl.registerLazySingleton(() => DeleteTaskColumn(sl()));

  // Repository
  sl.registerLazySingleton<TaskColumnRepository>(
    () => TaskColumnRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TaskColumnRemoteDataSource>(
    () => TaskColumnRemoteDataSourceImpl(apiClient: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton(
    () => ApiClient(client: sl(), baseUrl: ApiConstants.baseUrl),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => http.Client());
}
