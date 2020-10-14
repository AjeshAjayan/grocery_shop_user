import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_shop/app/models/user.dart';
import 'package:grocery_shop/app/theme/home_theme.dart';

class ProfileInputField extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  final String value;
  final Function onSave;
  final String hintText;
  final String labelText;
  final String textValue;
  final TextEditingController controller;
  final TextInputType textInputType;
  bool isEditPressed;
  ProfileInputField({
    Key key,
    this.value,
    this.animationController,
    this.animation,
    this.onSave,
    this.hintText,
    this.labelText,
    this.textValue,
    this.controller,
    this.textInputType,
    this.isEditPressed = false,
  }) : super(key: key);

  @override
  _ProfileInputFieldState createState() => _ProfileInputFieldState();
}

class _ProfileInputFieldState extends State<ProfileInputField> {

  @override
  void initState() {
    if(widget.value != '') {
      widget.controller.text = widget.textValue;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation.value), 0.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 0, bottom: 0),
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: AppTheme.grey.withOpacity(0.4),
                                offset: Offset(1.1, 1.1),
                                blurRadius: 10.0,
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: 70,
                            child: Row(
                              children: widget.textValue == '' || widget.isEditPressed
                                  ? AppTheme.buildBlueOutlinedInput(
                                      labelText: widget.labelText,
                                      hintText: widget.hintText,
                                      onIconPress: widget.onSave,
                                      controller: widget.controller,
                                      textInputType: widget.textInputType,
                                    )
                                  : buildText(
                                      text: widget.textValue,
                                      onIconPress: () {
                                        updateIsEditPressed(true);
                                      },
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void updateIsEditPressed(bool value) {
    setState(() {
      widget.isEditPressed = value;
    });
  }

  List<Widget> buildText({String text, Function onIconPress}) {
    return [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(text, style: AppTheme.nearlyDarkBlueTextStyle),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          icon: Icon(
            Icons.edit,
            size: 30,
            color: AppTheme.nearlyDarkBlue,
          ),
          onPressed: onIconPress,
        ),
      )
    ];
  }
}
