import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_panda/model/PackageModel.dart';
import 'package:package_panda/model/PaymentMethod.dart';
import 'package:package_panda/model/TransactionModel.dart';
import 'package:package_panda/model/UserModel.dart';
import 'package:package_panda/push_notification.dart';
import 'package:package_panda/utilities/app_colors.dart';


class FirebaseApi {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseApi _instance = FirebaseApi._internal();
  static String UserId = "";
  static UserModel? userModel;

  /// The scopes required by this application.
  static const List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  GoogleSignIn googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: 'your-client_id.apps.googleusercontent.com',
    scopes: scopes,
    //signInOption: SignInOption.games
  );

  factory FirebaseApi() {
    return _instance;
  }

  FirebaseApi._internal();

  Future<bool> checkLogin({isPhone = false}) async {
    if (isPhone) {
      var res = FirebaseAuth.instance.currentUser != null;
      if (!res) {
        return false;
      }
      UserId = FirebaseAuth.instance.currentUser!.uid;

      if (userModel == null) {
        var re = await getUser(UserId);
        if (re == null) {
          UserId = "";
        }
      }

      return true;
    }

    var res = await googleSignIn.isSignedIn();

    if (res == true) {
      if (googleSignIn.currentUser == null) {
        await handleSignInGoogle();
      }

      UserId = googleSignIn.currentUser!.id;

      if (userModel == null) {
        var re = await getUser(UserId);
        if (re == null) {
          UserId = "";
        }
      }
    } else {
      return false;
    }

    // googleSignIn.signOut();

    return true;
  }

  updateOpenApp() {
    try {
      _firestore.collection('users').doc(UserId).update({
        "last_open_app": DateTime.now(),
      });
    } catch (e) {
      // TODO
    }
  }

  Future<bool> isUserExist(uid) async {
    try {
      UserId = uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        if (userModel == null) {
          await getUser(UserId);
          updateOpenApp();
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }

  bool isLink(String imageUrl) {
    if (imageUrl.isEmpty) return false;

    // Check if the URL starts with a valid protocol scheme
    if (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
      return false;
    }

    // Try parsing the URL
    Uri? parsedUrl;
    try {
      parsedUrl = Uri.parse(imageUrl);
    } catch (e) {
      return false;
    }

    // Check if the parsed URL has a valid scheme and host
    return parsedUrl != null &&
        parsedUrl.scheme.isNotEmpty &&
        parsedUrl.host.isNotEmpty;
  }

  Future<String> uploadImageToStorage(File file, {String? nameOfImage}) async {
    if (nameOfImage == null) {
      nameOfImage = DateTime.now().toIso8601String();
    }
    var downloadUrl;

    if(kIsWeb) {
      Reference _reference = FirebaseStorage.instance
          .ref()
          .child(UserId).child(nameOfImage);

      print("Start upload");
      await _reference
          .putData(
        await file.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      )
          .whenComplete(() async {
        await _reference.getDownloadURL().then((value) {
          downloadUrl = value;
        });
      });
      print("end upload");
    }else{
      // Create a reference to the file in Firebase Storage
      final storageRef =
      FirebaseStorage.instance.ref().child(UserId).child(nameOfImage);




      var dd = SettableMetadata(contentType: "image/jpeg");

      // Upload the file to Firebase Storage
      await storageRef.putFile(file, dd);

      // Get the download URL of the uploaded file
      downloadUrl = await storageRef.getDownloadURL();
    }

    // Return the download URL
    return downloadUrl;
  }

  Future<bool> createUser(Map<String, dynamic> data, imageUrl) async {
    var photoUrl = "";
    print("imageUrl");
    print(imageUrl);

    if (isLink(imageUrl) == true) {
      photoUrl = imageUrl;
    } else {
      if (imageUrl != null && imageUrl != "")
        photoUrl = await uploadImageToStorage(File(imageUrl),
            nameOfImage: "profile-image");
    }

    data.addAll({
      'uid': UserId,
      "created_at": DateTime.now(),
      "last_open_app": DateTime.now(),
      "profile_photo": photoUrl,
    });

    try {
      if ((await isUserExist(UserId)) == true) {
        // update user data in Cloud Firestore
        await _firestore.collection('users').doc(UserId).update(data);
      } else {
        // Create user data in Cloud Firestore
        await _firestore.collection('users').doc(UserId).set(data);
        FirebaseApi.userModel = UserModel.fromJson(data);
      }
    } catch (e) {
      print('Error creating user: $e');
      // Handle the error as needed
    }
    return await checkLogin(isPhone: data["login_by"] == "phone");
  }

  Future<bool> handleSignInGoogle() async {
    try {
      await googleSignIn.signIn();
      UserId = googleSignIn.currentUser!.id;
      return true;
    } catch (error) {
      print(error);
    }
    return false;
  }

  Future<UserModel?> getUser(String uid) async {
    //  createPackage(packageData);
    // createPaymentMethod("345345345345", "blksh");
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        userModel = UserModel.fromJson(userDoc.data() as Map<String, dynamic>);

        print(userModel!.toJson());

        FirebaseMessaging.instance.subscribeToTopic(userModel!.uid!);
        return userModel;
      } else {
        print('User with UID $uid does not exist.');
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  Stream<List<SignalModel>> getAllPackagesStream({
    String? marketType,
    String? packageType,
    bool ascending = true,
  }) {
    try {
      Query query = _firestore.collection('packages');

      if (marketType != null) {
        query = query.where('market', isEqualTo: marketType);
      }



      // Add sorting based on ascending/descending order

      return query.snapshots().map((querySnapshot) {
        print('getting packages stream: ');

        return querySnapshot.docs.map((document) {
          return SignalModel.fromJson(document.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print('Error getting packages stream: $e');
      return Stream.value([]);
    }
  }

  Future<bool> isValidTransaction(transactionId) async {
    if (transactionId.toString().contains(" ") ||
        transactionId.toString().contains("\n")) {
      Get.snackbar(
        "একটা ভুল হয়েছে!",
        "ট্রান্সেকশন ID সঠিক ভাবে লিখুন",
        backgroundColor: AppColors.mainColor,
        duration: Duration(seconds: 5),
        colorText: Colors.white,
      );
      return false;
    }

    var res = await _firestore
        .collection('orders')
        .where("transaction_id", isEqualTo: transactionId)
        .get();

    if (res.size == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> createOrder(Map<String, dynamic> data, ) async {
    var doc = _firestore.collection('orders').doc();

    data.addAll({
      "id": doc.id,

    });

    //return true;
    if(data["screenshot"]!=""){
      var link = await uploadImageToStorage(File(data["screenshot"]));
      data.addAll({"screenshot": link});
    }

    await doc.set(data);
  }

  Future<void> updatePost({id, data}) async {
    await _firestore.collection('orders').doc(id).update(data);
  }
  Future<void> giveLike(id,count) async {
     await _firestore.collection('orders').doc(id).update({
      "like": count+1
    });
  }

  Future<void> giveDisLike(id,count) async {
    await _firestore.collection('orders').doc(id).update({
      "dislike": count+1
    });
  }

  Stream<List<PostModel>> getTransactionsByUserIdStream({String? marketType}) {


    if(marketType!=null){
      return _firestore
          .collection('orders').where('market', isEqualTo: marketType)

          .orderBy('date_time', descending: true)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((document) {
          print(document.data());
          // return TransactionModel.fromJson(document.data());
          return PostModel.fromJson(document.data());
        }).toList();
      });
    }
    else{
      return _firestore
          .collection('orders')

          .orderBy('date_time', descending: true)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((document) {
          print(document.data());
          // return TransactionModel.fromJson(document.data());
          return PostModel.fromJson(document.data());
        }).toList();
      });
    }


  }

  Future<void> createPaymentMethod(
    phone,
    type,
  ) async {
    var doc = _firestore.collection('payment_method').doc();

    doc.set({
      "phone": phone,
      "type": type,
      "create_at": DateTime.now(),
      "status": "active",
      "id": doc.id,
    });
  }

  Future<void> updatePaymentMethod(
      {required phone, required type, required id, status = "active"}) async {
    var doc = _firestore.collection('payment_method').doc(id);

    doc.update({
      "phone": phone,
      "type": type,
      "create_at": DateTime.now(),
    });
  }

  Future<void> deletePaymentMethod({required id}) async {
    _firestore.collection('payment_method').doc(id).delete();
  }

  Stream<List<PaymentMethod>> getPaymentMethodsStream() {
    return _firestore
        .collection('payment_method')
        .where("status", isEqualTo: "active")
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return PaymentMethod.fromMap(doc.data());
      }).toList();
    });
  }

  /// Admin

  Future<void> createSignal(Map<String, dynamic> data,
      {isUpdate = false, id}) async {
    var doc = _firestore.collection('packages').doc();

    if (isUpdate) {
      await _firestore.collection('packages').doc(id).update(data);
    } else {
      data.addAll({"id": doc.id});
      await doc.set(data);
    }
  }

  Future<void> deletePackage(id) async {
    var doc = _firestore.collection('packages').doc(id);

    await doc.delete();
  }

  Stream<List<PostModel>> getTransactionsStreamAdmin({
    String? userId,
    String? status,
    String? transactionId,
    String? sim,
    // Add more parameters as needed
  }) {
    print(status);
    print(transactionId);
    print(sim);
    print(userId);

    if (status == "all") {
      status = null;
    }
    if (sim == "all") {
      sim = null;
    }
    if (transactionId!.isEmpty) {
      transactionId = null;
    }

    print("===========");
    print(status);
    print(transactionId);
    print(sim);
    print(userId);

    var query = _firestore
        .collection('orders')
        .orderBy('confirm_date_time', descending: true);

    if (transactionId != null) {
      query = query.where('transaction_id', isEqualTo: transactionId);
    } else {
      // Apply filters based on the provided parameters
      if (userId != null) {
        query = query.where('user_id', isEqualTo: userId);
      }
      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      if (sim != null) {
        query = query.where('sim', isEqualTo: sim);
      }
      // Add more conditions for additional filters
    }
    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((document) {
        return PostModel.fromJson(document.data());
      }).toList();
    });
  }

  Future<void> changeStatusForOrder(
    status,
    message,
    id,
    data, {
    String? adminProfImage,
  }) async {
    var imageAdmin = "";
    if (adminProfImage != null && adminProfImage.isNotEmpty) {
      imageAdmin = await uploadImageToStorage(File(adminProfImage));
    }

    await _firestore.collection('orders').doc(id).update({
      "status": status,
      "message": message,
      "admin_prof_image": imageAdmin,
      "orderConfirmBy": userModel!.toJson()
    });

    sendPushMessage(
      token: data.userObj!.uid!,
      imageUrl: adminProfImage != null ? imageAdmin : data.screenshot,
      senderAvaterUrl:
          "https://t4.ftcdn.net/jpg/00/91/24/17/240_F_91241738_y1y50vmBrGZPvkbyCPf9nEhX7bOUFs74.jpg",
      message: message,
      title: data.pair,
    );
  }

  Future<void> changeRejectStatusForOrder(
      id, message,PostModel data) async {


    await _firestore.collection('orders').doc(id).update({
      "status": "rejected",
      "message": message,
      "orderRejectBy": userModel!.toJson()
    });
/*
    sendPushMessage(
      token: data.userObj!.uid!,
      imageUrl: data.screenshot,
      senderAvaterUrl:
      "https://t4.ftcdn.net/jpg/00/91/24/17/240_F_91241738_y1y50vmBrGZPvkbyCPf9nEhX7bOUFs74.jpg",
      message: message,
      title: data.title,
    );*/
  }

  Future<bool> setWorkingStatusForOrder(id, name, uid) async {
    if (await isAllowSendUssd(id, uid)) {
      _firestore.collection('orders').doc(id).update({
        "working_by": name,
        "working_uid": uid == "" ? UserId : uid,
      });
      return true;
    }
    return false;
  }

  Future<bool> isAllowSendUssd(id, uid) async {
    var res = await _firestore.collection('orders').doc(id).get();
    try {
      try {
        res.data()!["working_uid"];
      } catch (e) {
        return true;
      }

      if (res.data()!["working_uid"] == null) {
        return true;
      }

      print(res.data()!["working_uid"]);
      if (res.data()!["working_uid"] == uid) {
        return true;
      }
      if (res.data()!["working_by"] == userModel!.name) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Stream<PostModel?> getForOrderUpdateStream(
      String id, String name, String uid) {
    return _firestore.collection('orders').doc(id).snapshots().map((snapshot) {
      if (snapshot.exists) {
        var res =
            PostModel.fromJson(snapshot.data() as Map<String, dynamic>);

        return res;
      } else {
        return null; // Return null if the document doesn't exist
      }
    });
  }

  Future<bool> isAdmin() async {
    if (userModel == null) {
      return false;
    }

    if (userModel!.loginBy == "email") {
      try {
        var res = await _firestore
            .collection('admin')
            .where("email", isEqualTo: userModel!.email!)
            .get();
        return res.docs.length != 0;
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}

Map<String, dynamic> packageData = {
  "title": "100gb + 400 min",
  "duration": 30,
  "price": 300,
  "date_time": DateTime.now(),
  "package_rate": 350,
  "commission": 50,
  "discount": 40,
  "earnings": 10,
  "revenue": 4, // Assuming 6 is the cash out fee
  "transaction_id": "65f6g54h65",
  "phone_number": "908450968",
  "status": "active",
  "sim": "gp",
  "package_type": "bundle",
  "hot_deal": true,
};
