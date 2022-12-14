import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_sentiment_app/services/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  String email = "", password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 8,
        title: const Text("Sign Up"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
            child: Column(
          children: [
            TextFormField(
                onChanged: ((value) => setState(() {
                      email = value;
                    }))),
            TextFormField(
              onChanged: ((value) => setState(() {
                    password = value;
                  })),
            ),
            ElevatedButton(
                child: const Text('Sign Up'),
                onPressed: () async => {_authService.signUp(email, password)}),
            ElevatedButton(
                child: const Text('Sign In'),
                onPressed: () async => {_authService.signIn(email, password)})
          ],
        )),
      ),
    );
  }
}
