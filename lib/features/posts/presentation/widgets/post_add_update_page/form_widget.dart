import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app_with_clean_architecture/features/posts/presentation/cubit/add_update_delete_posts/add_update_delete_posts_cubit.dart';
import 'package:posts_app_with_clean_architecture/features/posts/presentation/widgets/post_add_update_page/text_form_field_widget.dart';

import '../../../domain/entities/post.dart';

class FormWidget extends StatefulWidget {
  final bool isUpdatePost;
  final Post? post;

  const FormWidget({super.key, required this.isUpdatePost, this.post});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdatePost) {
      _titleController.text = widget.post!.title;
      _bodyController.text = widget.post!.body;
    }

  }

  void validateFormThenUpdateOrAddPost() {
    if (_formKey.currentState!.validate()) {
      final post = Post(
          id: widget.isUpdatePost ? widget.post!.id : null,
          title: _titleController.text,
          body: _bodyController.text);
      if (widget.isUpdatePost) {
        context.read<AddUpdateDeletePostsCubit>().updatePost(post);
      } else {
        context.read<AddUpdateDeletePostsCubit>().addPost(post);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormFieldWidget(name: "Title", multiLines : false, controller: _titleController ),
          TextFormFieldWidget(name: "Body", multiLines : true, controller: _bodyController,),
          ElevatedButton.icon(
              onPressed: validateFormThenUpdateOrAddPost,
              icon: widget.isUpdatePost
                  ? const Icon(Icons.edit)
                  : const Icon(Icons.add),
              label: Text(widget.isUpdatePost ? "Update" : "Add"))
        ],
      ),
    );
  }
}

