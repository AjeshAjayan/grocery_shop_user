import 'package:flutter/material.dart';
import 'package:grocery_manager/app/app_home_screen.dart';
import 'package:grocery_manager/app_theme.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bermuda-welcome.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 30),
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: TextFormField(
                      cursorColor: Colors.green,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0x50FEFEFE),
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.green,
                        ),
                        border: const OutlineInputBorder(),
                        labelText: "Username",
                        labelStyle: TextStyle(color: Colors.green),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
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
                      cursorColor: Colors.green,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0x50FFFFFF),
                        suffixIcon: Icon(
                          Icons.lock,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(),
                        labelText: "Password",
                        labelStyle: TextStyle(
                          color: Colors.green,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
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
                            color: Colors.green,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AppHomeScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
