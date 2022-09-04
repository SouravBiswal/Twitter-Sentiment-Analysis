import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_sentiment_app/auth/signup.dart';
import 'package:twitter_sentiment_app/models/user.dart';
import 'package:twitter_sentiment_app/screens/main/home.dart';
import 'package:twitter_sentiment_app/screens/main/posts/add.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    if (user == null) {
      return const SignUp();
    }
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/add': ((context) => const addPost())
      },
    );
  }
}
