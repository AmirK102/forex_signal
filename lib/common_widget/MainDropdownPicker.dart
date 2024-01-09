
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utilities/app_colors.dart';

class MainDropdownPicker extends StatefulWidget {
  MainDropdownPicker({
    super.key,
    this.options = occupations,
    this.labelText = "একটি পেশা নির্বাচন করুন",
    this.validator,
    this.onChanged,
    this.initialValue
  });

  List<String> options;
  String? labelText;
  String? initialValue;
  String? Function(dynamic)? validator;
  void Function(dynamic)? onChanged;

  @override
  State<MainDropdownPicker> createState() => _MainDropdownPickerState();
}

class _MainDropdownPickerState extends State<MainDropdownPicker> {
  var selectedValue;
  final FocusNode _focusNode = FocusNode();
  bool _isNewLine = false;

  List<DropdownMenuItem<String>> dropdownItems = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedValue=widget.initialValue;
    dropdownItems = widget.options.map((String option) {
      return DropdownMenuItem<String>(
        value: option,
        alignment: Alignment.center,
        child: Text(
          option,
          style: TextStyle(
            color: AppColors.mainColor,
            fontWeight: FontWeight.w600,
            fontSize: 16.w,
          ),
        ),
      );
    }).toList();

    _focusNode.addListener(() {
      setState(() {
        _isNewLine = _focusNode.hasFocus;
      });

      if (selectedValue == null) {
        setState(() {
          _isNewLine = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: DropdownButtonFormField(
        value: selectedValue,
        focusNode: _focusNode,
        validator: widget.validator,
        onSaved: (v) {
          selectedValue = v;
          print("selectedValue");
          print(selectedValue);
          if (widget.onChanged == null) {
          } else {
            widget.onChanged!(v);
          }
        },
        iconSize: 30.w,
        onChanged: (v) {
          selectedValue = v;
          print("selectedValue");
          print(selectedValue);
          if (widget.onChanged == null) {
          } else {
            widget.onChanged!(v);
          }
        },
        items: dropdownItems,


        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xffF4F4F4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.w),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.w),
            borderSide: BorderSide(style: BorderStyle.solid, width: 3.w,color: AppColors.mainColorLow),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.w),
            borderSide: BorderSide(style: BorderStyle.solid, width: 3.w,color: AppColors.mainColor),
          ),

          iconColor: AppColors.mainColor,
          suffixIconColor: AppColors.mainColor,
          prefixIconColor: AppColors.mainColor,


          contentPadding:
          EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.w),
          hintText: _isNewLine ? '${widget.labelText}' : widget.labelText,
          hintStyle: TextStyle(
            color: AppColors.mainColor,
            fontWeight: FontWeight.w600,
            fontSize: 16.w,
          ),
        ),
      ),
    );
  }
}

const List<String> occupations = [
  'অ্যাকাউন্টেন্ট',
  'অভিনেতা',
  'স্থপতি',
  'শিল্পী',
  'অ্যাথলেট',
  'পাচক',
  'দন্ত চিকিৎসক',
  'ডাক্তার',
  'ইঞ্জিনিয়ার',
  'উদ্যোক্তা',
  'গ্রাফিক ডিজাইনার',
  'সাংবাদিক',
  'আইনজীবী',
  'নার্স',
  'ফটোগ্রাফার',
  'পুলিশ অফিসার',
  'সফ্টওয়্যার ডেভেলপার',
  'শিক্ষক',
  'ওয়েব ডেভেলপার',
  'লেখক',
];