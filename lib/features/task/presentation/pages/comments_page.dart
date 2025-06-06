import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/comment_cubit.dart';
import '../widgets/comment_card.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: BlocBuilder<CommentCubit, CommentState>(
        builder: (context, state) {
          if (state is CommentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CommentLoaded) {
            final comments = state.comments;

            if (comments.isEmpty) {
              return const Center(
                child: Text('No comments found. Add one to get started!'),
              );
            }

            return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return CommentCard(comment: comments[index]);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add logic to create a new comment
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
