import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart' as task_entity;
import '../repositories/task_repository.dart';

class GetTasks implements UseCase<List<task_entity.Task>, GetTasksParams> {
  final TaskRepository repository;

  GetTasks(this.repository);

  @override
  Future<Either<Failure, List<task_entity.Task>>> call(
    GetTasksParams params,
  ) async {
    return await repository.getTasks(params.columnId);
  }
}

class GetTasksParams {
  final String columnId;

  GetTasksParams({required this.columnId});
}
