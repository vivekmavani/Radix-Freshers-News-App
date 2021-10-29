import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:radix_freshers/app/api_service/api_service.dart';
import 'package:radix_freshers/models/headlines.dart';
import 'package:dio/dio.dart' as dio;

part 'sources_state.dart';

class SourcesCubit extends Cubit<SourcesState> {
  SourcesCubit() : super(SourcesInitial());

  fetchSources() {
      ApiService(dio.Dio(), "https://newsapi.org/v2")
          .fetchHeadlines("699a323275084d0d8946fd406ec69e8b")
          .then((responsesApi) {
        if (responsesApi.status == "ok") {
          emit(SourcesLoading(sources: responsesApi.sources!));
        } else {
          print("problem");
         // emit(SourcesGet(headlines: responsesApi));
        }
      });
  }
}
