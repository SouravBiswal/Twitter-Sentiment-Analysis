import 'package:flutter/material.dart';
import 'package:twitter_sentiment_app/services/auth.dart';

class Home extends StatelessWidget {
  const Home({key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: <Widget>[
          TextButton.icon(
            onPressed: _authService.signOut(),
            icon: const Icon(Icons.logout_outlined),
            label: const Text('SignOut'),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/add');
          }),
    );
  }
}
