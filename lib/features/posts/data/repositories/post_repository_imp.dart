import 'package:dartz/dartz.dart';
import 'package:posts_app_with_clean_architecture/core/error_handler/error_exception.dart';
import 'package:posts_app_with_clean_architecture/core/error_handler/failures.dart';
import 'package:posts_app_with_clean_architecture/features/posts/data/models/post_model.dart';
import 'package:posts_app_with_clean_architecture/features/posts/domain/entities/post.dart';
import 'package:posts_app_with_clean_architecture/features/posts/domain/repositories/post_repo.dart';

import '../../../../core/network/network_info.dart';
import '../datasources/post_local_data_source.dart';
import '../datasources/post_remote_data_source.dart';

typedef DeleteOrUpdateOrAddPost = Future<Unit> Function();

class PostsRepositoryImpl implements PostsRepo {
  PostRemoteDataSource remoteDataSource;
  PostLocalDataSource localDataSource;
  NetworkInfo networkInfo;

  PostsRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource, required this.networkInfo});


  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async{
    if(await networkInfo.isConnected){
      try{
        final remotePosts = await remoteDataSource.getAllPosts();
        localDataSource.cachePosts(remotePosts);
        return Right(remotePosts);
      }
      on ServerException{
        return Left(ServerFailure());
      }
    }
    else{
     try{
       final localPosts = await localDataSource.getCachedPosts();
       return Right(localPosts);
     }
     on EmptyCacheException{
       return left(EmptyCacheFailure());
     }
    }
  }

  @override
  Future<Either<Failure, Unit>> addPost(Post post) async{
    PostModel postModel = PostModel( title: post.title, body: post.body);
    return await _getMessage(() async{
      return remoteDataSource.addPost(postModel);
    },);
  }

  @override
  Future<Either<Failure, Unit>> deletePost(int id) async{
    return await _getMessage(() async{
      return remoteDataSource.deletePost(id);
    },);
  }

  @override
  Future<Either<Failure, Unit>> updatePost(Post post) async{
    PostModel postModel = PostModel(id: post.id, title: post.title, body: post.body);
    return await _getMessage(() async{
      return  remoteDataSource.updatePost(postModel);
    },);
  }

  Future<Either<Failure, Unit>> _getMessage(DeleteOrUpdateOrAddPost deleteOrAddOrUpdatePost)async{
    if(await networkInfo.isConnected){
      try{
        await deleteOrAddOrUpdatePost();
        return const Right(unit);
      }
      on ServerException{
        return Left(ServerFailure());
      }
    }
    else{
      return Left(OfflineFailure());
    }
  }
}
