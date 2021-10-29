import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:radix_freshers/models/everything.dart';
import 'package:radix_freshers/models/headlines.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: 'https://newsapi.org/v2')
abstract class ApiService {
  factory ApiService(Dio dio, String? baseUrl) {
    dio.options =
        BaseOptions(receiveTimeout: 30000, connectTimeout: 30000, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    });
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    return _ApiService(dio, baseUrl: baseUrl);
  }

  @GET('/everything')
  Future<Everything> fetchEverything(
      @Query("q") String q,
      @Query("apiKey") String apiKey,
      @Query("pageSize") int pageSize,
      @Query("page") int page);

  @GET('/top-headlines/sources')
  Future<Headlines> fetchHeadlines(@Query("apiKey") String apiKey);
}
