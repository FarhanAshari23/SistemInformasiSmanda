import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class CustomInkWell extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget child;
  final Color defaultColor;
  final Color pressedColor;
  final double borderRadius;

  const CustomInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.defaultColor = AppColors.primary,
    this.pressedColor = const Color(0xFFD3D3D3),
    this.borderRadius = 0,
  });

  @override
  State<CustomInkWell> createState() => _CustomInkWellState();
}

class _CustomInkWellState extends State<CustomInkWell> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        onTap: widget.onTap ?? () {},
        onHighlightChanged: (isPressed) {
          setState(() {
            _isPressed = isPressed;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _isPressed ? widget.pressedColor : widget.defaultColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
