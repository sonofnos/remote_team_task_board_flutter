import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/comment.dart';

abstract class CommentRepository {
  Future<Either<Failure, List<Comment>>> getComments(String taskId);

  Future<Either<Failure, Comment>> getComment(String id);

  Future<Either<Failure, Comment>> createComment({
    required String content,
    required String taskId,
  });

  Future<Either<Failure, Comment>> updateComment({
    required String id,
    required String content,
  });

  Future<Either<Failure, void>> deleteComment(String id);
}
