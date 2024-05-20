import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app_with_clean_architecture/core/util/snackbar_message.dart';
import 'package:posts_app_with_clean_architecture/features/posts/presentation/cubit/add_update_delete_posts/add_update_delete_posts_cubit.dart';
import 'package:posts_app_with_clean_architecture/features/posts/presentation/pages/posts_page.dart';

import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/post.dart';
import '../widgets/post_add_update_page/form_widget.dart';

class PostAddUpdatePage extends StatelessWidget {
  final Post? post;
  final bool isUpdatePost;

  const PostAddUpdatePage({super.key, this.post, required this.isUpdatePost});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(isUpdatePost ? "Update" : "Add"),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child:
            BlocConsumer<AddUpdateDeletePostsCubit, AddUpdateDeletePostsState>(
          listener: (context, state) {
            if (state is AddUpdateDeletePostsSuccessState) {
              SnackBarMessage().showSuccessSnackBar(message: state.message, context: context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PostsPage(),
                  ),(route) => false,);
            } else if (state is AddUpdateDeletePostsError) {
             SnackBarMessage().showFailedSnackBar(message: state.message, context: context);
            }
          },
          builder: (context, state) {
            if (state is AddUpdateDeletePostsLoading) {
              return const LoadingWidget();
            }
            else{
              return FormWidget(
                  isUpdatePost: isUpdatePost, post: isUpdatePost ? post : null);
            }

          },
        ),
      ),
    );
  }
}
