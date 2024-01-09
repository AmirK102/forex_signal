import 'package:get/get.dart';
import 'package:package_panda/repository/firebase_api.dart';

class CreateProfileLogic extends GetxController{

  FirebaseApi firebaseApi = FirebaseApi();

  RxString pickedImagePath="".obs;
  RxString selectedGender="male".obs;
}