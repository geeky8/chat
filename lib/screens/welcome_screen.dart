import 'package:chat/rounded_button.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/login_screen.dart';
import 'package:chat/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static String routeName = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  void check_loggedIn() async{
    if (await FirebaseAuth.instance.currentUser != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen()));
    }
  }

  @override
  void initState() {
    check_loggedIn();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Hero(
                tag: 'logo',
                child: Container(
                  child: Text("Chat-e",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              colour: Colors.black,
              title: 'Login',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              },
            ),
            RoundedButton(
              colour: Colors.black54,
              title: 'Registration',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationScreen()));
              },),
          ],
        ),
      ),
    );
  }
}