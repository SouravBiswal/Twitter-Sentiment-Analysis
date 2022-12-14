import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_sentiment_app/auth/signup.dart';
import 'package:twitter_sentiment_app/models/user.dart';
import 'package:twitter_sentiment_app/screens/wrapper.dart';
import 'package:twitter_sentiment_app/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          //return SomethingWentWrong();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          StreamProvider<UserModel>.value(
            value: AuthService().user,
            initialData: UserModel(id: '0'),
            child: const MaterialApp(
              home: Wrapper(),
            ),
          );
        }

        return const Text("Loading");
      },
    );
  }
}
