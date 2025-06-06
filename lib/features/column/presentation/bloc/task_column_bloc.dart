import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/task_column.dart';
import '../../domain/usecases/get_task_columns.dart';
import '../../domain/usecases/create_task_column.dart';
import '../../domain/usecases/update_task_column.dart';
import '../../domain/usecases/delete_task_column.dart';

part 'task_column_event.dart';
part 'task_column_state.dart';

class TaskColumnBloc extends Bloc<TaskColumnEvent, TaskColumnState> {
  final GetTaskColumns getTaskColumns;
  final CreateTaskColumn createTaskColumn;
  final UpdateTaskColumn updateTaskColumn;
  final DeleteTaskColumn deleteTaskColumn;

  TaskColumnBloc({
    required this.getTaskColumns,
    required this.createTaskColumn,
    required this.updateTaskColumn,
    required this.deleteTaskColumn,
  }) : super(TaskColumnInitial()) {
    on<LoadTaskColumnsEvent>(_onLoadTaskColumns);
    on<CreateTaskColumnEvent>(_onCreateTaskColumn);
    on<UpdateTaskColumnEvent>(_onUpdateTaskColumn);
    on<DeleteTaskColumnEvent>(_onDeleteTaskColumn);
  }

  Future<void> _onLoadTaskColumns(
    LoadTaskColumnsEvent event,
    Emitter<TaskColumnState> emit,
  ) async {
    emit(TaskColumnLoading());

    final result = await getTaskColumns(
      GetTaskColumnsParams(workspaceId: event.workspaceId),
    );

    result.fold(
      (failure) => emit(TaskColumnError(message: failure.message)),
      (columns) => emit(TaskColumnLoaded(columns: columns)),
    );
  }

  Future<void> _onCreateTaskColumn(
    CreateTaskColumnEvent event,
    Emitter<TaskColumnState> emit,
  ) async {
    emit(TaskColumnLoading());

    // Calculate position (add to end)
    int position = 0;
    if (state is TaskColumnLoaded) {
      position = (state as TaskColumnLoaded).columns.length;
    }

    final result = await createTaskColumn(
      CreateTaskColumnParams(
        name: event.title,
        workspaceId: event.workspaceId,
        position: position,
      ),
    );

    result.fold((failure) => emit(TaskColumnError(message: failure.message)), (
      column,
    ) async {
      // Reload columns to get updated list
      final columnsResult = await getTaskColumns(
        GetTaskColumnsParams(workspaceId: event.workspaceId),
      );
      columnsResult.fold(
        (failure) => emit(TaskColumnError(message: failure.message)),
        (columns) => emit(
          TaskColumnOperationSuccess(
            message: 'Column created successfully',
            columns: columns,
          ),
        ),
      );
    });
  }

  Future<void> _onUpdateTaskColumn(
    UpdateTaskColumnEvent event,
    Emitter<TaskColumnState> emit,
  ) async {
    emit(TaskColumnLoading());

    final result = await updateTaskColumn(
      UpdateTaskColumnParams(
        id: event.id,
        name: event.title,
        position: event.position,
      ),
    );

    result.fold((failure) => emit(TaskColumnError(message: failure.message)), (
      column,
    ) {
      if (state is TaskColumnLoaded) {
        final currentColumns = (state as TaskColumnLoaded).columns;
        final updatedColumns =
            currentColumns.map((c) {
              return c.id == column.id ? column : c;
            }).toList();

        emit(
          TaskColumnOperationSuccess(
            message: 'Column updated successfully',
            columns: updatedColumns,
          ),
        );
      } else {
        emit(
          TaskColumnOperationSuccess(
            message: 'Column updated successfully',
            columns: [column],
          ),
        );
      }
    });
  }

  Future<void> _onDeleteTaskColumn(
    DeleteTaskColumnEvent event,
    Emitter<TaskColumnState> emit,
  ) async {
    emit(TaskColumnLoading());

    final result = await deleteTaskColumn(DeleteTaskColumnParams(id: event.id));

    result.fold((failure) => emit(TaskColumnError(message: failure.message)), (
      _,
    ) {
      if (state is TaskColumnLoaded) {
        final currentColumns = (state as TaskColumnLoaded).columns;
        final updatedColumns =
            currentColumns.where((column) => column.id != event.id).toList();

        emit(
          TaskColumnOperationSuccess(
            message: 'Column deleted successfully',
            columns: updatedColumns,
          ),
        );
      } else {
        emit(
          const TaskColumnOperationSuccess(
            message: 'Column deleted successfully',
            columns: [],
          ),
        );
      }
    });
  }
}
