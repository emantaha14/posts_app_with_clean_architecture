import 'package:dartz/dartz.dart';
import 'package:posts_app_with_clean_architecture/core/error_handler/failures.dart';
import 'package:posts_app_with_clean_architecture/features/posts/domain/repositories/post_repo.dart';

import '../entities/post.dart';

class UpdatePostUseCase {
  final PostsRepo postsRepo;
  UpdatePostUseCase({required this.postsRepo});
  Future<Either<Failure,Unit>> call (Post post) async{
    return await postsRepo.updatePost(post);
  }

}