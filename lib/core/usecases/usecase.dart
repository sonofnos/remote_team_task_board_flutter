import 'package:dartz/dartz.dart';
import '../error/failures.dart';

typedef EitherFuture<T> = Future<Either<Failure, T>>;

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}
