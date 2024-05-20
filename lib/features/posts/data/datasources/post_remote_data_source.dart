import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:posts_app_with_clean_architecture/core/error_handler/error_exception.dart';

import '../models/post_model.dart';
import 'package:http/http.dart' as http;

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getAllPosts();

  Future<Unit> updatePost(PostModel postModel);

  Future<Unit> deletePost(int postId);

  Future<Unit> addPost(PostModel postModel);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  http.Client client;

  PostRemoteDataSourceImpl(this.client);

  final baseUrl = 'https://jsonplaceholder.typicode.com/';

  @override
  Future<List<PostModel>> getAllPosts() async {
    final response = await http.get(Uri.parse('${baseUrl}posts/'),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      final List decodedJson = jsonDecode(response.body) as List;
      final List<PostModel> postModels = decodedJson
          .map((jsonPostModel) => PostModel.fromJson(jsonPostModel))
          .toList();
      return postModels;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> addPost(PostModel postModel) async {
    final body = {'title': postModel.title, 'body': postModel.body};
    final response =
        await client.post(Uri.parse('${baseUrl}posts/'), body: body);
    if (response.statusCode == 201) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deletePost(int postId) async {
    final response =
        await client.delete(Uri.parse('${baseUrl}posts/${postId.toString()}'));
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> updatePost(PostModel postModel) async {
    final postId = postModel.id.toString();
    final body = {'title': postModel.title, 'body': postModel.body};
    final response =
        await client.patch(Uri.parse('${baseUrl}posts/$postId'), body: body);
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }
}
