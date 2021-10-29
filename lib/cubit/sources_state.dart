part of 'sources_cubit.dart';

@immutable
abstract class SourcesState {}

class SourcesInitial extends SourcesState {}

class SourcesGet extends SourcesState{
  final Headlines headlines;
  SourcesGet({required this.headlines});
}

class SourcesLoading extends SourcesState{
  final List<Sources> sources;
  SourcesLoading({required this.sources});
}
