import 'package:dartz/dartz.dart';
import 'package:posts_app_with_clean_architecture/core/error_handler/failures.dart';
import 'package:posts_app_with_clean_architecture/features/posts/domain/repositories/post_repo.dart';

import '../entities/post.dart';

class GetAllPostsUseCase{
  final PostsRepo postsRepo ;
  GetAllPostsUseCase({required this.postsRepo});

  Future<Either<Failure, List<Post>>> call() async{
    return await postsRepo.getAllPosts();
  }
}