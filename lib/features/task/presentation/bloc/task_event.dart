part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TaskEvent {
  final String columnId;

  const LoadTasksEvent({required this.columnId});

  @override
  List<Object> get props => [columnId];
}

class CreateTaskEvent extends TaskEvent {
  final String title;
  final String description;
  final String columnId;
  final String? assigneeId;
  final DateTime? deadline;
  final String priority;
  final List<String> tags;
  final int position;

  const CreateTaskEvent({
    required this.title,
    required this.description,
    required this.columnId,
    this.assigneeId,
    this.deadline,
    required this.priority,
    required this.tags,
    required this.position,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    columnId,
    assigneeId,
    deadline,
    priority,
    tags,
    position,
  ];
}

class UpdateTaskEvent extends TaskEvent {
  final String id;
  final String? title;
  final String? description;
  final String? columnId;
  final String? assigneeId;
  final DateTime? deadline;
  final String? priority;
  final List<String>? tags;
  final int? position;

  const UpdateTaskEvent({
    required this.id,
    this.title,
    this.description,
    this.columnId,
    this.assigneeId,
    this.deadline,
    this.priority,
    this.tags,
    this.position,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    columnId,
    assigneeId,
    deadline,
    priority,
    tags,
    position,
  ];
}

class DeleteTaskEvent extends TaskEvent {
  final String id;

  const DeleteTaskEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class MoveTaskEvent extends TaskEvent {
  final String taskId;
  final String newColumnId;
  final int newPosition;

  const MoveTaskEvent({
    required this.taskId,
    required this.newColumnId,
    required this.newPosition,
  });

  @override
  List<Object> get props => [taskId, newColumnId, newPosition];
}

class GetTaskEvent extends TaskEvent {
  final String taskId;

  const GetTaskEvent({required this.taskId});

  @override
  List<Object> get props => [taskId];
}
