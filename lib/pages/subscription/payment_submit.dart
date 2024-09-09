import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:package_panda/repository/firebase_api.dart';

class TransactionPage extends StatefulWidget {
  final String packageName;
  final String packagePrice;
  final String discount;

  const TransactionPage({
    Key? key,
    required this.packageName,
    required this.packagePrice,
    required this.discount,
  }) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final TextEditingController _transactionIdController =
      TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Color(0xFF66B2B2);
    final backgroundColor = Color(0xFFF2F2F2);

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Submit Payment Proof', style: TextStyle(color: Colors.white)),
        backgroundColor: themeColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Package Section
            Text(
              'Selected Package',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.packageName,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: themeColor),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        widget.packagePrice,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.discount,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            // Payment Details Section
            Text(
              'Payment Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wallet Number: 1234-5678-9101',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Image.network(
                      'https://img.freepik.com/free-vector/scan-me-qr-code_78370-2915.jpg', // Placeholder for QR code image
                      width: 150,
                      height: 150,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Submitting Payment Proof Section
            Text(
              'Submit Payment Proof',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _transactionIdController,
              decoration: InputDecoration(
                labelText: 'Transaction ID',
                labelStyle: TextStyle(color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: themeColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: themeColor, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Upload Image Section
            _selectedImage == null
                ? Center(
                    child: ElevatedButton.icon(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        primary: themeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      ),
                      icon: Icon(Icons.upload, color: Colors.white),
                      label: Text('Upload Screenshot',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  )
                : Center(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _selectedImage!,
                            height: 100,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: _removeImage,
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            SizedBox(height: 30),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () {



                  if (_transactionIdController.text.isEmpty ||
                      _selectedImage == null) {
                    EasyLoading.showToast("Fill the details");
                  } else {
                    _submitPayment();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: themeColor,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Submit Payment',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }

  @override
  void dispose() {
    _transactionIdController.dispose();
    super.dispose();
  }

  void _submitPayment() async {

    List<String> parts = widget.packageName.split(" ");

    Map<String, dynamic> _data = {
      "user_id": FirebaseApi.UserId,
      "user_name": FirebaseApi.userModel?.name,
      "transaction_id": _transactionIdController.text,
      "screenshot": _selectedImage!.path,
      "create_at": DateTime.now(),
      "package_duration": parts.sublist(0, 2).join(" "),
      "package_price": widget.packagePrice,
      "status":"PENDING"
    };
    EasyLoading.show();
    await FirebaseApi().submitPaymentProof(_data);
    EasyLoading.dismiss();
    EasyLoading.showToast("Payment submit! Wait For Confirmation.");
  }
}
