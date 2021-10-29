import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radix_freshers/app/home/news_page.dart';
import 'package:radix_freshers/cubit/everything_cubit.dart';
import 'package:provider/provider.dart';
import 'package:radix_freshers/common_widgets/show_alert_dialog.dart';
import 'package:radix_freshers/cubit/sources_cubit.dart';
import 'package:radix_freshers/models/headlines.dart';
import 'package:radix_freshers/services/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        defalutActionText: 'Logout',
        content: 'Are you sure that you want to logout?',
        title: 'Logout',
        cancleActiontext: 'Cancel');
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SourcesCubit>(context).fetchSources();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radix Freshers'),
        actions: [
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _listWidget(context),
    );
  }

  Widget _listWidget(context) {
    return BlocBuilder<SourcesCubit, SourcesState>(
      builder: (context, state) {
        if (state is! SourcesLoading) {
          return const Center(child:  CircularProgressIndicator());
        } else {
          final sources = (state).sources;
          return _buildListView(context, sources);
        }
      },
    );
  }

  Widget _buildListView(BuildContext context, List<Sources> sources) =>
      GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: sources.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(top: 10.0, right: 0.0),
            width: 80.0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        fullscreenDialog: false,
                        builder: (context) =>
                            BlocProvider(
                              create: (context) => EverythingCubit(),
                              child: NewsPage(
                                source: sources[index],
                              ),
                            )));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: sources[index].id!,
                    child: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                              offset: Offset(
                                1.0,
                                1.0,
                              ),
                            )
                          ],
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:sources[index].id == null ? AssetImage(
                                  "assets/logos/${sources[index].id}.png")
                                  : const AssetImage("assets/img/placeholder.jpg"),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    sources[index].name!,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        height: 1.4,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0),
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                  Text(
                    sources[index].category!,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        height: 1.4,
                        color: Color(0xFF061857),
                        fontWeight: FontWeight.bold,
                        fontSize: 9.0),
                  ),
                ],
              ),
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (3),
            crossAxisSpacing: (1),
            mainAxisSpacing: 4.0,
            childAspectRatio: (1) / (1.2)
        ),
      );
}
