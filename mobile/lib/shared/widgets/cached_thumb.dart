import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import 'loading_skeleton.dart';

/// A [CachedNetworkImage] preconfigured to resolve the backend's relative
/// file URLs (see [AppConfig.resolveFileUrl]) with a skeleton placeholder and
/// a broken-image fallback.
class CachedThumb extends StatelessWidget {
  const CachedThumb({
    super.key,
    required this.relativeUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String? relativeUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final url = AppConfig.resolveFileUrl(relativeUrl);
    Widget child;
    if (url.isEmpty) {
      child = _placeholder(context);
    } else {
      child = CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => SkeletonBox(width: width, height: height ?? 16, borderRadius: 0),
        errorWidget: (context, url, error) => _placeholder(context),
      );
    }
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(Icons.image_not_supported_outlined,
          color: Theme.of(context).colorScheme.outline),
    );
  }
}
