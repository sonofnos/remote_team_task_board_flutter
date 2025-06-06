import 'package:flutter/material.dart';
import '../../../column/domain/entities/task_column.dart';

class ColumnCard extends StatelessWidget {
  final TaskColumn column;
  final VoidCallback? onTap;

  const ColumnCard({super.key, required this.column, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          column.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text('Position: ${column.position}'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
