import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radix_freshers/common_widgets/news_tile.dart';
import 'package:radix_freshers/cubit/everything_cubit.dart';
import 'package:radix_freshers/models/everything.dart';
import 'package:radix_freshers/models/headlines.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsPage extends StatelessWidget {
  NewsPage({
    Key? key,
    required this.source,
  }) : super(key: key);
  final Sources source;
  final scrollController = ScrollController();

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          BlocProvider.of<EverythingCubit>(context).loadArticles(source.id!);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    BlocProvider.of<EverythingCubit>(context).loadArticles(source.id!);
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          centerTitle: false,
          elevation: 0.0,
          backgroundColor: Colors.indigo,
          ),
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
            color: Colors.indigo,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Hero(
                  tag: source.id!,
                  child: SizedBox(
                      height: 80.0,
                      width: 80.0,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 2.0, color: Colors.white),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: source.id == null
                                    ? AssetImage(
                                        "assets/logos/${source.id}.png")
                                    : const AssetImage(
                                        "assets/img/placeholder.jpg"),
                                fit: BoxFit.cover)),
                      )),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  source.name!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  source.description!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<EverythingCubit, EverythingState>(
              builder: (context, state) {
                if (state is EverythingLoading && state.isFirstFetch) {
                  return _loadingIndicator();
                }
                List<Articles> articles = [];
                bool isLoading = false;

                if (state is EverythingLoading) {
                  articles = state.oldArticles;
                  isLoading = true;
                } else if (state is EverythingLoaded) {
                  articles = state.articles;
                }
                return _buildSourceNewsWidget(context, articles, isLoading);
              },
            ),
          )
        ],
      ),
    );

  }

  Widget _buildSourceNewsWidget(
      BuildContext context, List<Articles> articles, bool isLoading) {
    if (articles.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Text(
              "No more news",
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 16),
        child: ListView.builder(
            controller: scrollController,
            itemCount: articles.length + (isLoading ? 1 : 0),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              if (index < articles.length) {
                return NewsTile(
                  imgUrl: articles[index].urlToImage ?? "",
                  title: articles[index].title ?? "",
                  desc: articles[index].description ?? "",
                  content: articles[index].content ?? "",
                  posturl: articles[index].url ?? "",
                  timeago: timeUntil(DateTime.parse(articles[index].publishedAt!)),
                );
              } else {
                Timer(const Duration(milliseconds: 30), () {
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent);
                });

                return _loadingIndicator();
              }
            }),
      );
    }
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
