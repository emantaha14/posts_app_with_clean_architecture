import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app_with_clean_architecture/core/app_theme.dart';
import 'package:posts_app_with_clean_architecture/features/posts/presentation/cubit/add_update_delete_posts/add_update_delete_posts_cubit.dart';
import 'package:posts_app_with_clean_architecture/features/posts/presentation/cubit/posts/posts_cubit.dart';

import 'features/posts/presentation/pages/posts_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => di.sl<PostsCubit>()..fetchPosts(),
      ),
      BlocProvider(
        create: (_) => di.sl<AddUpdateDeletePostsCubit>(),
      ),
    ], child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: PostsPage(),
    ));
  }
}
