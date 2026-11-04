import 'package:flutter/material.dart';

import '../design/tokens.dart';
import 'figma_asset.dart';

class FigmaStatusBar extends StatelessWidget {
  const FigmaStatusBar({super.key, this.horizontalPadding = 20});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 34,
    child: Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '9:41',
            style: TextStyle(
              fontSize: 14,
              height: 22 / 14,
              fontWeight: FontWeight.w600,
              color: StayNestColors.ink,
            ),
          ),
          Row(
            children: const [
              FigmaSvg(
                'assets/icons/status_signal.svg',
                width: 13.333,
                height: 13.333,
              ),
              SizedBox(width: 6),
              FigmaSvg(
                'assets/icons/status_wifi.svg',
                width: 16,
                height: 11.333,
              ),
              SizedBox(width: 6),
              FigmaSvg(
                'assets/icons/status_battery.svg',
                width: 7.5,
                height: 15,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
