import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final bool isFocused; // Whether the text field has focus
  final String? errorText; // Optional error text to display

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.obscureText,
    this.isFocused = false, // Default to false
    this.errorText, // Default to null
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      cursorColor: Colors.white,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isFocused
                ? Colors.blue
                : Colors.white, // Customize focused border color
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          // Customize border color when there's an error
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          // Customize border color when focused and there's an error
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Icon(
            prefixIcon,
            color: Colors.white,
          ),
        ),
        errorText: errorText, // Display error text if provided
      ),
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }
}
