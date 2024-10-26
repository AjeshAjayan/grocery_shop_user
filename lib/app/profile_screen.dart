import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_shop/app/app_config.dart';
import 'package:grocery_shop/app/widgets/otp_dailog.dart';
import 'package:grocery_shop/app/widgets/pre_loader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocery_shop/app/models/user.dart';
import 'package:grocery_shop/app/theme/home_theme.dart';
import 'package:grocery_shop/app/widgets/location_view.dart';
import 'package:grocery_shop/app/widgets/profile_input_flield.dart';
import 'package:grocery_shop/app/widgets/running_view.dart';
import 'package:grocery_shop/app/widgets/title_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key, this.animationController}) : super(key: key);
  final AnimationController animationController;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final TextEditingController shopNameController = new TextEditingController();
  final TextEditingController phoneNumberController =
      new TextEditingController();
  final TextEditingController addressOneController =
      new TextEditingController();
  final TextEditingController addressTwoController =
      new TextEditingController();
  final TextEditingController landmarkController = new TextEditingController();
  bool shopNameIsEditPressed = false;
  bool phNoIsEditPressed = false;
  String verificationId;
  int resendToken;
  int otpTimeOut = 2;

  CollectionReference shopUsers =
      FirebaseFirestore.instance.collection('shop_users');
  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('shop_users').doc(authUser.uid);

  Animation<double> topBarAnimation;
  double topBarOpacity = 0.0;
  final ScrollController scrollController = ScrollController();
  List<Widget> listViews = <Widget>[];

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void manualyVerifyOtp(String otp) async {
    PreLoader.load.value = true;
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    FirebaseAuth.instance.currentUser
        .linkWithCredential(phoneAuthCredential)
        .then((value) async {
      DocumentSnapshot user = await this.userDoc.get();
      if (user.data()['phone_number'] == null) {
        this
            .shopUsers
            .doc(authUser.uid.toString())
            .set({
              'phone_number': this.phoneNumberController.text,
            })
            .then((value) => updateIsEditPressed(false))
            .catchError((e) {
              AppTheme.buildSnackBarError(context, 'Something went wrong');
              updateIsEditPressed(false);
            });
      } else {
        this.shopUsers.doc(authUser.uid).update({
          'phone_number': this.phoneNumberController.text,
        }).then((value) {
          updateIsEditPressed(false);
        }).catchError((e) {
          AppTheme.buildSnackBarError(context, 'Something went wrong');
        });
      }
      PreLoader.load.value = false;
    }).catchError((e) {
      if (e.code == 'invalid-verification-code') {
        PreLoader.load.value = false;
        AppTheme.buildSnackBarError(context, 'OTP mismatch');
      } else {
        PreLoader.load.value = false;
        AppTheme.buildSnackBarError(context, 'Something went wrong');
      }
    });
  }

  void buildOptInputUi() {
    showDialog(
      context: context,
      builder: (con) {
        return OtpDialog(otpTimeOut, manualyVerifyOtp);
      },
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Future<void> handleVerification(snapshot) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91' + this.phoneNumberController.text,
      timeout: Duration(minutes: otpTimeOut),
      verificationCompleted: (PhoneAuthCredential credential) {
        // close otp dialog
        Navigator.of(context).pop();

        FirebaseAuth.instance
            .currentUser
            .linkWithCredential(credential)
            .then((value) async {
          // if verified save phone number
          saveOrUpdateShopUserDetails(
            snapshot,
            'phone_number',
            this.phoneNumberController,
          );
          updateIsEditPressed(false);
          PreLoader.load.value = false;
          AppTheme.buildSnackBarError(context, 'Phone number verification successful');
        }).catchError((e) {
          if (e.code == 'invalid-verification-code') {
            PreLoader.load.value = false;
            AppTheme.buildSnackBarError(context, 'OTP mismatch');
          } else {
            PreLoader.load.value = false;
            AppTheme.buildSnackBarError(context, 'Something went wrong');
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          AppTheme.buildSnackBarError(
            context,
            'The provided phone number is not valid.',
          );
        } else {
          AppTheme.buildSnackBarError(
            context,
            'Something went wrong.',
          );
        }
      },
      codeSent: (String verificationId, int resendToken) {
        // stop pre-loader
        PreLoader.load.value = false;

        this.verificationId = verificationId;
        this.resendToken = resendToken;

        buildOptInputUi();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        AppTheme.buildSnackBarError(
          context,
          'Timeout..!',
        );
      },
    );
  }

  void addAllListData() {
    const int count = 5;

    listViews.add(Container(
      child: Center(
        child: CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(authUser.photoURL),
          backgroundColor: AppTheme.nearlyWhite,
        ),
      ),
    ));
    listViews.add(
      RunningView(
        username: authUser.displayName,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      StreamBuilder<DocumentSnapshot>(
        stream: this.userDoc.snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<DocumentSnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            buildError();
          }
          if (snapshot.connectionState == ConnectionState.none) {
            buildError();
          }
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            return ProfileInputField(
              isEditPressed: this.shopNameIsEditPressed,
              value: authUser.displayName,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 3, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
              labelText: 'Shop name',
              hintText: 'Please enter your shop name',
              textValue: snapshot.data.data() == null ||
                      snapshot.data.data()['shop_name'] == ''
                  ? ''
                  : snapshot.data.data()['shop_name'],
              controller: shopNameController,
              textInputType: TextInputType.name,
              onSave: () {
                PreLoader.load.value = true;
                saveOrUpdateShopUserDetails(
                  snapshot,
                  'shop_name',
                  this.shopNameController,
                );
                PreLoader.load.value = false;
              },
            );
          }

          return Container();
        },
      ),
    );

    listViews.add(
      StreamBuilder<DocumentSnapshot>(
        stream: this.userDoc.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            buildError();
          }
          if (snapshot.connectionState == ConnectionState.none) {
            buildError();
          }
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            return ProfileInputField(
              value: authUser.displayName,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 3, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
              labelText: 'Phone number',
              hintText: 'Please enter your phone number',
              textValue: snapshot.data.data() == null ||
                      snapshot.data.data()['phone_number'] == null
                  ? ''
                  : snapshot.data.data()['phone_number'],
              controller: phoneNumberController,
              textInputType: TextInputType.phone,
              onSave: () async {
                PreLoader.load.value = true;
                final phNoDuplicationRes = await http.post(AppConfig.apiBaseUrl,
                    body: {'phoneNumber': this.phoneNumberController.text});
                dynamic res = json.decode(phNoDuplicationRes.body);
                if (!res["isExist"]) {
                  await handleVerification(snapshot);
                } else {
                  AppTheme.buildSnackBar(
                    context,
                    'This phone number already associated with an account',
                  );
                }
                PreLoader.load.value = false;
              },
            );
          }
          return Container();
        },
      ),
    );

    listViews.add(
      StreamBuilder<DocumentSnapshot>(
        stream: this.userDoc.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            buildError();
          }
          if (snapshot.connectionState == ConnectionState.none) {
            buildError();
          }
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            return ProfileInputField(
              value: authUser.displayName,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 3, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
              labelText: 'Building name / number',
              hintText: 'Building name / number',
              textValue: snapshot.data.data() == null ||
                      snapshot.data.data()['addressLineOne'] == null
                  ? ''
                  : snapshot.data.data()['addressLineOne'],
              controller: addressOneController,
              textInputType: TextInputType.text,
              onSave: () async {
                PreLoader.load.value = true;
                saveOrUpdateShopUserDetails(
                  snapshot,
                  'addressLineOne',
                  this.addressOneController,
                );
                PreLoader.load.value = false;
              },
            );
          }
          return Container();
        },
      ),
    );

    listViews.add(
      StreamBuilder<DocumentSnapshot>(
        stream: this.userDoc.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            buildError();
          }
          if (snapshot.connectionState == ConnectionState.none) {
            buildError();
          }
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            return ProfileInputField(
              value: authUser.displayName,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 3, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
              labelText: 'Street name',
              hintText: 'Street name',
              textValue: snapshot.data.data() == null ||
                      snapshot.data.data()['addressLineTwo'] == null
                  ? ''
                  : snapshot.data.data()['addressLineTwo'],
              controller: addressTwoController,
              textInputType: TextInputType.text,
              onSave: () async {
                PreLoader.load.value = true;
                saveOrUpdateShopUserDetails(
                  snapshot,
                  'addressLineTwo',
                  this.addressTwoController,
                );
                PreLoader.load.value = false;
              },
            );
          }
          return Container();
        },
      ),
    );

    listViews.add(
      StreamBuilder<DocumentSnapshot>(
        stream: this.userDoc.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            buildError();
          }
          if (snapshot.connectionState == ConnectionState.none) {
            buildError();
          }
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            return ProfileInputField(
              value: authUser.displayName,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * 3, 1.0,
                          curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
              labelText: 'Landmark',
              hintText: 'Example: near KIMS Hospital',
              textValue: snapshot.data.data() == null ||
                      snapshot.data.data()['landmark'] == null
                  ? ''
                  : snapshot.data.data()['landmark'],
              controller: landmarkController,
              textInputType: TextInputType.text,
              onSave: () async {
                PreLoader.load.value = true;
                saveOrUpdateShopUserDetails(
                  snapshot,
                  'landmark',
                  this.landmarkController,
                );
                PreLoader.load.value = false;
              },
            );
          }
          return Container();
        },
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Location',
        subTxt: '',
        showForwardArrow: false,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      LocationView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * 5, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );
  }

  saveOrUpdateShopUserDetails(
    AsyncSnapshot<DocumentSnapshot> snapshot,
    String keyValue,
    TextEditingController controller,
  ) {
    if (snapshot.data.data() == null) {
      this.shopUsers.doc(authUser.uid.toString()).set({
        keyValue: controller.text,
      });
    } else {
      this.shopUsers.doc(authUser.uid).update({
        keyValue: controller.text,
      }).then((value) {
        updateIsEditPressed(false);
      });
    }
  }

  void updateIsEditPressed(bool value) {
    setState(() {
      this.shopNameIsEditPressed = value;
    });
  }

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn),
      ),
    );

    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              getMainListViewUI(),
              getAppBarUI(),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey.withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Profile',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget buildError() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.error,
            color: AppTheme.errorText,
          ),
          Text(
            'Failed to load shop name',
            style: AppTheme.nearlyDarkBlueTextStyle,
          ),
        ],
      ),
    );
  }
}
