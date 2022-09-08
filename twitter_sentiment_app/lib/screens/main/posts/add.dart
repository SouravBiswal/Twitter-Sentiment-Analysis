import 'package:flutter/material.dart ';
import 'package:twitter_sentiment_app/services/posts.dart';

class addPost extends StatefulWidget {
  const addPost({Key key}) : super(key: key);

  @override
  State<addPost> createState() => _addPostState();
}

class _addPostState extends State<addPost> {
  String text = '';
  final PostService _postService = PostService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add tweet'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                _postService.savePost(text);
                Navigator.pop(context);
              },
              child: Text('Tweet'),
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 10,
            ),
            child: Form(child: TextFormField(
              onChanged: (value) {
                setState(() {
                  text = value;
                });
              },
            ))));
  }
}
