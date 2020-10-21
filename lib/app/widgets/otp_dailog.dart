import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocery_shop/app/theme/home_theme.dart';

class OtpDialog extends StatefulWidget {
  final int otpTimeOut;
  final Function callback;
  Duration countDown;
  OtpDialog(this.otpTimeOut, this.callback) {
    this.countDown = new Duration(minutes: this.otpTimeOut);
  }

  @override
  _OtpDialogState createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  Timer timer;
  final subDuration = new Duration(seconds: 1);

  @override
  void initState() {
    this.timer = new Timer.periodic(
      Duration(seconds: 1),
      (Timer t) {
        setState(() {
          widget.countDown = widget.countDown - subDuration;
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: FractionallySizedBox(
        widthFactor: 0.8,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Enter OTP',
                      style: AppTheme.nearlyDarkBlueTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.countDown.inMinutes.toString() +
                          ' : ' +
                          widget.countDown.inSeconds.toString(),
                      style: AppTheme.nearlyDarkBlueTextStyle,
                    ),
                  ),
                ],
              ),
              TextFormField(
                style: TextStyle(
                  color: AppTheme.nearlyDarkBlue,
                  fontSize: 30,
                ),
                keyboardType: TextInputType.number,
                cursorColor: AppTheme.nearlyDarkBlue,
                decoration: InputDecoration(
                  hintText: '000000',
                  hintStyle: TextStyle(color: AppTheme.nearlyLiteDarkBlue),
                  border: OutlineInputBorder(),
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
                onChanged: (value) {
                  if(value.length == 6) {
                    widget.callback(value);
                    Timer(Duration(milliseconds: 300), () {
                      Navigator.of(context).pop();
                    });
                  }
                },
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: Text(
                      'Resend OTP',
                      style: AppTheme.nearlyDarkBlueTextStyle,
                    ),
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
