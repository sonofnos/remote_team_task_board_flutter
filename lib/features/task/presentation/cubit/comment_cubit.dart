import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../comment/domain/entities/comment.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(CommentInitial());

  Future<void> loadComments(String taskId) async {
    emit(CommentLoading());

    // TODO: Implement comment loading logic
    // For now, just emit empty state
    emit(const CommentLoaded(comments: []));
  }

  Future<void> createComment({
    required String taskId,
    required String content,
  }) async {
    emit(CommentLoading());

    // TODO: Implement comment creation logic
    // For now, just reload comments
    await loadComments(taskId);
  }
}
