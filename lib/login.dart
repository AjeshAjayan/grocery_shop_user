import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_shop/app/app_home_screen.dart';
import 'package:grocery_shop/app_theme.dart';

class AuthSocialIcons {
  static final google = 'google_icon_logo.jpg';
  static final fb = 'fb_icon.png';
  static final microsoft = 'ms_icon.png';
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Color primaryColor = new Color(0xFF0024c3);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: FractionallySizedBox(
              heightFactor: 1,
              child: Container(
                padding: EdgeInsets.only(bottom: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buildButtonWithIcon(
                      AuthSocialIcons.google,
                      () async {
                        try {
                          UserCredential credential = await _signInWithGoogle();
                          redirectToHomeScreen(context);
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (_) =>
                                _buildAlertDialog('Something went wrong'),
                          );
                        }
                      },
                    ),
                    buildDivider(),
                    buildButtonWithIcon(
                      AuthSocialIcons.fb,
                      () async {
                        UserCredential credential = await _signInWithFacebook();
                        redirectToHomeScreen(context);
                      },
                    ),
                    buildDivider(),
                    buildButtonWithIcon(
                      AuthSocialIcons.microsoft,
                      () {
                        showDialog(
                          context: context,
                          builder: (_) => _buildAlertDialog('In progress'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertDialog(String errorText) {
    return AlertDialog(
      backgroundColor: AppTheme.nearlyWhite,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.error,
              color: Colors.redAccent,
              size: 50,
            ),
          ],
        ),
      ),
      content: FractionallySizedBox(
        heightFactor: .1,
        child: Center(
          child: Text(
            errorText,
            style: AppTheme.body1,
          ),
        ),
      ),
    );
  }

  Widget buildDivider() {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Divider(
        color: primaryColor,
      ),
    );
  }

  Widget buildButtonWithIcon(String image, Function callback) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      child: RaisedButton(
        onPressed: () {
          callback();
        },
        color: primaryColor,
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login with',
                  style: TextStyle(color: Colors.white),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 3,
                    bottom: 10,
                  ),
                  child: Image(
                    image: AssetImage(
                      "assets/images/$image",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> _signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult result = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final FacebookAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
  }

  void redirectToHomeScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AppHomeScreen()),
    );
  }
}
