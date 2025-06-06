import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart' as task_entity;
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/move_task.dart';
import '../../domain/usecases/update_task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final GetTask getTask;
  final CreateTask createTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final MoveTask moveTask;

  TaskBloc({
    required this.getTasks,
    required this.getTask,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
    required this.moveTask,
  }) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<GetTaskEvent>(_onGetTask);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<MoveTaskEvent>(_onMoveTask);
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());

    final result = await getTasks(GetTasksParams(columnId: event.columnId));
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (tasks) => emit(TaskLoaded(tasks: tasks)),
    );
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());

    final result = await createTask(
      CreateTaskParams(
        title: event.title,
        description: event.description,
        columnId: event.columnId,
        assigneeId: event.assigneeId,
        deadline: event.deadline,
        priority: event.priority,
        tags: event.tags,
        position: event.position,
      ),
    );

    result.fold((failure) => emit(TaskError(message: failure.message)), (
      task,
    ) async {
      // Reload tasks to get updated list
      final tasksResult = await getTasks(
        GetTasksParams(columnId: event.columnId),
      );
      tasksResult.fold(
        (failure) => emit(TaskError(message: failure.message)),
        (tasks) => emit(
          TaskOperationSuccess(
            message: 'Task created successfully',
            tasks: tasks,
          ),
        ),
      );
    });
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());

    final result = await updateTask(
      UpdateTaskParams(
        id: event.id,
        title: event.title,
        description: event.description,
        columnId: event.columnId,
        assigneeId: event.assigneeId,
        deadline: event.deadline,
        priority: event.priority,
        tags: event.tags,
        position: event.position,
      ),
    );

    result.fold((failure) => emit(TaskError(message: failure.message)), (
      task,
    ) async {
      // Reload tasks to get updated list
      final columnId = event.columnId ?? task.columnId;
      final tasksResult = await getTasks(GetTasksParams(columnId: columnId));
      tasksResult.fold(
        (failure) => emit(TaskError(message: failure.message)),
        (tasks) => emit(
          TaskOperationSuccess(
            message: 'Task updated successfully',
            tasks: tasks,
          ),
        ),
      );
    });
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());

    final result = await deleteTask(DeleteTaskParams(id: event.id));
    result.fold((failure) => emit(TaskError(message: failure.message)), (_) {
      if (state is TaskLoaded) {
        final currentTasks = (state as TaskLoaded).tasks;
        final updatedTasks =
            currentTasks.where((task) => task.id != event.id).toList();
        emit(
          TaskOperationSuccess(
            message: 'Task deleted successfully',
            tasks: updatedTasks,
          ),
        );
      } else {
        emit(
          const TaskOperationSuccess(
            message: 'Task deleted successfully',
            tasks: [],
          ),
        );
      }
    });
  }

  Future<void> _onMoveTask(MoveTaskEvent event, Emitter<TaskState> emit) async {
    final result = await moveTask(
      MoveTaskParams(
        taskId: event.taskId,
        newColumnId: event.newColumnId,
        newPosition: event.newPosition,
      ),
    );

    result.fold((failure) => emit(TaskError(message: failure.message)), (
      task,
    ) async {
      // Reload tasks for the new column
      final tasksResult = await getTasks(
        GetTasksParams(columnId: event.newColumnId),
      );
      tasksResult.fold(
        (failure) => emit(TaskError(message: failure.message)),
        (tasks) => emit(
          TaskOperationSuccess(
            message: 'Task moved successfully',
            tasks: tasks,
          ),
        ),
      );
    });
  }

  Future<void> _onGetTask(GetTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());

    final result = await getTask(GetTaskParams(id: event.taskId));

    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (task) => emit(
        TaskOperationSuccess(
          message: 'Task loaded successfully',
          tasks: [task],
        ),
      ),
    );
  }
}
