import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../cubit/workspace_cubit.dart';
import '../widgets/workspace_card.dart';
import '../widgets/create_workspace_dialog.dart';

class WorkspaceListPage extends StatefulWidget {
  const WorkspaceListPage({super.key});

  @override
  State<WorkspaceListPage> createState() => _WorkspaceListPageState();
}

class _WorkspaceListPageState extends State<WorkspaceListPage> {
  @override
  void initState() {
    super.initState();
    context.read<WorkspaceCubit>().loadWorkspaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workspaces'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                context.read<AuthBloc>().add(LogoutEvent());
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      body: BlocConsumer<WorkspaceCubit, WorkspaceState>(
        listener: (context, state) {
          if (state is WorkspaceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is WorkspaceSelected) {
            // Navigate to the selected workspace's board
            context.go('/board/${state.workspace.id}');
          }
        },
        builder: (context, state) {
          if (state is WorkspaceLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WorkspaceLoaded) {
            final workspaces = state.workspaces;

            if (workspaces.isEmpty) {
              return Center(
                child: Text(
                  'No workspaces found. Create one to get started!',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: workspaces.length,
              itemBuilder: (context, index) {
                return WorkspaceCard(
                  workspace: workspaces[index],
                  onTap: () {
                    context.read<WorkspaceCubit>().navigateToBoard(
                      workspaces[index].id,
                    );
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateWorkspaceDialog,
        backgroundColor: AppConstants.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCreateWorkspaceDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreateWorkspaceDialog(),
    );
  }
}
