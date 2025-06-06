import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/task.dart' as task_entity;

abstract class TaskRepository {
  Future<Either<Failure, List<task_entity.Task>>> getTasks(String columnId);

  Future<Either<Failure, task_entity.Task>> getTask(String id);

  Future<Either<Failure, task_entity.Task>> createTask({
    required String title,
    required String description,
    required String columnId,
    String? assigneeId,
    DateTime? deadline,
    required String priority,
    required List<String> tags,
    required int position,
  });

  Future<Either<Failure, task_entity.Task>> updateTask({
    required String id,
    String? title,
    String? description,
    String? columnId,
    String? assigneeId,
    DateTime? deadline,
    String? priority,
    List<String>? tags,
    int? position,
  });

  Future<Either<Failure, void>> deleteTask(String id);
}
