import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_column.dart';
import '../repositories/task_column_repository.dart';

class UpdateTaskColumn implements UseCase<TaskColumn, UpdateTaskColumnParams> {
  final TaskColumnRepository repository;

  UpdateTaskColumn(this.repository);

  @override
  Future<Either<Failure, TaskColumn>> call(
    UpdateTaskColumnParams params,
  ) async {
    return await repository.updateColumn(
      id: params.id,
      name: params.name,
      position: params.position,
    );
  }
}

class UpdateTaskColumnParams {
  final String id;
  final String? name;
  final int? position;

  UpdateTaskColumnParams({required this.id, this.name, this.position});
}
