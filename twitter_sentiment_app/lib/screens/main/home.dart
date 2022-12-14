import 'package:flutter/material.dart';
import 'package:twitter_sentiment_app/services/auth.dart';

class Home extends StatelessWidget {
  const Home({key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              authService.signOut();
            },
            icon: const Icon(Icons.logout_outlined),
            label: const Text('SignOut'),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Drawer Header'),
            ),
            ListTile(
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                }),
            ListTile(
                title: const Text('Logout'),
                onTap: () async {
                  authService.signOut();
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
      ),
    );
  }
}
