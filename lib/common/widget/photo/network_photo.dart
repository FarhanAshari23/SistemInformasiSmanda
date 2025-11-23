import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NetworkPhoto extends StatelessWidget {
  final String imageUrl;
  final String fallbackAsset;
  final double width;
  final double height;
  final BoxShape shape;
  const NetworkPhoto({
    super.key,
    required this.fallbackAsset,
    required this.imageUrl,
    required this.height,
    required this.width,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, provider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: shape,
          image: DecorationImage(
            image: provider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey,
            shape: shape,
          ),
        ),
      ),
      errorWidget: (_, __, ___) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: shape,
          image: DecorationImage(
            image: AssetImage(fallbackAsset),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
