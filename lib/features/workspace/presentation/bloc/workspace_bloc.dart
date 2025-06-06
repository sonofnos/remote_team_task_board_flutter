import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/workspace.dart';
import '../../domain/usecases/create_workspace.dart';
import '../../domain/usecases/get_workspaces.dart';

part 'workspace_event.dart';
part 'workspace_state.dart';

class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  final GetWorkspaces getWorkspaces;
  final CreateWorkspace createWorkspace;

  WorkspaceBloc({required this.getWorkspaces, required this.createWorkspace})
    : super(WorkspaceInitial()) {
    on<LoadWorkspacesEvent>(_onLoadWorkspaces);
    on<CreateWorkspaceEvent>(_onCreateWorkspace);
  }

  Future<void> _onLoadWorkspaces(
    LoadWorkspacesEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(WorkspaceLoading());

    final result = await getWorkspaces(const NoParams());
    result.fold(
      (failure) => emit(WorkspaceError(message: failure.message)),
      (workspaces) => emit(WorkspaceLoaded(workspaces: workspaces)),
    );
  }

  Future<void> _onCreateWorkspace(
    CreateWorkspaceEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(WorkspaceLoading());

    final result = await createWorkspace(
      CreateWorkspaceParams(
        name: event.name,
        description: event.description ?? '',
      ),
    );

    result.fold((failure) => emit(WorkspaceError(message: failure.message)), (
      workspace,
    ) {
      // Reload workspaces after creating
      add(LoadWorkspacesEvent());
    });
  }
}
