import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocery_shop/app/models/user.dart';
import 'package:grocery_shop/app/theme/home_theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:grocery_shop/app/widgets/pre_loader.dart';

class LocationView extends StatefulWidget {
  const LocationView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;
  @override
  _LocationViewState createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn),
    );
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 30),
                child: FractionallySizedBox(
                  widthFactor: 0.87,
                  child: MapView(
                    animation: animation,
                    animationController: animationController,
                  ),
                ),
              )),
        );
      },
    );
  }
}

class MapView extends StatefulWidget {
  MapView({
    Key key,
    this.animationController,
    this.animation,
  }) : super(key: key);
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final Completer<GoogleMapController> _controller = Completer();
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  List<Marker> markers;
  final userSnap = FirebaseFirestore.instance
      .collection('shop_users')
      .doc(authUser.uid)
      .snapshots();
  final userDoc =
      FirebaseFirestore.instance.collection('shop_users').doc(authUser.uid);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - widget.animation.value), 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: AppTheme.grey.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: this.userSnap,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot,
                      ) {
                        final streamData = snapshot.data.data();
                        if (snapshot.hasError) {
                          return Container();
                        }
                        if (snapshot.connectionState == ConnectionState.none) {
                          return Container();
                        }
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 400,
                          child: Stack(
                            children: [
                              GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      streamData['latitude'] != null
                                          ? streamData['latitude']
                                          : 0,
                                      streamData['longitude'] != null
                                          ? streamData['longitude']
                                          : 0),
                                  zoom: 14,
                                ),
                                markers: Set.from([
                                  Marker(
                                    markerId: MarkerId('shop_location'),
                                    draggable: false,
                                    position: LatLng(
                                      streamData['latitude'] != null
                                          ? streamData['latitude']
                                          : 0,
                                      streamData['longitude'] != null
                                          ? streamData['longitude']
                                          : 0,
                                    ),
                                  )
                                ]),
                                onMapCreated: (GoogleMapController controller) {
                                  widget._controller.complete(controller);
                                },
                              ),
                              InkWell(
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0)),
                                splashColor:
                                    AppTheme.nearlyDarkBlue.withOpacity(0.2),
                                onTap: () async {
                                  PreLoader.load.value = true;

                                  final position = await getAndSaveLocation();
                                  print(position.longitude);
                                  List<Placemark> placeMarks =
                                      await getAndSaveAddress(position);

                                  PreLoader.load.value = false;
                                },
                                child: Container(
                                  height: 70,
                                  width: double.infinity,
                                  color: Color(0xB9544f4e),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.my_location,
                                          color: AppTheme.nearlyDarkBlue,
                                          size: 30,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          streamData['latitude'] != null
                                              ? 'Re-calibrate Location'
                                              : 'Calibrate Location',
                                          style:
                                              AppTheme.nearlyDarkBlueTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Position> getAndSaveLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('shop_users').doc(authUser.uid);

    DocumentSnapshot doc = await docRef.get();

    if (!doc.exists) {
      docRef.set({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'accuracy': position.accuracy,
        'altitude': position.altitude,
      });
    } else {
      docRef.update({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'accuracy': position.accuracy,
        'altitude': position.altitude,
      });
    }
    final GoogleMapController controller = await widget._controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            position.latitude,
            position.longitude,
          ),
          zoom: 14,
        ),
      ),
    );
    return position;
  }

  Future<List<Placemark>> getAndSaveAddress(Position position) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('shop_users').doc(authUser.uid);

    DocumentSnapshot doc = await docRef.get();

    if (doc.exists) {
      docRef.update({
        'country': placeMarks.first.country,
        'locality': placeMarks.first.locality,
        'isoCountryCode': placeMarks.first.isoCountryCode,
        'administrativeArea': placeMarks.first.administrativeArea,
        'name': placeMarks.first.name,
        'postalCode': placeMarks.first.postalCode,
        'street': placeMarks.first.street,
        'subAdministrativeArea': placeMarks.first.subAdministrativeArea,
        'subLocality': placeMarks.first.subLocality,
        'subThoroughfare': placeMarks.first.subThoroughfare,
        'thoroughfare': placeMarks.first.thoroughfare,
      });
    } else {
      AppTheme.buildSnackBar(context, 'Please fill other details first');
    }
  }
}
