import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FigmaSvg extends StatelessWidget {
  const FigmaSvg(
    this.path, {
    super.key,
    required this.width,
    required this.height,
  });

  final String path;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) =>
      SvgPicture.asset(path, width: width, height: height, fit: BoxFit.contain);
}

class FigmaRaster extends StatelessWidget {
  const FigmaRaster(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) => Image.asset(
    path,
    width: width,
    height: height,
    fit: fit,
    alignment: alignment,
  );
}
