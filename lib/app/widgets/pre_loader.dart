import 'package:flutter/material.dart';
import 'package:grocery_shop/app/theme/home_theme.dart';

class PreLoader extends StatefulWidget {
  static final ValueNotifier<bool> load = ValueNotifier<bool>(false);
  @override
  _PreLoaderState createState() => _PreLoaderState();
}

class _PreLoaderState extends State<PreLoader> {

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: PreLoader.load,
      builder: (context, value, child) => Container(
        child: SafeArea(
          child: value
              ? LinearProgressIndicator(
                  backgroundColor: AppTheme.nearlyDarkBlue,
                  valueColor: new AlwaysStoppedAnimation(AppTheme.nearlyWhite),
                )
              : Container(),
        ),
      ),
    );
  }
}
