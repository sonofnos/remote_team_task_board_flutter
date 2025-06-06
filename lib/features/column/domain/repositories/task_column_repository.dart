import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/task_column.dart';

abstract class TaskColumnRepository {
  Future<Either<Failure, List<TaskColumn>>> getColumns(String workspaceId);

  Future<Either<Failure, TaskColumn>> getColumn(String id);

  Future<Either<Failure, TaskColumn>> createColumn({
    required String name,
    required String workspaceId,
    required int position,
  });

  Future<Either<Failure, TaskColumn>> updateColumn({
    required String id,
    String? name,
    int? position,
  });

  Future<Either<Failure, void>> deleteColumn(String id);
}
