import 'package:flutter/material.dart';

import '../../domain/entities/post.dart';
import '../widgets/post_detail_page/post_detail_widget.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;
  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(post),
    );
  }
}

AppBar _buildAppbar(){
  return AppBar(
    title: const Text('Post Detail'),
  );
}

Widget _buildBody(Post post){
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: PostDetailWidget(post: post),
    ),
  );
}