import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/workspace.dart';
import '../../domain/usecases/get_workspaces.dart';
import '../../domain/usecases/create_workspace.dart';
import 'package:go_router/go_router.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  final GetWorkspaces getWorkspaces;
  final CreateWorkspace createWorkspace;
  final GoRouter router;

  WorkspaceCubit({
    required this.getWorkspaces,
    required this.createWorkspace,
    required this.router,
  }) : super(WorkspaceInitial());

  Future<void> loadWorkspaces() async {
    emit(WorkspaceLoading());

    final result = await getWorkspaces(const NoParams());

    result.fold(
      (failure) => emit(WorkspaceError(message: failure.message)),
      (workspaces) => emit(WorkspaceLoaded(workspaces: workspaces)),
    );
  }

  Future<void> createNewWorkspace({
    required String name,
    required String description,
  }) async {
    emit(WorkspaceLoading());

    final params = CreateWorkspaceParams(name: name, description: description);

    final result = await createWorkspace(params);

    result.fold(
      (failure) => emit(WorkspaceError(message: failure.message)),
      (_) => loadWorkspaces(),
    );
  }

  void navigateToBoard(String workspaceId) {
    if (state is WorkspaceLoaded) {
      final currentState = state as WorkspaceLoaded;
      final workspace = currentState.workspaces.firstWhere(
        (w) => w.id == workspaceId,
        orElse: () => throw Exception('Workspace not found'),
      );

      emit(WorkspaceSelected(workspace: workspace));

      // Navigate to board view with workspace ID
      router.go('/board/$workspaceId');
    }
  }
}

// Part implementation: workspace_state.dart
abstract class WorkspaceState extends Equatable {
  const WorkspaceState();

  @override
  List<Object?> get props => [];
}

class WorkspaceInitial extends WorkspaceState {}

class WorkspaceLoading extends WorkspaceState {}

class WorkspaceLoaded extends WorkspaceState {
  final List<Workspace> workspaces;

  const WorkspaceLoaded({required this.workspaces});

  @override
  List<Object?> get props => [workspaces];
}

class WorkspaceSelected extends WorkspaceState {
  final Workspace workspace;

  const WorkspaceSelected({required this.workspace});

  @override
  List<Object?> get props => [workspace];
}

class WorkspaceError extends WorkspaceState {
  final String message;

  const WorkspaceError({required this.message});

  @override
  List<Object?> get props => [message];
}
