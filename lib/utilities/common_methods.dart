import 'package:image_picker/image_picker.dart';

class CommonMethods{
  final ImagePicker _picker = ImagePicker();

  Future <String> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery,imageQuality:60 );

    if (pickedFile != null) {

      print('Image path: ${pickedFile.path}');
      return pickedFile.path;
    } else {

      print('No image selected.');
      return "";
    }
  }

}