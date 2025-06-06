part of 'task_column_bloc.dart';

abstract class TaskColumnState extends Equatable {
  const TaskColumnState();

  @override
  List<Object> get props => [];
}

class TaskColumnInitial extends TaskColumnState {}

class TaskColumnLoading extends TaskColumnState {}

class TaskColumnLoaded extends TaskColumnState {
  final List<TaskColumn> columns;

  const TaskColumnLoaded({required this.columns});

  @override
  List<Object> get props => [columns];
}

class TaskColumnError extends TaskColumnState {
  final String message;

  const TaskColumnError({required this.message});

  @override
  List<Object> get props => [message];
}

class TaskColumnOperationSuccess extends TaskColumnState {
  final String message;
  final List<TaskColumn> columns;

  const TaskColumnOperationSuccess({
    required this.message,
    required this.columns,
  });

  @override
  List<Object> get props => [message, columns];
}
