import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/workspace.dart';
import '../repositories/workspace_repository.dart';

class GetWorkspaces implements UseCase<List<Workspace>, NoParams> {
  final WorkspaceRepository repository;

  GetWorkspaces(this.repository);

  @override
  Future<Either<Failure, List<Workspace>>> call(NoParams params) async {
    return await repository.getWorkspaces();
  }
}
