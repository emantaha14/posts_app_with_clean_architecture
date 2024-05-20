import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:posts_app_with_clean_architecture/core/error_handler/error_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/post_model.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getCachedPosts();

  Future<Unit> cachePosts(List<PostModel> postModels);
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<Unit> cachePosts(List<PostModel> postModels) {
    List postModelsToJson =
        postModels.map((postModel) => postModel.toJson()).toList();
    sharedPreferences.setString('CACHED_POSTS', json.encode(postModelsToJson));
    return Future.value(unit);
  }

  @override
  Future<List<PostModel>> getCachedPosts() {
   final jsonString = sharedPreferences.getString('CACHED_POSTS');
   if(jsonString != null){
     List decodeJsonData = json.decode(jsonString);
     List <PostModel> jsonToPostModels = decodeJsonData.map<PostModel>((jsonPostModel) => PostModel.fromJson(jsonPostModel)).toList();
     return Future.value(jsonToPostModels);
   }
   else{
     throw EmptyCacheException();
   }
  }
}
