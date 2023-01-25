import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_sentiment_app/models/post.dart';
import 'package:twitter_sentiment_app/models/user.dart';
import 'package:twitter_sentiment_app/services/user.dart';

class PostService {
  List<PostModel> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PostModel(
        id: doc.id,
        text: doc['text'] ?? '',
        creator: doc['creator'] ?? '',
        timestamp: doc["timestamp"] ?? 0,
        likesCount: doc['likesCount'] ?? 0,
        retweetsCount: doc['retweetsCount'] ?? 0,
        retweet: doc['retweet'] ?? false,
        originalId: doc['originalId'] ?? null,
        ref: doc.reference,
      );
    }).toList();
  }

  Future savePost(text) async {
    await FirebaseFirestore.instance.collection("posts").add({
      'text': text,
      'creator': FirebaseAuth.instance.currentUser.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'retweet': false
    });
  }

  PostModel _postFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot.exists
        ? PostModel(
            id: snapshot.id,
            text: snapshot.get('text') ?? '',
            creator: snapshot.get('creator') ?? '',
            timestamp: snapshot.get('timestamp') ?? 0,
            likesCount: snapshot.get('likesCount') ?? 0,
            retweetsCount: snapshot.get('retweetsCount') ?? 0,
            retweet: snapshot.get('retweet') ?? false,
            originalId: snapshot.get('originalID') ?? null,
            ref: snapshot.reference,
          )
        : null;
  }

  Future reply(PostModel post, String text) async {
    if (text == '') {
      return;
    }
    await post.ref.collection("replies").add({
      'text': text,
      'creator': FirebaseAuth.instance.currentUser.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'retweet': false
    });
  }

  Future likePost(PostModel post, bool current) async {
    print(post.id);
    if (current) {
      post.likesCount = post.likesCount - 1;
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection("likes")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .delete();
    }
    if (!current) {
      post.likesCount = post.likesCount + 1;
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection("likes")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set({});
    }
  }

  Future<PostModel> getPostById(String id) async {
    DocumentSnapshot postSnap =
        await FirebaseFirestore.instance.collection("posts").doc(id).get();

    return _postFromSnapshot(postSnap);
  }

  Stream<List<PostModel>> getpostsByUser(uid) {
    return FirebaseFirestore.instance
        .collection("posts")
        .where('creator', isEqualTo: uid)
        .snapshots()
        .map(_postListFromSnapshot);
  }

  Future<List<PostModel>> getFeed() async {
    List<String> usersFollowing = await UserService()
        .getUserFollowing(FirebaseAuth.instance.currentUser.uid);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('creator', whereIn: usersFollowing)
        .orderBy('timestamp', descending: true)
        .get();

    return _postListFromSnapshot(querySnapshot);
  }

  Future retweet(PostModel post, bool current) async {
    if (current) {
      post.retweetsCount = post.retweetsCount - 1;
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection("retweets")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .delete();

      await FirebaseFirestore.instance
          .collection("posts")
          .where("originalId", isEqualTo: post.id)
          .where("creator", isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((value) {
        if (value.docs.length == 0) {
          return;
        }
        FirebaseFirestore.instance
            .collection("posts")
            .doc(value.docs[0].id)
            .delete();
      });
      // Todo remove the retweet
      return;
    }
    post.retweetsCount = post.retweetsCount + 1;
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("retweets")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({});

    await FirebaseFirestore.instance.collection("posts").add({
      'creator': FirebaseAuth.instance.currentUser.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'retweet': true,
      'originalId': post.id
    });
  }

  Stream<bool> getCurrentUserLike(PostModel post) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("likes")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.exists;
    });
  }

  Stream<bool> getCurrentUserRetweet(PostModel post) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("retweets")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.exists;
    });
  }

  Future<List<PostModel>> getReplies(PostModel post) async {
    QuerySnapshot querySnapshot = await post.ref
        .collection("replies")
        .orderBy('timestamp', descending: true)
        .get();

    return _postListFromSnapshot(querySnapshot);
  }
}
