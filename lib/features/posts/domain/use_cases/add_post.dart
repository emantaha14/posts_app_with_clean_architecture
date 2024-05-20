import 'package:dartz/dartz.dart';

import '../../../../core/error_handler/failures.dart';
import '../entities/post.dart';
import '../repositories/post_repo.dart';

class AddPostUseCase{
  final PostsRepo postsRepo;
  AddPostUseCase({required this.postsRepo});
  Future<Either<Failure, Unit>> call(Post post) async{
    return await postsRepo.addPost(post);
  }
}