import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../design/tokens.dart';

class StayNestBottomNavigation extends StatelessWidget {
  const StayNestBottomNavigation({super.key, required this.selectedIndex});

  final int selectedIndex;

  static const _paths = ['/', '/search', '/favorites', '/trips', '/account'];
  static const _labels = [
    'Khám phá',
    'Tìm kiếm',
    'Yêu thích',
    'Chuyến đi',
    'Tài khoản',
  ];
  static const _icons = [
    'assets/icons/tab_explore.svg',
    'assets/icons/tab_search.svg',
    'assets/icons/tab_favorites.svg',
    'assets/icons/tab_trips.svg',
    'assets/icons/tab_account.svg',
  ];

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 68,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Container(
          height: 68,
          decoration: const BoxDecoration(
            color: StayNestColors.white,
            border: Border(
              top: BorderSide(color: Color(0xFFEAF0F5), width: 0.8),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_labels.length, (index) {
              final selected = selectedIndex == index;
              return InkWell(
                onTap: () => context.go(_paths[index]),
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 56,
                  height: 44,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SvgPicture.asset(
                            _icons[index],
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(
                              selected
                                  ? StayNestColors.teal
                                  : const Color(0xFF3D4949),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _labels[index],
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontSize: 11,
                          height: 16 / 11,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: selected
                              ? StayNestColors.teal
                              : StayNestColors.mutedLight,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    ),
  );
}
