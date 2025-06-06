import 'package:equatable/equatable.dart';
import 'package:remote_team_task_board_flutter/features/workspace/domain/entities/workspace.dart';

abstract class WorkspaceState extends Equatable {
  const WorkspaceState();

  @override
  List<Object> get props => [];
}

class WorkspaceInitial extends WorkspaceState {}

class WorkspaceLoading extends WorkspaceState {}

class WorkspaceLoaded extends WorkspaceState {
  final List<Workspace> workspaces;

  const WorkspaceLoaded({required this.workspaces});

  @override
  List<Object> get props => [workspaces];
}

class WorkspaceError extends WorkspaceState {
  final String message;

  const WorkspaceError({required this.message});

  @override
  List<Object> get props => [message];
}
