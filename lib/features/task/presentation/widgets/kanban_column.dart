import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/task.dart' as task_entity;
import '../bloc/task_bloc.dart';
import 'task_card.dart';

class KanbanColumn extends StatelessWidget {
  final String columnId;
  final String title;
  final List<task_entity.Task> tasks;
  final Color? color;
  final VoidCallback? onAddTask;

  const KanbanColumn({
    super.key,
    required this.columnId,
    required this.title,
    required this.tasks,
    this.color,
    this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Column header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: color ?? Colors.blue[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${tasks.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onAddTask,
                  icon: const Icon(Icons.add, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.7),
                    foregroundColor: Colors.grey[800],
                    padding: const EdgeInsets.all(4),
                    minimumSize: const Size(28, 28),
                  ),
                ),
              ],
            ),
          ),
          // Task list
          Expanded(
            child: DragTarget<task_entity.Task>(
              onAcceptWithDetails: (details) {
                final task = details.data;
                if (task.columnId != columnId) {
                  // Calculate new position (at the end of this column)
                  final newPosition = tasks.length;

                  context.read<TaskBloc>().add(
                    MoveTaskEvent(
                      taskId: task.id,
                      newColumnId: columnId,
                      newPosition: newPosition,
                    ),
                  );
                }
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  decoration: BoxDecoration(
                    color:
                        candidateData.isNotEmpty
                            ? Colors.blue.withValues(alpha: 0.1)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child:
                      tasks.isEmpty
                          ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.assignment_outlined,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No tasks',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Drag tasks here or click + to add',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                          : ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return Draggable<task_entity.Task>(
                                data: task,
                                feedback: Material(
                                  elevation: 8,
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    width: 260,
                                    child: TaskCard(task: task),
                                  ),
                                ),
                                childWhenDragging: Opacity(
                                  opacity: 0.5,
                                  child: TaskCard(
                                    task: task,
                                    onTap:
                                        () => _showTaskDetails(context, task),
                                    onEdit: () => _editTask(context, task),
                                    onDelete: () => _deleteTask(context, task),
                                  ),
                                ),
                                child: TaskCard(
                                  task: task,
                                  onTap: () => _showTaskDetails(context, task),
                                  onEdit: () => _editTask(context, task),
                                  onDelete: () => _deleteTask(context, task),
                                ),
                              );
                            },
                          ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTaskDetails(BuildContext context, task_entity.Task task) {
    // Navigate to task details page
    context.go('/task/${task.id}');
  }

  void _editTask(BuildContext context, task_entity.Task task) {
    // TODO: Implement edit task dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit task feature coming soon')),
    );
  }

  void _deleteTask(BuildContext context, task_entity.Task task) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Task'),
            content: Text('Are you sure you want to delete "${task.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<TaskBloc>().add(DeleteTaskEvent(id: task.id));
                },
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
