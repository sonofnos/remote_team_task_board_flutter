import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:remote_team_task_board_flutter/core/error/failures.dart';
import 'package:remote_team_task_board_flutter/core/usecases/usecase.dart';
import 'package:remote_team_task_board_flutter/features/workspace/domain/entities/workspace.dart';
import 'package:remote_team_task_board_flutter/features/workspace/domain/usecases/create_workspace.dart';
import 'package:remote_team_task_board_flutter/features/workspace/domain/usecases/get_workspaces.dart';
import 'package:remote_team_task_board_flutter/features/workspace/presentation/bloc/workspace_bloc.dart';

import 'workspace_bloc_test.mocks.dart';

@GenerateMocks([GetWorkspaces, CreateWorkspace])
void main() {
  late WorkspaceBloc workspaceBloc;
  late MockGetWorkspaces mockGetWorkspaces;
  late MockCreateWorkspace mockCreateWorkspace;

  setUp(() {
    mockGetWorkspaces = MockGetWorkspaces();
    mockCreateWorkspace = MockCreateWorkspace();

    workspaceBloc = WorkspaceBloc(
      getWorkspaces: mockGetWorkspaces,
      createWorkspace: mockCreateWorkspace,
    );
  });

  tearDown(() {
    workspaceBloc.close();
  });

  group('WorkspaceBloc', () {
    final tWorkspace = Workspace(
      id: '1',
      name: 'Test Workspace',
      description: 'Test Description',
      ownerId: 'user1',
      memberCount: 1,
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023),
    );

    final tWorkspaceList = [tWorkspace];

    test('initial state should be WorkspaceInitial', () {
      expect(workspaceBloc.state, equals(WorkspaceInitial()));
    });

    group('LoadWorkspacesEvent', () {
      blocTest<WorkspaceBloc, WorkspaceState>(
        'should emit [WorkspaceLoading, WorkspaceLoaded] when loading workspaces is successful',
        build: () {
          when(
            mockGetWorkspaces(const NoParams()),
          ).thenAnswer((_) async => Right(tWorkspaceList));
          return workspaceBloc;
        },
        act: (bloc) => bloc.add(LoadWorkspacesEvent()),
        expect:
            () => [
              WorkspaceLoading(),
              WorkspaceLoaded(workspaces: tWorkspaceList),
            ],
      );

      blocTest<WorkspaceBloc, WorkspaceState>(
        'should emit [WorkspaceLoading, WorkspaceError] when loading workspaces fails',
        build: () {
          when(
            mockGetWorkspaces(const NoParams()),
          ).thenAnswer((_) async => Left(ServerFailure('Server failure')));
          return workspaceBloc;
        },
        act: (bloc) => bloc.add(LoadWorkspacesEvent()),
        expect:
            () => [
              WorkspaceLoading(),
              const WorkspaceError(message: 'Server failure'),
            ],
      );
    });

    group('CreateWorkspaceEvent', () {
      const tName = 'New Workspace';
      const tDescription = 'New Description';

      blocTest<WorkspaceBloc, WorkspaceState>(
        'should emit [WorkspaceLoading] and then trigger LoadWorkspacesEvent when creation is successful',
        build: () {
          when(
            mockCreateWorkspace(
              const CreateWorkspaceParams(
                name: tName,
                description: tDescription,
              ),
            ),
          ).thenAnswer((_) async => Right(tWorkspace));
          when(
            mockGetWorkspaces(const NoParams()),
          ).thenAnswer((_) async => Right(tWorkspaceList));
          return workspaceBloc;
        },
        act:
            (bloc) => bloc.add(
              const CreateWorkspaceEvent(
                name: tName,
                description: tDescription,
              ),
            ),
        expect:
            () => [
              WorkspaceLoading(),
              WorkspaceLoading(),
              WorkspaceLoaded(workspaces: tWorkspaceList),
            ],
      );

      blocTest<WorkspaceBloc, WorkspaceState>(
        'should emit [WorkspaceLoading, WorkspaceError] when creation fails',
        build: () {
          when(
            mockCreateWorkspace(
              const CreateWorkspaceParams(
                name: tName,
                description: tDescription,
              ),
            ),
          ).thenAnswer((_) async => Left(ServerFailure('Server failure')));
          return workspaceBloc;
        },
        act:
            (bloc) => bloc.add(
              const CreateWorkspaceEvent(
                name: tName,
                description: tDescription,
              ),
            ),
        expect:
            () => [
              WorkspaceLoading(),
              const WorkspaceError(message: 'Server failure'),
            ],
      );
    });
  });
}
