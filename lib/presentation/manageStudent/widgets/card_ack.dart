import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class CardAck extends StatelessWidget {
  final String title;
  final String? content;
  final File? image;
  const CardAck({
    super.key,
    required this.title,
    this.image,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width * 0.5,
      height: height * 0.4,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            width: width * 0.5,
            height: height * 0.35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.secondary,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: image != null
                    ? Container(
                        width: height * 0.15,
                        height: height * 0.15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: FileImage(image!),
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    : Text(
                        content.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: AppColors.inversePrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
          ),
          Positioned(
            bottom: height * 0.3,
            child: Container(
              width: width * 0.265,
              height: height * 0.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.tertiary,
              ),
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.inversePrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
