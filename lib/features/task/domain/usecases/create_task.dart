import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart' as task_entity;
import '../repositories/task_repository.dart';

class CreateTask implements UseCase<task_entity.Task, CreateTaskParams> {
  final TaskRepository repository;

  CreateTask(this.repository);

  @override
  Future<Either<Failure, task_entity.Task>> call(
    CreateTaskParams params,
  ) async {
    return await repository.createTask(
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

class CreateTaskParams {
  final String title;
  final String description;
  final String columnId;
  final String? assigneeId;
  final DateTime? deadline;
  final String priority;
  final List<String> tags;
  final int position;

  CreateTaskParams({
    required this.title,
    required this.description,
    required this.columnId,
    this.assigneeId,
    this.deadline,
    required this.priority,
    required this.tags,
    required this.position,
  });
}
