import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:posts_app_with_clean_architecture/core/network/network_info.dart';
import 'package:posts_app_with_clean_architecture/features/posts/data/repositories/post_repository_imp.dart';
import 'package:posts_app_with_clean_architecture/features/posts/domain/repositories/post_repo.dart';
import 'package:posts_app_with_clean_architecture/features/posts/domain/use_cases/get_all_posts.dart';
import 'package:posts_app_with_clean_architecture/features/posts/domain/use_cases/update_post.dart';
import 'package:posts_app_with_clean_architecture/features/posts/presentation/cubit/add_update_delete_posts/add_update_delete_posts_cubit.dart';
import 'package:posts_app_with_clean_architecture/features/posts/presentation/cubit/posts/posts_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/posts/data/datasources/post_local_data_source.dart';
import 'features/posts/data/datasources/post_remote_data_source.dart';
import 'features/posts/domain/use_cases/add_post.dart';
import 'features/posts/domain/use_cases/delete_post.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! features posts
  // bloc

  sl.registerFactory(() => PostsCubit(getAllPosts: sl()));
  sl.registerFactory(() => AddUpdateDeletePostsCubit(
      addPostUseCase: sl(), deletePostUseCase: sl(), updatePostUseCase: sl()));
  // usecase
  sl.registerLazySingleton(() => GetAllPostsUseCase(postsRepo: sl()));
  sl.registerLazySingleton(() => AddPostUseCase(postsRepo: sl()));
  sl.registerLazySingleton(() => DeletePostUseCase(postsRepo: sl()));
  sl.registerLazySingleton(() => UpdatePostUseCase(postsRepo: sl()));

  // repositories
  sl.registerLazySingleton<PostsRepo>(() => PostsRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));
  // datasources
  sl.registerLazySingleton<PostRemoteDataSource>(() => PostRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<PostLocalDataSource>(() => PostLocalDataSourceImpl(sl()));
  // core
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  // external
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
