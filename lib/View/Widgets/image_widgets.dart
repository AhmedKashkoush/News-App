import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'indicators.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String? imageUrl;
  const CustomCachedNetworkImage({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fadeInDuration: const Duration(milliseconds: 300),
        fadeInCurve: Curves.easeInOut,
        // imageBuilder: (context, provider) => Image.network(
        //   model!.urlToImage!,
        //   fit: BoxFit.cover,
        //   errorBuilder: (context, error, trace) => const Center(
        //     child: Icon(Icons.broken_image_rounded),
        //   ),
        // ),
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) =>
            CustomCircularIndicator(
          color: Colors.red,
          backgroundColor:
              Theme.of(context).textTheme.headline4!.color!.withOpacity(0.3),
        ),
        errorWidget: (context, url, child) => CustomImageError(),
      );
    } catch (e) {
      return CustomImageError();
    }
  }
}

class CustomImageError extends StatelessWidget {
  const CustomImageError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.broken_image_rounded,
        size: 160,
        color: Theme.of(context).iconTheme.color!.withOpacity(0.1),
      ),
    );
  }
}
