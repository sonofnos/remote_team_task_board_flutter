part of 'workspace_bloc.dart';

abstract class WorkspaceEvent extends Equatable {
  const WorkspaceEvent();

  @override
  List<Object> get props => [];
}

class LoadWorkspacesEvent extends WorkspaceEvent {}

class CreateWorkspaceEvent extends WorkspaceEvent {
  final String name;
  final String? description;

  const CreateWorkspaceEvent({required this.name, this.description});

  @override
  List<Object> get props => [name, description ?? ''];
}
