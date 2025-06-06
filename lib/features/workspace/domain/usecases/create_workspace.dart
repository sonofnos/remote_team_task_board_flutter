import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/workspace.dart';
import '../repositories/workspace_repository.dart';

class CreateWorkspace implements UseCase<Workspace, CreateWorkspaceParams> {
  final WorkspaceRepository repository;

  CreateWorkspace(this.repository);

  @override
  Future<Either<Failure, Workspace>> call(CreateWorkspaceParams params) async {
    return await repository.createWorkspace(
      name: params.name,
      description: params.description,
    );
  }
}

class CreateWorkspaceParams extends Equatable {
  final String name;
  final String description;

  const CreateWorkspaceParams({required this.name, required this.description});

  @override
  List<Object> get props => [name, description];
}
