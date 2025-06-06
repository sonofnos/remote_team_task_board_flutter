import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/workspace.dart';
import '../../domain/repositories/workspace_repository.dart';
import '../datasources/workspace_remote_data_source.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final WorkspaceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WorkspaceRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Workspace>>> getWorkspaces() async {
    if (await networkInfo.isConnected) {
      try {
        final workspaces = await remoteDataSource.getWorkspaces();
        return Right(workspaces.map((model) => model.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Workspace>> getWorkspace(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final workspace = await remoteDataSource.getWorkspace(id);
        return Right(workspace.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Workspace>> createWorkspace({
    required String name,
    required String description,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final workspace = await remoteDataSource.createWorkspace(
          name: name,
          description: description,
        );
        return Right(workspace.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Workspace>> updateWorkspace({
    required String id,
    String? name,
    String? description,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final workspace = await remoteDataSource.updateWorkspace(
          id: id,
          name: name,
          description: description,
        );
        return Right(workspace.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWorkspace(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteWorkspace(id);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
