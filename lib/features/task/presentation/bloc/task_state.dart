part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<task_entity.Task> tasks;

  const TaskLoaded({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

class TaskError extends TaskState {
  final String message;

  const TaskError({required this.message});

  @override
  List<Object> get props => [message];
}

class TaskOperationSuccess extends TaskState {
  final String message;
  final List<task_entity.Task> tasks;

  const TaskOperationSuccess({required this.message, required this.tasks});

  @override
  List<Object> get props => [message, tasks];
}
