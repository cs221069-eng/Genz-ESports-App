import 'package:flutter/material.dart';
import 'neumorphic_container.dart';

class NeumorphicTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;

  const NeumorphicTextField({
    super.key,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.prefix,
    this.suffix,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    return NeumorphicContainer(
      borderRadius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
              color: textColor != null
                  ? Color.fromRGBO((textColor.r * 255.0).round() & 0xff, (textColor.g * 255.0).round() & 0xff, (textColor.b * 255.0).round() & 0xff, 0.7)
                  : null),
          border: InputBorder.none,
          prefixIcon: prefix,
          suffixIcon: suffix,
        ),
      ),
    );
  }
}
