//@dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_sentiment_app/models/user.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(id: user.uid) : null;
  }

  Stream<UserModel> get user {
    // ignore: unnecessary_null_comparison
    return auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signUp(email, password) async {
    try {
      User user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password)) as User;
      _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future signIn(email, password) async {
    try {
      User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password)) as User;
      _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
