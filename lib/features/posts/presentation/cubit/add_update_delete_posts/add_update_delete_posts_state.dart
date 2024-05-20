part of 'add_update_delete_posts_cubit.dart';

@immutable
abstract class AddUpdateDeletePostsState {}

class AddUpdateDeletePostsInitial extends AddUpdateDeletePostsState {}
class AddUpdateDeletePostsLoading extends AddUpdateDeletePostsState {}
class AddUpdateDeletePostsError extends AddUpdateDeletePostsState {
  final String message;
  AddUpdateDeletePostsError({required this.message});
}
class AddUpdateDeletePostsSuccessState extends AddUpdateDeletePostsState{
  final String message;
  AddUpdateDeletePostsSuccessState({required this.message});
}