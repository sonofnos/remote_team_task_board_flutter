import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/task_cubit.dart';
import '../widgets/column_card.dart';

class ColumnsPage extends StatelessWidget {
  const ColumnsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Columns')),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            final columns = state.columns;

            if (columns.isEmpty) {
              return const Center(
                child: Text('No columns found. Add one to get started!'),
              );
            }

            return ListView.builder(
              itemCount: columns.length,
              itemBuilder: (context, index) {
                return ColumnCard(column: columns[index]);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add logic to create a new column
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
