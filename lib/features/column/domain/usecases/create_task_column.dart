import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_column.dart';
import '../repositories/task_column_repository.dart';

class CreateTaskColumn implements UseCase<TaskColumn, CreateTaskColumnParams> {
  final TaskColumnRepository repository;

  CreateTaskColumn(this.repository);

  @override
  Future<Either<Failure, TaskColumn>> call(
    CreateTaskColumnParams params,
  ) async {
    return await repository.createColumn(
      name: params.name,
      workspaceId: params.workspaceId,
      position: params.position,
    );
  }
}

class CreateTaskColumnParams {
  final String name;
  final String workspaceId;
  final int position;

  CreateTaskColumnParams({
    required this.name,
    required this.workspaceId,
    required this.position,
  });
}
