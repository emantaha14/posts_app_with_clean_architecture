import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:posts_app_with_clean_architecture/features/posts/domain/use_cases/add_post.dart';

import '../../../../../core/error_handler/failures.dart';
import '../../../domain/entities/post.dart';
import '../../../domain/use_cases/delete_post.dart';
import '../../../domain/use_cases/update_post.dart';

part 'add_update_delete_posts_state.dart';

class AddUpdateDeletePostsCubit extends Cubit<AddUpdateDeletePostsState> {
  final AddPostUseCase addPostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final UpdatePostUseCase updatePostUseCase;

  AddUpdateDeletePostsCubit(
      {required this.addPostUseCase,
      required this.deletePostUseCase,
      required this.updatePostUseCase})
      : super(AddUpdateDeletePostsInitial());

  void addPost(Post post) async{
    emit(AddUpdateDeletePostsLoading());
     await addPostUseCase.call(post).then((post) {
       emit(_eitherDoneMessageOrErrorState(post, "added successfully"));
     });
  }
  void updatePost(Post post) async{
    emit(AddUpdateDeletePostsLoading());
    await updatePostUseCase.call(post).then((post) {
      emit(_eitherDoneMessageOrErrorState(post, "updated successfully"));
    });

  } void deletePost(int postId) async{
    emit(AddUpdateDeletePostsLoading());
    await deletePostUseCase.call(postId).then((post) {
      emit(_eitherDoneMessageOrErrorState(post, "deleted successfully"));
    });
  }
}

AddUpdateDeletePostsState _eitherDoneMessageOrErrorState(Either<Failure, Unit> either, String message){
    return either.fold((failure){
      return AddUpdateDeletePostsError(message: _mapFailureToMessage(failure));
    }, (unit) {
      return AddUpdateDeletePostsSuccessState(message: message);
    });
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