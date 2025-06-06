import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../column/domain/entities/task_column.dart';
import '../../../column/presentation/bloc/task_column_bloc.dart';
import '../../domain/entities/task.dart' as task_entity;
import '../bloc/task_bloc.dart';
import '../widgets/kanban_column.dart';

class KanbanBoardPage extends StatefulWidget {
  final String workspaceId;
  final String workspaceName;

  const KanbanBoardPage({
    super.key,
    required this.workspaceId,
    required this.workspaceName,
  });

  @override
  State<KanbanBoardPage> createState() => _KanbanBoardPageState();
}

class _KanbanBoardPageState extends State<KanbanBoardPage> {
  @override
  void initState() {
    super.initState();
    // Load columns for the workspace
    context.read<TaskColumnBloc>().add(
      LoadTaskColumnsEvent(workspaceId: widget.workspaceId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workspaceName),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () => _addColumn(),
            icon: const Icon(Icons.add),
            tooltip: 'Add Column',
          ),
          IconButton(
            onPressed: () => _refreshBoard(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocConsumer<TaskColumnBloc, TaskColumnState>(
        listener: (context, state) {
          if (state is TaskColumnError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is TaskColumnLoaded && state.columns.isNotEmpty) {
            // Load tasks for all columns when columns are loaded
            for (final column in state.columns) {
              context.read<TaskBloc>().add(LoadTasksEvent(columnId: column.id));
            }
          }
        },
        builder: (context, columnState) {
          if (columnState is TaskColumnLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (columnState is TaskColumnError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load columns',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    columnState.message,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _refreshBoard,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (columnState is TaskColumnLoaded) {
            final columns = columnState.columns;

            if (columns.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.view_column_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No columns yet',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your first column to start organizing tasks',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _addColumn,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Column'),
                    ),
                  ],
                ),
              );
            }

            return BlocConsumer<TaskBloc, TaskState>(
              listener: (context, taskState) {
                if (taskState is TaskError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(taskState.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (taskState is TaskOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(taskState.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              builder: (context, taskState) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        columns.map((column) {
                          // Get tasks for this column
                          final tasks = _getTasksForColumn(
                            taskState,
                            column.id,
                          );

                          return KanbanColumn(
                            columnId: column.id,
                            title: column.name,
                            tasks: tasks,
                            color: _getColumnColor(column.position),
                            onAddTask: () => _addTask(column),
                          );
                        }).toList(),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  List<task_entity.Task> _getTasksForColumn(
    TaskState taskState,
    String columnId,
  ) {
    if (taskState is TaskLoaded) {
      return taskState.tasks
          .where((task) => task.columnId == columnId)
          .toList();
    } else if (taskState is TaskOperationSuccess) {
      return taskState.tasks
          .where((task) => task.columnId == columnId)
          .toList();
    }
    return [];
  }

  Color _getColumnColor(int position) {
    final colors = [
      Colors.blue[100]!,
      Colors.green[100]!,
      Colors.orange[100]!,
      Colors.purple[100]!,
      Colors.teal[100]!,
      Colors.red[100]!,
    ];
    return colors[position % colors.length];
  }

  void _refreshBoard() {
    context.read<TaskColumnBloc>().add(
      LoadTaskColumnsEvent(workspaceId: widget.workspaceId),
    );
  }

  void _addColumn() {
    showDialog(
      context: context,
      builder: (context) => AddColumnDialog(workspaceId: widget.workspaceId),
    );
  }

  void _addTask(TaskColumn column) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(columnId: column.id),
    );
  }
}

class AddColumnDialog extends StatefulWidget {
  final String workspaceId;

  const AddColumnDialog({super.key, required this.workspaceId});

  @override
  State<AddColumnDialog> createState() => _AddColumnDialogState();
}

class _AddColumnDialogState extends State<AddColumnDialog> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Column'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Column Title',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a column title';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<TaskColumnBloc>().add(
                CreateTaskColumnEvent(
                  title: _titleController.text.trim(),
                  workspaceId: widget.workspaceId,
                ),
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  final String columnId;

  const AddTaskDialog({super.key, required this.columnId});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _priority = 'Medium';
  DateTime? _deadline;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items:
                    ['High', 'Medium', 'Low'].map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(priority),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (comma separated)',
                  border: OutlineInputBorder(),
                  hintText: 'bug, feature, urgent',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _deadline == null
                          ? 'No deadline'
                          : 'Deadline: ${_deadline!.day}/${_deadline!.month}/${_deadline!.year}',
                    ),
                  ),
                  FilledButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(
                          const Duration(days: 1),
                        ),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _deadline = date;
                        });
                      }
                    },
                    child: const Text('Set Deadline'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final tags =
                  _tagsController.text
                      .split(',')
                      .map((tag) => tag.trim())
                      .where((tag) => tag.isNotEmpty)
                      .toList();

              context.read<TaskBloc>().add(
                CreateTaskEvent(
                  title: _titleController.text.trim(),
                  description: _descriptionController.text.trim(),
                  columnId: widget.columnId,
                  deadline: _deadline,
                  priority: _priority,
                  tags: tags,
                  position: 0, // Will be adjusted by backend
                ),
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
