import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:radix_freshers/app/api_service/api_service.dart';
import 'package:radix_freshers/models/error.dart';
import 'package:radix_freshers/models/everything.dart';
import 'package:dio/dio.dart' as dio;

part 'everything_state.dart';

class EverythingCubit extends Cubit<EverythingState> {
  EverythingCubit() : super(EverythingInitial());
  static const FETCH_LIMIT = 15;
  int page = 1;
  fetchArticles(String id) {
    ApiService(dio.Dio(), "https://newsapi.org/v2")
        .fetchEverything(id,"699a323275084d0d8946fd406ec69e8b",FETCH_LIMIT,page)
        .then((responsesApi) {
      if (responsesApi.status == "ok") {
        page++;

        final articles = (state as EverythingLoading).oldArticles;
        articles.addAll(responsesApi.articles!);

        emit(EverythingLoaded(articles));
      }else
        {
          print("problem");
        }
    /*  if (responsesApi.status == "ok") {
        return responsesApi.articles!;
      //  emit(EverythingLoaded(responsesApi.articles!));
      } else {
        print("problem");
        return [];
         //emit(EverythingError(errors: ));
      }*/
    });
  }

  void loadArticles(String id) {
    if (state is EverythingLoading) return;

    final currentState = state;

    var oldArticles = <Articles>[];
    if (currentState is EverythingLoaded) {
      oldArticles = currentState.articles;
    }

    emit(EverythingLoading(oldArticles, isFirstFetch: page == 1));
    fetchArticles(id);
   /* fetchArticles(id,page).then((newArticles) {
      page++;

      final articles = (state as EverythingLoading).oldArticles;
      articles.addAll(newArticles);

      emit(EverythingLoaded(articles));
    });*/
  }
}
