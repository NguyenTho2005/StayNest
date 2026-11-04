import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchMapScreen extends StatelessWidget {
  const SearchMapScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: 390,
          height: 844,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/search_map_canvas.png',
                fit: BoxFit.fill,
              ),
              _MapHotspot(
                left: 18,
                top: 18,
                width: 48,
                height: 50,
                onTap: () => context.pop(),
              ),
              _MapHotspot(
                left: 244,
                top: 18,
                width: 132,
                height: 52,
                onTap: () => context.go('/search/results'),
              ),
              _MapHotspot(
                left: 264,
                top: 78,
                width: 58,
                height: 48,
                onTap: () => context.push('/search/filters/amenities'),
              ),
              _MapHotspot(
                left: 323,
                top: 78,
                width: 52,
                height: 48,
                onTap: () => context.push('/search/sort'),
              ),
              _MapHotspot(
                left: 90,
                top: 234,
                width: 104,
                height: 54,
                onTap: () => context.push('/search/quick-view'),
              ),
              _MapHotspot(
                left: 24,
                top: 780,
                width: 76,
                height: 60,
                onTap: () => context.go('/'),
              ),
              _MapHotspot(
                left: 100,
                top: 780,
                width: 76,
                height: 60,
                onTap: () => context.go('/search'),
              ),
              _MapHotspot(
                left: 176,
                top: 780,
                width: 76,
                height: 60,
                onTap: () => context.go('/favorites'),
              ),
              _MapHotspot(
                left: 252,
                top: 780,
                width: 76,
                height: 60,
                onTap: () => context.go('/trips'),
              ),
              _MapHotspot(
                left: 328,
                top: 780,
                width: 62,
                height: 60,
                onTap: () => context.go('/account'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _MapHotspot extends StatelessWidget {
  const _MapHotspot({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.onTap,
  });
  final double left, top, width, height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Positioned(
    left: left,
    top: top,
    width: width,
    height: height,
    child: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: const SizedBox.expand(),
    ),
  );
}
