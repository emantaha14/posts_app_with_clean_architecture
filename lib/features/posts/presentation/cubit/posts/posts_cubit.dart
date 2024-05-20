import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:posts_app_with_clean_architecture/core/error_handler/failures.dart';

import '../../../domain/entities/post.dart';
import '../../../domain/use_cases/get_all_posts.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  final GetAllPostsUseCase getAllPosts;
  PostsCubit({required this.getAllPosts}) : super(PostsInitial());
  void fetchPosts() async {
    emit(PostsLoading());
    final failureOrPosts = await getAllPosts.call();
    failureOrPosts.fold((failure) {
      emit(PostsError(message: _mapFailureToMessage(failure)));
    }, (posts) {
      emit(PostsLoaded(posts: posts));
    });
  }
}


String _mapFailureToMessage(Failure failure){
  switch(failure.runtimeType){
    case ServerFailure:
      return "Server Failure";
    case EmptyCacheFailure:
      return "Cache Failure";
    case OfflineFailure:
      return "offline Failure";
    default:
      return failure.toString();
  }
}