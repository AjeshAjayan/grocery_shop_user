import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

class AppTheme {
  AppTheme._();
  static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F3F8);
  static const Color nearlyDarkBlue = Color(0xFF2633C5);
  static const Color nearlyLiteDarkBlue = Color(0x702633C5);

  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'Roboto';

  static const Color errorText = Colors.redAccent;

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle nearlyDarkBlueTextStyle = TextStyle(
    color: AppTheme.nearlyDarkBlue,
    fontSize: 16,
    fontFamily: fontName,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    height: 0.9,
  );

  static const TextStyle display1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );

  static List<Widget> buildBlueOutlinedInput(
      {String labelText,
      TextEditingController controller,
      Function onIconPress,
      String hintText,
      TextInputType textInputType}) {
    return [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            style: TextStyle(
              color: AppTheme.nearlyDarkBlue,
            ),
            keyboardType: textInputType,
            controller: controller,
            cursorColor: AppTheme.nearlyDarkBlue,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: AppTheme.nearlyLiteDarkBlue),
              border: OutlineInputBorder(),
              labelText: labelText,
              labelStyle: TextStyle(
                color: AppTheme.nearlyDarkBlue,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppTheme.nearlyDarkBlue,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppTheme.nearlyDarkBlue,
                ),
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          icon: Icon(
            Icons.save_alt,
            size: 30,
            color: AppTheme.nearlyDarkBlue,
          ),
          onPressed: onIconPress,
        ),
      )
    ];
  }

  static void buildSnackBar(BuildContext context, String msg) {
    Flushbar(
      maxWidth: MediaQuery.of(context).size.width - 30,
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 5),
      borderColor: AppTheme.nearlyDarkBlue,
      backgroundColor: AppTheme.white,
      messageText: Text(
        msg,
        style: TextStyle(
          color: AppTheme.nearlyDarkBlue,
          fontSize: 17,
        ),
      ),
      borderRadius: 50,
      boxShadows: [
        BoxShadow(
          color: AppTheme.nearlyDarkBlue,
          blurRadius: 2,
          spreadRadius: 4
        )
      ],
    )..show(context);
  }

  static void buildSnackBarError(BuildContext context, String msg) {
    Flushbar(
      maxWidth: MediaQuery.of(context).size.width - 30,
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 5),
      borderColor: AppTheme.errorText,
      backgroundColor: AppTheme.white,
      messageText: Text(
        msg,
        style: TextStyle(
          color: AppTheme.errorText,
          fontSize: 17,
        ),
      ),
      borderRadius: 50,
      boxShadows: [
        BoxShadow(
            color: AppTheme.errorText,
            blurRadius: 2,
            spreadRadius: 4
        )
      ],
    )..show(context);
  }
}
