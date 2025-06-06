import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_column.dart';
import '../repositories/task_column_repository.dart';

class GetTaskColumns
    implements UseCase<List<TaskColumn>, GetTaskColumnsParams> {
  final TaskColumnRepository repository;

  GetTaskColumns(this.repository);

  @override
  Future<Either<Failure, List<TaskColumn>>> call(
    GetTaskColumnsParams params,
  ) async {
    return await repository.getColumns(params.workspaceId);
  }
}

class GetTaskColumnsParams {
  final String workspaceId;

  GetTaskColumnsParams({required this.workspaceId});
}
