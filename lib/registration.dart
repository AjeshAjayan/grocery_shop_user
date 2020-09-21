import 'package:flutter/material.dart';
import 'package:grocery_manager/app_theme.dart';

class Registration extends StatelessWidget {
  final Color primaryColor = new Color(0xFF0024c3);
  final Color white = Colors.white;
  final double primaryWidth = 0.8;
  final double primaryVerticalPadding = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Builder(
        builder: (BuildContext context) => SafeArea(
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/login_bg.jpg"),
                    fit: BoxFit.cover),
              ),
              child: FractionallySizedBox(
                widthFactor: primaryWidth,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: SizedBox(),
                    ),
                    textFormField(
                      primaryColor: primaryColor,
                      labelText: "First Name",
                      icon: Icons.perm_identity,
                    ),
                    textFormField(
                      primaryColor: primaryColor,
                      labelText: "Last Name",
                      icon: Icons.person,
                    ),
                    textFormField(
                      primaryColor: primaryColor,
                      labelText: "Shop Name",
                      icon: Icons.store,
                    ),
                    textFormField(
                      primaryColor: primaryColor,
                      labelText: "Mobile",
                      icon: Icons.phone,
                    ),
                    button(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textFormField({
    primaryColor: Color,
    labelText: String,
    icon: Icon,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: primaryVerticalPadding),
      child: TextFormField(
        cursorColor: primaryColor,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          fillColor: Color(0x50FFFFFF),
          suffixIcon: Icon(
            icon,
            color: primaryColor,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            color: primaryColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
      ),
    );
  }

  Widget button() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 50),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: primaryVerticalPadding),
              child: Expanded(
                child: RaisedButton(
                  color: primaryColor,
                  child: Container(
                    color: primaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sign in with",
                          style: TextStyle(color: white),
                        ),
                        Image(
                          height: 30,
                          image:
                              AssetImage("assets/images/google_icon_logo.jpg"),
                        )
                      ],
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
