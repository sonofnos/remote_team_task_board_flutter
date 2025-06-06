import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../../column/domain/entities/task_column.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final GetTasks getTasks;
  final CreateTask createTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskCubit({
    required this.getTasks,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TaskInitial());

  Future<void> loadTasks(String columnId) async {
    emit(TaskLoading());

    final result = await getTasks(GetTasksParams(columnId: columnId));

    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (tasks) => emit(TaskLoaded(tasks: tasks, columns: [])),
    );
  }

  Future<void> createNewTask({
    required String columnId,
    required String title,
    required String description,
    String priority = 'medium',
    List<String> tags = const [],
    int position = 0,
  }) async {
    emit(TaskLoading());

    final params = CreateTaskParams(
      columnId: columnId,
      title: title,
      description: description,
      priority: priority,
      tags: tags,
      position: position,
    );

    final result = await createTask(params);

    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (_) => loadTasks(columnId),
    );
  }

  Future<void> updateExistingTask({
    required String id,
    required String columnId,
    String? title,
    String? description,
    String? newColumnId,
  }) async {
    final params = UpdateTaskParams(
      id: id,
      title: title,
      description: description,
      columnId: newColumnId,
    );

    final result = await updateTask(params);

    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (_) => loadTasks(columnId),
    );
  }

  Future<void> deleteExistingTask(String id, String columnId) async {
    final result = await deleteTask(DeleteTaskParams(id: id));

    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (_) => loadTasks(columnId),
    );
  }
}
