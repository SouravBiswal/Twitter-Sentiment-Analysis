import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_sentiment_app/models/post.dart';
import 'package:twitter_sentiment_app/models/user.dart';
import 'package:twitter_sentiment_app/screens/main/posts/Item.dart';
import 'package:twitter_sentiment_app/services/user.dart';
import 'package:twitter_sentiment_app/services/posts.dart';

import '../../../models/user.dart';

class Listposts extends StatefulWidget {
  PostModel post;
  Listposts(this.post, {Key key}) : super(key: key);

  @override
  State<Listposts> createState() => _ListpostsState();
}

class _ListpostsState extends State<Listposts> {
  UserService _userService = UserService();
  PostService _postService = PostService();
  @override
  Widget build(BuildContext context) {
    List<PostModel> posts = Provider.of<List<PostModel>>(context) ?? [];
    if (widget.post != null) {
      posts.insert(0, widget.post);
    }
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        if (post.retweet) {
          return FutureBuilder(
              future: _postService.getPostById(post.originalId),
              builder: (BuildContext context,
                  AsyncSnapshot<PostModel> snapshotPost) {
                if (!snapshotPost.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return mainPost(snapshotPost.data, true);
              });
        }
        return mainPost(post, false);
      },
    );
  }

  StreamBuilder<UserModel> mainPost(PostModel post, bool retweet) {
    return StreamBuilder(
        stream: _userService.getUserInfo(post.creator),
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshotUser) {
          if (!snapshotUser.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          //stream builder to get user like
          return StreamBuilder(
              stream: _postService.getCurrentUserLike(post),
              builder:
                  (BuildContext context, AsyncSnapshot<bool> snapshotLike) {
                if (!snapshotLike.hasData) {
                  return Center(child: CircularProgressIndicator());
                } //stream builder to get user like

                return StreamBuilder(
                    stream: _postService.getCurrentUserRetweet(post),
                    builder: (BuildContext context,
                        AsyncSnapshot<bool> snapshotRetweet) {
                      if (!snapshotLike.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return ItemPost(post, snapshotUser, snapshotLike,
                          snapshotRetweet, retweet);
                    });
              });
        });
  }
}
