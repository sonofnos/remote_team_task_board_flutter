import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart' as task_entity;
import '../repositories/task_repository.dart';

class GetTask implements UseCase<task_entity.Task, GetTaskParams> {
  final TaskRepository repository;

  GetTask(this.repository);

  @override
  Future<Either<Failure, task_entity.Task>> call(GetTaskParams params) async {
    return await repository.getTask(params.id);
  }
}

class GetTaskParams {
  final String id;

  GetTaskParams({required this.id});
}
