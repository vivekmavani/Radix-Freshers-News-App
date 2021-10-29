import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radix_freshers/app/landingpage.dart';
import 'package:radix_freshers/services/auth.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) =>Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Radix Freshers',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(),
        // home: HomePageFirestore(),
      ),
    );
  }
}
