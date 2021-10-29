part of 'everything_cubit.dart';

@immutable
abstract class EverythingState {}

class EverythingInitial extends EverythingState {}

class EverythingLoaded extends EverythingState{
  final List<Articles> articles;
  EverythingLoaded(this.articles);
}

/*class EverythingLoading extends EverythingState{
  final Everything everything;
  EverythingLoading({required this.everything});
}*/
class EverythingLoading extends EverythingState {
  final List<Articles> oldArticles;
  final bool isFirstFetch;
  EverythingLoading(this.oldArticles, {this.isFirstFetch=false});
}

class EverythingError extends EverythingState{
  final Errors errors;
  EverythingError({required this.errors});
}