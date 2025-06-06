import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/task_bloc.dart';

class TaskDetailsPage extends StatelessWidget {
  final String taskId;

  const TaskDetailsPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          _loadTaskDetails(context);

          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskOperationSuccess && state.tasks.isNotEmpty) {
            final task = state.tasks.first;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),

                  // Description
                  if (task.description.isNotEmpty) ...[
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(task.description),
                    const SizedBox(height: 24),
                  ],

                  // Tags
                  if (task.tags.isNotEmpty) ...[
                    Text(
                      'Tags',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          task.tags
                              .map(
                                (tag) => Chip(
                                  label: Text(tag),
                                  backgroundColor:
                                      Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer,
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Deadline
                  if (task.deadline != null) ...[
                    Text(
                      'Deadline',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${task.deadline!.day}/${task.deadline!.month}/${task.deadline!.year}',
                      style: TextStyle(
                        color:
                            task.deadline!.isBefore(DateTime.now())
                                ? Colors.red
                                : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Technical details
                  ExpansionTile(
                    title: Text('Technical Details'),
                    children: [
                      ListTile(title: Text('Task ID'), subtitle: Text(task.id)),
                      ListTile(
                        title: Text('Column ID'),
                        subtitle: Text(task.columnId),
                      ),
                      ListTile(
                        title: Text('Priority'),
                        subtitle: Text(task.priority),
                      ),
                      if (task.assigneeId != null)
                        ListTile(
                          title: Text('Assignee ID'),
                          subtitle: Text(task.assigneeId!),
                        ),
                    ],
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Task ID:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(taskId),
                const SizedBox(height: 24),
                const Text(
                  'Loading task details...',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _loadTaskDetails(BuildContext context) async {
    // Dispatch a GetTask event to the TaskBloc to load the task details
    context.read<TaskBloc>().add(GetTaskEvent(taskId: taskId));

    // Simulate a small delay for loading animation
    return Future.delayed(const Duration(milliseconds: 500));
  }
}
