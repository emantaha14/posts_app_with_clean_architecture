import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app_with_clean_architecture/features/posts/presentation/cubit/posts/posts_cubit.dart';
import 'package:posts_app_with_clean_architecture/features/posts/presentation/pages/post_add_update_page.dart';
import 'package:posts_app_with_clean_architecture/features/posts/presentation/widgets/posts_page/message_display_widget.dart';

import '../../../../core/widgets/loading_widget.dart';
import '../widgets/posts_page/posts_list_widget.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionBtn(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Posts'),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<PostsCubit, PostsState>(
        builder: (context, state) {
         if(state is PostsLoading) {
           return const LoadingWidget();
         }
         else if(state is PostsLoaded){
           return RefreshIndicator(
             onRefresh: ()=> _onRefresh(context),
             child: PostsListWidget(
               posts: state.posts,
             ),
           );
         }
         else if(state is PostsError) {
           return MessageDisplayWidget(
             message: state.message,
           );
         }
         return const LoadingWidget();

      },),
    );
  }
  Future<void> _onRefresh(BuildContext context) async{
    context.read<PostsCubit>().fetchPosts();
  }
  Widget _buildFloatingActionBtn(BuildContext context){
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const PostAddUpdatePage( isUpdatePost: false),));
      },
      tooltip: 'add',
      child: const Icon(Icons.add),
    );
  }
}
