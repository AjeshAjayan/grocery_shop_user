import 'package:flutter/widgets.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/app_images/hotel_booking.png',
      navigateScreen: Container(
        child: Text("hotel booking"),
      ),
    ),
    HomeList(
      imagePath: 'assets/app_images/app_images.png',
      navigateScreen: Container(
        child: Text("Fitness"),
      ),
    ),
    HomeList(
      imagePath: 'assets/app_images/design_course.png',
      navigateScreen: Container(
        child: Text("course"),
      ),
    ),
  ];
}
