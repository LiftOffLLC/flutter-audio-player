import 'package:flutter/material.dart';

class AudioImage extends StatelessWidget {
  final String audioPicture;
  final double width;
  final double height;
  final Alignment alignment;
  final BoxFit fit;

  const AudioImage({
    super.key,
    required this.audioPicture,
    this.width = 700,
    this.height = 300,
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      audioPicture,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
    );
  }
}
