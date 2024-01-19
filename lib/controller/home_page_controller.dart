import 'package:get/get.dart';
enum MarketType {all, crypto, forex, metal, stock }
class HomePageLogic extends GetxController{

  RxString profileImage="https://media.istockphoto.com/id/1351147752/photo/studio-portrait-of-attractive-20-year-old-bearded-man.jpg?s=612x612&w=0&k=20&c=-twL1NKKad6S_EPrGSniewjh6776A0Ju27ExMh7v_kI=".obs;
  RxString userGender="male".obs;
  RxString selectedPackageCategory="bundle".obs;
  RxBool lowToHigh=true.obs;
  RxString selectedMarketType= MarketType.all.name.obs;

}
