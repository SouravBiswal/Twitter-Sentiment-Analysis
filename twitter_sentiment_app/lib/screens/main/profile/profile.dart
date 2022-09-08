import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_sentiment_app/screens/main/posts/list.dart';
import 'package:twitter_sentiment_app/services/posts.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: _postService.getpostsByUser(FirebaseAuth.instance.currentUser.uid),
      child: Scaffold(body: Container(child: const Listposts())),
    );
  }
}
