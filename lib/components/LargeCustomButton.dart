import 'package:flutter/material.dart';

class LargeCustomButton extends StatelessWidget {
  final String yourText;
  final VoidCallback
      onPressedFunction; // Use VoidCallback for onPressed function
  final Color buttonColor;
  final Color textColor;
  const LargeCustomButton(
      {Key? key, // Use Key? for specifying the widget's key
      required this.yourText,
      required this.onPressedFunction,
      required this.buttonColor,
      required this.textColor})
      : super(key: key); // Set the key parameter using super

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RawMaterialButton(
        fillColor: buttonColor,
        elevation: 0.0,
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onPressed: onPressedFunction,
        child: Text(
          yourText,
          style: TextStyle(color: textColor, fontSize: 18.0),
        ),
      ),
    );
  }
}
