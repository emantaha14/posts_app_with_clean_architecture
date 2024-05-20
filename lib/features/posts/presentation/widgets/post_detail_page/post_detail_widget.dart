import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app_with_clean_architecture/core/util/snackbar_message.dart';
import 'package:posts_app_with_clean_architecture/core/widgets/loading_widget.dart';
import 'package:posts_app_with_clean_architecture/features/posts/presentation/cubit/add_update_delete_posts/add_update_delete_posts_cubit.dart';
import 'package:posts_app_with_clean_architecture/features/posts/presentation/pages/post_add_update_page.dart';
import 'package:posts_app_with_clean_architecture/features/posts/presentation/pages/posts_page.dart';

import '../../../domain/entities/post.dart';
import 'delete_dialog_widget.dart';

class PostDetailWidget extends StatelessWidget {
  final Post post;

  const PostDetailWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(post.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const Divider(
            height: 50,
          ),
          Text(post.body, style: const TextStyle(fontSize: 16)),
          const Divider(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          PostAddUpdatePage(isUpdatePost: true, post: post),));
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit')),
              ElevatedButton.icon(
                onPressed: () => deleteDialog(context),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),)
            ],
          )
        ],
      ),
    );
  }

  void deleteDialog(BuildContext context) {
    showDialog(context: context, builder: (context) {
      return BlocConsumer<AddUpdateDeletePostsCubit, AddUpdateDeletePostsState>(
        listener: (context, state) {
          if (state is AddUpdateDeletePostsSuccessState) {
            SnackBarMessage().showSuccessSnackBar(
                message: state.message, context: context);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const PostsPage(),), (
                route) => false);
          }
          else if( state is AddUpdateDeletePostsError){
            Navigator.of(context).pop();
            SnackBarMessage().showFailedSnackBar(
                message: state.message, context: context);
          }

        },
        builder: (context, state) {
          if(state is AddUpdateDeletePostsLoading){
            return const AlertDialog(
              title: LoadingWidget(),
            );
          }
          return DeleteDialogWidget(postId : post.id!);
        },);
    },);
  }
}
