part of 'task_column_bloc.dart';

abstract class TaskColumnEvent extends Equatable {
  const TaskColumnEvent();

  @override
  List<Object?> get props => [];
}

class LoadTaskColumnsEvent extends TaskColumnEvent {
  final String workspaceId;

  const LoadTaskColumnsEvent({required this.workspaceId});

  @override
  List<Object> get props => [workspaceId];
}

class CreateTaskColumnEvent extends TaskColumnEvent {
  final String title;
  final String workspaceId;

  const CreateTaskColumnEvent({required this.title, required this.workspaceId});

  @override
  List<Object> get props => [title, workspaceId];
}

class UpdateTaskColumnEvent extends TaskColumnEvent {
  final String id;
  final String? title;
  final int? position;

  const UpdateTaskColumnEvent({required this.id, this.title, this.position});

  @override
  List<Object?> get props => [id, title, position];
}

class DeleteTaskColumnEvent extends TaskColumnEvent {
  final String id;

  const DeleteTaskColumnEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class ReorderTaskColumnsEvent extends TaskColumnEvent {
  final String workspaceId;
  final List<String> columnIds;

  const ReorderTaskColumnsEvent({
    required this.workspaceId,
    required this.columnIds,
  });

  @override
  List<Object> get props => [workspaceId, columnIds];
}
