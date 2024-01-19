import 'package:advanced_shadows/advanced_shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_panda/utilities/app_colors.dart';

class MainInputFiled extends StatefulWidget {
  MainInputFiled({
    super.key,
    this.hints = "এখানে লিখুন",
    this.textEditingController,
    this.keyboardType = TextInputType.text,
    this.onSave,
    this.readOnly=false,
    this.onChanged,
    this.maxLine=1,
    this.validator, this.textAlign= TextAlign.left,
  });

  final hints;
  final readOnly;
  TextEditingController? textEditingController;
  TextInputType? keyboardType;
  final TextAlign textAlign;
  final int maxLine;
  final Function(String?)? onSave, onChanged;
  String? Function(String?)? validator;

  @override
  State<MainInputFiled> createState() => _MainInputFiledState();
}

class _MainInputFiledState extends State<MainInputFiled> {
  final FocusNode _focusNode = FocusNode();
  bool _isNewLine = false;
  double letterSpacing = 1;

  @override
  void initState() {
    super.initState();
    if (widget.textEditingController == null) {
      widget.textEditingController = TextEditingController();
    }

    if (widget.keyboardType == TextInputType.phone ||
        widget.keyboardType == TextInputType.number) {
      letterSpacing = 3;
    }
    if (widget.textEditingController != null &&
        widget.textEditingController!.text.isNotEmpty) {
        _isNewLine = true;
    }
    _focusNode.addListener(() {
      setState(() {
        _isNewLine = _focusNode.hasFocus;
      });

      if (widget.textEditingController != null &&
          widget.textEditingController!.text.isNotEmpty) {
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
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.w),
            child: AdvancedShadow(
              innerShadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
              outerShadows: [],
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.w),
                  color: Color(0XffF4F4F4), // Set the background color
                ),
              ),
            ),
          ),
        ),
        TextFormField(
          focusNode: _focusNode,
          readOnly: widget.readOnly,
          onSaved: widget.onChanged,
          textAlign: widget.textAlign,
          onChanged: widget.onChanged,
          validator: widget.validator,
          controller: widget.textEditingController,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLine,
          style: TextStyle(
              color: AppColors.mainColor,
              fontWeight: FontWeight.w600,
              fontSize: 16.w,
              letterSpacing: letterSpacing),
          decoration: InputDecoration(

            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0.w),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.w),
            labelText:
                _isNewLine ? "${widget.hints ?? ""}\n" : widget.hints ?? "",
            // hintText: widget.hints??"",
            floatingLabelAlignment: FloatingLabelAlignment.start,
            hintStyle: TextStyle(
              color: AppColors.mainColorLow,
              fontWeight: FontWeight.w600,
              fontSize: 16.w,
            ),
            labelStyle: TextStyle(
              color: AppColors.mainColorLow,
              fontWeight: FontWeight.w600,
              fontSize: 16.w,
            ),
          ),
        )
      ],
    );
  }
}
