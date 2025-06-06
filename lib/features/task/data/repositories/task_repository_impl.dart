import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/task.dart' as task_entity;
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<task_entity.Task>>> getTasks(
    String columnId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTasks = await remoteDataSource.getTasks(columnId);
        return Right(remoteTasks.map((model) => model.toEntity()).toList());
      } on ServerException {
        return const Left(ServerFailure('Failed to fetch tasks'));
      } on NotFoundException {
        return const Left(NotFoundFailure('Column not found'));
      } catch (e) {
        return const Left(ServerFailure('An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, task_entity.Task>> getTask(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTask = await remoteDataSource.getTask(id);
        return Right(remoteTask.toEntity());
      } on NotFoundException {
        return const Left(NotFoundFailure('Task not found'));
      } on ServerException {
        return const Left(ServerFailure('Failed to fetch task'));
      } catch (e) {
        return const Left(ServerFailure('An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, task_entity.Task>> createTask({
    required String title,
    required String description,
    required String columnId,
    String? assigneeId,
    DateTime? deadline,
    required String priority,
    required List<String> tags,
    required int position,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTask = await remoteDataSource.createTask(
          title: title,
          description: description,
          columnId: columnId,
          assigneeId: assigneeId,
          deadline: deadline,
          priority: priority,
          tags: tags,
          position: position,
        );
        return Right(remoteTask.toEntity());
      } on ServerException {
        return const Left(ServerFailure('Failed to create task'));
      } on NotFoundException {
        return const Left(NotFoundFailure('Column not found'));
      } catch (e) {
        return const Left(ServerFailure('An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, task_entity.Task>> updateTask({
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
    if (await networkInfo.isConnected) {
      try {
        final remoteTask = await remoteDataSource.updateTask(
          id: id,
          title: title,
          description: description,
          columnId: columnId,
          assigneeId: assigneeId,
          deadline: deadline,
          priority: priority,
          tags: tags,
          position: position,
        );
        return Right(remoteTask.toEntity());
      } on NotFoundException {
        return const Left(NotFoundFailure('Task not found'));
      } on ServerException {
        return const Left(ServerFailure('Failed to update task'));
      } catch (e) {
        return const Left(ServerFailure('An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteTask(id);
        return const Right(null);
      } on NotFoundException {
        return const Left(NotFoundFailure('Task not found'));
      } on ServerException {
        return const Left(ServerFailure('Failed to delete task'));
      } catch (e) {
        return const Left(ServerFailure('An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
