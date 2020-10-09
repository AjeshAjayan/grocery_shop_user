import 'package:flutter/material.dart';
import 'package:grocery_manager/app/app_home_screen.dart';
import 'package:grocery_manager/app_theme.dart';
import 'package:grocery_manager/registration.dart';

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
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 30),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: TextFormField(
                        cursorColor: primaryColor,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0x50FEFEFE),
                          suffixIcon: Icon(
                            Icons.person,
                            color: primaryColor,
                          ),
                          border: const OutlineInputBorder(),
                          labelText: "Username",
                          labelStyle: TextStyle(color: primaryColor),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: TextFormField(
                        obscureText: true,
                        cursorColor: primaryColor,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0x50FFFFFF),
                          suffixIcon: Icon(
                            Icons.lock,
                            color: primaryColor,
                          ),
                          border: OutlineInputBorder(),
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: primaryColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 30),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Row(
                        children: [
                          Expanded(
                            child: RaisedButton(
                              color: primaryColor,
                              child: Container(
                                height: 50,
                                child: Center(
                                  child: Text(
                                    "Log in",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                // TODO: Authenticate
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Divider(
                      color: primaryColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 5,
                    ),
                    child: RaisedButton(
                      onPressed: () {
                        // TODO: Login with google
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
                                    "assets/images/google_icon_logo.jpg",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not a user. ',
                            style: TextStyle(color: primaryColor),
                          ),
                          InkWell(
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                color: primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () {
                              // TODO: navigate to registration
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Registration(),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
