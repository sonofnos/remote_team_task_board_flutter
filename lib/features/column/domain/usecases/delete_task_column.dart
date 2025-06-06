import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/task_column_repository.dart';

class DeleteTaskColumn implements UseCase<void, DeleteTaskColumnParams> {
  final TaskColumnRepository repository;

  DeleteTaskColumn(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteTaskColumnParams params) async {
    return await repository.deleteColumn(params.id);
  }
}

class DeleteTaskColumnParams {
  final String id;

  DeleteTaskColumnParams({required this.id});
}
