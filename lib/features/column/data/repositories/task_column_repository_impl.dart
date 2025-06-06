import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/task_column.dart';
import '../../domain/repositories/task_column_repository.dart';
import '../datasources/task_column_remote_data_source.dart';

class TaskColumnRepositoryImpl implements TaskColumnRepository {
  final TaskColumnRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TaskColumnRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TaskColumn>>> getColumns(
    String workspaceId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteColumns = await remoteDataSource.getColumns(workspaceId);
        return Right(remoteColumns.map((model) => model.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.message));
      } catch (e) {
        return const Left(ServerFailure('An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, TaskColumn>> getColumn(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteColumn = await remoteDataSource.getColumn(id);
        return Right(remoteColumn.toEntity());
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return const Left(ServerFailure('An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, TaskColumn>> createColumn({
    required String name,
    required String workspaceId,
    required int position,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteColumn = await remoteDataSource.createColumn(
          name: name,
          workspaceId: workspaceId,
          position: position,
        );
        return Right(remoteColumn.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.message));
      } catch (e) {
        return const Left(ServerFailure('An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, TaskColumn>> updateColumn({
    required String id,
    String? name,
    int? position,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteColumn = await remoteDataSource.updateColumn(
          id: id,
          name: name,
          position: position,
        );
        return Right(remoteColumn.toEntity());
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return const Left(ServerFailure('An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteColumn(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteColumn(id);
        return const Right(null);
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return const Left(ServerFailure('An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
