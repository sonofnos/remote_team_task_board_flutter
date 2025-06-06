import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection/injection_container.dart' as di;
import '../../../column/presentation/bloc/task_column_bloc.dart';
import '../bloc/task_bloc.dart';
import 'kanban_board_page.dart';

class BoardPage extends StatelessWidget {
  final String workspaceId;

  const BoardPage({super.key, required this.workspaceId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(create: (context) => di.sl<TaskBloc>()),
        BlocProvider<TaskColumnBloc>(
          create: (context) => di.sl<TaskColumnBloc>(),
        ),
      ],
      child: KanbanBoardPage(
        workspaceId: workspaceId,
        workspaceName:
            'Workspace', // We would ideally fetch this from a repository
      ),
    );
  }
}
