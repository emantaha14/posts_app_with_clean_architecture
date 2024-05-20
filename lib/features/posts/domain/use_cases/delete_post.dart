import 'package:dartz/dartz.dart';
import 'package:posts_app_with_clean_architecture/features/posts/domain/repositories/post_repo.dart';

import '../../../../core/error_handler/failures.dart';

class DeletePostUseCase{
  final PostsRepo postsRepo;
  DeletePostUseCase({required this.postsRepo});
  Future<Either<Failure, Unit>> call(int postId) async{
    return await postsRepo.deletePost(postId);
  }
}