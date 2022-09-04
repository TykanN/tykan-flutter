import 'package:flutter/material.dart';
import 'package:inflearn_lecture/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autofocus = false,
    required this.onChanged,
  });

  static const baseBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: MyColor.inputBroder,
      width: 1.0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: MyColor.primary,
      // 비밀번호
      obscureText: obscureText,
      autofocus: autofocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: MyColor.bodyText,
          fontSize: 14.0,
        ),
        errorText: errorText,
        fillColor: MyColor.inputBg,
        filled: true,
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: MyColor.primary,
          ),
        ),
      ),
    );
  }
}
