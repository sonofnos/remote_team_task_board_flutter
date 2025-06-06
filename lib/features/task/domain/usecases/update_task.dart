import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart' as task_entity;
import '../repositories/task_repository.dart';

class UpdateTask implements UseCase<task_entity.Task, UpdateTaskParams> {
  final TaskRepository repository;

  UpdateTask(this.repository);

  @override
  Future<Either<Failure, task_entity.Task>> call(
    UpdateTaskParams params,
  ) async {
    return await repository.updateTask(
      id: params.id,
      title: params.title,
      description: params.description,
      columnId: params.columnId,
      assigneeId: params.assigneeId,
      deadline: params.deadline,
      priority: params.priority,
      tags: params.tags,
      position: params.position,
    );
  }
}

class UpdateTaskParams {
  final String id;
  final String? title;
  final String? description;
  final String? columnId;
  final String? assigneeId;
  final DateTime? deadline;
  final String? priority;
  final List<String>? tags;
  final int? position;

  UpdateTaskParams({
    required this.id,
    this.title,
    this.description,
    this.columnId,
    this.assigneeId,
    this.deadline,
    this.priority,
    this.tags,
    this.position,
  });
}
