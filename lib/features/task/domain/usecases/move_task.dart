import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart' as task_entity;
import '../repositories/task_repository.dart';

class MoveTask implements UseCase<task_entity.Task, MoveTaskParams> {
  final TaskRepository repository;

  MoveTask(this.repository);

  @override
  Future<Either<Failure, task_entity.Task>> call(MoveTaskParams params) async {
    return await repository.updateTask(
      id: params.taskId,
      columnId: params.newColumnId,
      position: params.newPosition,
    );
  }
}

class MoveTaskParams {
  final String taskId;
  final String newColumnId;
  final int newPosition;

  MoveTaskParams({
    required this.taskId,
    required this.newColumnId,
    required this.newPosition,
  });
}
