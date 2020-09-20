class MealsListData {
  MealsListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.meals,
    this.nos = 0,
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String> meals;
  int nos;

  static List<MealsListData> tabIconsList = <MealsListData>[
    MealsListData(
      imagePath: 'assets/app_images/breakfast.png',
      titleTxt: 'Shops',
      nos: 525,
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    MealsListData(
      imagePath: 'assets/app_images/lunch.png',
      titleTxt: 'Areas',
      nos: 602,
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    MealsListData(
      imagePath: 'assets/app_images/snack.png',
      titleTxt: 'Delivery Boys',
      nos: 65,
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
  ];
}
