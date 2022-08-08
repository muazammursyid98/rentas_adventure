// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class JDInputText extends StatelessWidget {
  const JDInputText({
    Key? key,
    required this.onChanged,
    this.validator,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.textInputAction,
  }) : super(key: key);
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType ?? TextInputType.text,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
        hintText: hintText,
        fillColor: Colors.white,
        filled: true,
        errorStyle: const TextStyle(height: 0, color: Colors.red),
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xFF969A9D),
          fontWeight: FontWeight.w300,
        ),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: const Color(0xFF707070), width: .5)),
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: const Color(0xFF707070), width: .5)),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Color(0xFF707070), width: .5)),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.red, width: .5),
        ),
      ),
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF3C3C43),
      ),
    );
  }
}
