import 'package:flutter/material.dart';
import '../../../comment/domain/entities/comment.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  final VoidCallback? onTap;

  const CommentCard({super.key, required this.comment, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          comment.content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: Text(
          'Created: ${comment.createdAt.day}/${comment.createdAt.month}/${comment.createdAt.year}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: onTap != null ? const Icon(Icons.more_vert) : null,
        onTap: onTap,
      ),
    );
  }
}
