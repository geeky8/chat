import 'package:chat/constants.dart';
import 'package:chat/main.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:chat/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // static final FacebookLogin facebookSignIn = new FacebookLogin();
  bool _isLogin = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FacebookLogin _facebookLogin = FacebookLogin();
  bool showSpinner = false;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: !_isLogin
    //       ? Center(
    //           child: OutlinedButton(
    //             onPressed: () async{
    //               await _handleLogin();
    //             },
    //             child: Text(
    //               "Login with Facebook",
    //               style: TextStyle(fontSize: 20),
    //             ),
    //           ),
    //         )
    //       : Center(
    //           child: Column(
    //             children: [
    //               CircleAvatar(
    //                 radius: 80,
    //                 backgroundImage: NetworkImage(_user.photoURL),
    //               ),
    //               Text(
    //                 _user.displayName,
    //                 style: TextStyle(
    //                   fontSize: 30,
    //                 ),
    //               ),
    //               OutlinedButton(
    //                 onPressed: () async{
    //                   await _signOut();
    //                 },
    //                 child: Text(
    //                   "Logout",
    //                   style: TextStyle(fontSize: 20),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    // );
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
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
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Log In',
                colour: Colors.black,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      login = true;
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen()));
                    }

                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              SizedBox(height: 30,),
              !_isLogin
                    ? Center(
                        child: OutlinedButton(
                          onPressed: () async{
                            await _handleLogin();
                          },
                          child: Text(
                            "Login with Facebook",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      )
                    : Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen())),
            ],
          ),
        ),
      ),
    );
  }

  Future _handleLogin() async {
    FacebookLoginResult _result = await _facebookLogin.logIn(['email']);
    switch (_result.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case FacebookLoginStatus.error:
        print("Error Occurred");
        break;
      case FacebookLoginStatus.loggedIn:
        await _loginWithFacebook(_result);
        break;
    }
  }

  Future _loginWithFacebook(FacebookLoginResult _result) async {
    FacebookAccessToken _token = _result.accessToken;
    AuthCredential _credential = FacebookAuthProvider.credential(_token.token);
    var a = await _auth.signInWithCredential(_credential);
    setState(() {
      _isLogin = true;
      fblogin = true;
      user = a.user.displayName;
    });
  }

  Future _signOut() async{
    await _auth.signOut().then((value){
      setState(() {
        _facebookLogin.logOut();
        _isLogin = false;
      });
    });
  }
}
