part of 'comment_cubit.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object?> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<Comment> comments;

  const CommentLoaded({required this.comments});

  @override
  List<Object?> get props => [comments];
}

class CommentError extends CommentState {
  final String message;

  const CommentError({required this.message});

  @override
  List<Object?> get props => [message];
}
