import 'package:flutter/material.dart';

/// Responsive wrapper that presents StayNest inside a centered mobile phone frame
/// on wide viewports (tablet/desktop, width > 480) while preserving 100% full-width
/// display on mobile viewports.
class ResponsiveAppShell extends StatelessWidget {
  const ResponsiveAppShell({super.key, required this.child});

  final Widget child;

  /// Standard Figma Page 1 frame width for StayNest mobile designs.
  static const double standardMobileWidth = 390.0;

  /// Breakpoint beyond which desktop framing is enabled.
  static const double mobileBreakpoint = 480.0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    // Mobile viewports (smartphones): render full natural viewport without frame
    if (screenWidth <= mobileBreakpoint) {
      return child;
    }

    // Wide screens (Tablet / Desktop): clamp to 390px frame centered
    final clampedMediaQuery = mediaQuery.copyWith(
      size: Size(standardMobileWidth, mediaQuery.size.height),
    );

    return Container(
      color: const Color(0xFF0F141A), // Dark slate backdrop framing the phone
      child: Center(
        child: Container(
          width: standardMobileWidth,
          height: mediaQuery.size.height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0x59000000),
                blurRadius: 36,
                spreadRadius: 6,
                offset: Offset(0, 10),
              ),
              BoxShadow(
                color: Color(0x1F000000),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ScaffoldMessenger(
            child: MediaQuery(data: clampedMediaQuery, child: child),
          ),
        ),
      ),
    );
  }
}
