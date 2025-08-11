// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class BasicButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String title;
  const BasicButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  State<BasicButton> createState() => _BasicButtonState();
}

class _BasicButtonState extends State<BasicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(vertical: height * 0.02),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isPressed ? Colors.grey.shade200 : AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            widget.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: _isPressed ? Colors.black : AppColors.inversePrimary,
            ),
          ),
        ),
      ),
    );
  }
}
