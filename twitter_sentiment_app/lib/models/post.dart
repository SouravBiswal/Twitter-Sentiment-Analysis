import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String creator;
  final String text;
  final Timestamp timestamp;
  final String originalId;
  int likesCount;
  int retweetsCount;
  final bool retweet;
  DocumentReference ref;

  PostModel(
      {this.originalId,
      this.retweet,
      this.id,
      this.creator,
      this.text,
      this.timestamp,
      this.ref,
      this.likesCount,
      this.retweetsCount});
}
