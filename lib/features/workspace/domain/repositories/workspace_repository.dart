import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/workspace.dart';

abstract class WorkspaceRepository {
  Future<Either<Failure, List<Workspace>>> getWorkspaces();

  Future<Either<Failure, Workspace>> getWorkspace(String id);

  Future<Either<Failure, Workspace>> createWorkspace({
    required String name,
    required String description,
  });

  Future<Either<Failure, Workspace>> updateWorkspace({
    required String id,
    String? name,
    String? description,
  });

  Future<Either<Failure, void>> deleteWorkspace(String id);
}
