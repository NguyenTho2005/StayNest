import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design/tokens.dart';
import '../widgets/figma_asset.dart';

class PropertyQuickViewScreen extends StatelessWidget {
  const PropertyQuickViewScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFEBF1F6),
    body: Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: 390,
          height: 844,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const _QuickViewMapBackdrop(),
              const Positioned(
                left: 140,
                top: 354,
                child: Text(
                  'SÔNG HOÀI',
                  style: TextStyle(
                    color: Color(0xFF4C5E83),
                    fontSize: 9,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const Positioned(
                left: 40,
                top: 153,
                child: _QuietPricePin(price: '980.000đ'),
              ),
              const Positioned(left: 95, top: 260, child: _ActivePricePin()),
              Positioned(
                left: 20,
                right: 20,
                top: 40,
                child: _QuickViewMapHeader(
                  onBack: () => context.pop(),
                  onList: () => context.go('/search/results'),
                ),
              ),
              Positioned(
                left: 20,
                top: 125,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xE6FFFFFF),
                    border: Border.all(color: const Color(0xFFE4E7EC)),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        radius: 3,
                        backgroundColor: Color(0xFF0F8B8D),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Bản đồ mô phỏng · DEMO',
                        style: TextStyle(
                          color: Color(0xFF344054),
                          fontSize: 11,
                          height: 16.5 / 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned.fill(
                child: ColoredBox(color: Color(0x40172B4D)),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 465,
                  width: 390,
                  child: _QuickViewSheet(onClose: () => context.pop()),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _QuickViewMapBackdrop extends StatelessWidget {
  const _QuickViewMapBackdrop();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Stack(
      fit: StackFit.expand,
      children: [
        const FigmaSvg(
          'assets/icons/quick_view_01.svg',
          width: 390,
          height: 844,
        ),
        Positioned(
          left: 0,
          right: 0,
          top: constraints.maxHeight * .308,
          height: 7,
          child: const FigmaSvg(
            'assets/icons/quick_view_06.svg',
            width: 390,
            height: 7,
          ),
        ),
        Positioned(
          left: constraints.maxWidth * .05,
          top: constraints.maxHeight * .37,
          width: constraints.maxWidth * .95,
          height: 110,
          child: const FigmaSvg(
            'assets/icons/quick_view_02.svg',
            width: 370,
            height: 110,
          ),
        ),
        Positioned(
          left: constraints.maxWidth * .11,
          top: constraints.maxHeight * .52,
          width: constraints.maxWidth * .25,
          height: 118,
          child: const FigmaSvg(
            'assets/icons/quick_view_03.svg',
            width: 100,
            height: 118,
          ),
        ),
        Positioned(
          right: constraints.maxWidth * .12,
          top: constraints.maxHeight * .52,
          width: constraints.maxWidth * .27,
          height: 118,
          child: const FigmaSvg(
            'assets/icons/quick_view_04.svg',
            width: 105,
            height: 118,
          ),
        ),
        Positioned(
          left: constraints.maxWidth * .43,
          top: 0,
          bottom: constraints.maxHeight * .35,
          width: 3,
          child: const FigmaSvg(
            'assets/icons/quick_view_05.svg',
            width: 3,
            height: 500,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: constraints.maxHeight * .2,
          height: 2,
          child: const FigmaSvg(
            'assets/icons/quick_view_07.svg',
            width: 390,
            height: 2,
          ),
        ),
      ],
    ),
  );
}

class _QuickViewMapHeader extends StatelessWidget {
  const _QuickViewMapHeader({required this.onBack, required this.onList});
  final VoidCallback onBack, onList;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: const Color(0xF2FFFFFF),
      border: Border.all(color: const Color(0xFFE4E7EC)),
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14172B4D),
          blurRadius: 16,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        InkWell(
          onTap: onBack,
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFF7F9FC),
              shape: BoxShape.circle,
            ),
            child: const FigmaSvg(
              'assets/icons/quick_view_09.svg',
              width: 16,
              height: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Hội An',
                    style: TextStyle(
                      color: Color(0xFF121C2A),
                      fontSize: 16,
                      height: 22.5 / 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  _TealPill('3 chỗ ở'),
                ],
              ),
              Text(
                'Quảng Nam, Việt Nam',
                style: TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 12,
                  height: 18 / 12,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onList,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: StayNestColors.tealBright,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                FigmaSvg(
                  'assets/icons/quick_view_10.svg',
                  width: 14,
                  height: 14,
                ),
                SizedBox(width: 6),
                Text(
                  'Danh sách',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 18 / 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _QuickViewSheet extends StatelessWidget {
  const _QuickViewSheet({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: Color(0xFFE4E7EC))),
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      boxShadow: [
        BoxShadow(
          color: Color(0x40000000),
          blurRadius: 32,
          offset: Offset(0, -10),
        ),
      ],
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD0D5DD),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'XEM NHANH CHỖ Ở',
                  style: TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 12,
                    height: 18 / 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .7,
                  ),
                ),
              ),
              InkWell(
                onTap: onClose,
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF7F9FC),
                    shape: BoxShape.circle,
                  ),
                  child: const FigmaSvg(
                    'assets/icons/quick_view_11.svg',
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: const FigmaRaster(
                        'assets/images/quick_view_room.jpg',
                        width: double.infinity,
                        height: 168,
                      ),
                    ),
                    Positioned(
                      left: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xF2FFFFFF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Ưu đãi · Phổ biến nhất',
                          style: TextStyle(
                            color: Color(0xFF344054),
                            fontSize: 11,
                            height: 16.5 / 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xE6FFFFFF),
                          shape: BoxShape.circle,
                        ),
                        child: const FigmaSvg(
                          'assets/icons/quick_view_12.svg',
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mây Homestay',
                            style: TextStyle(
                              color: Color(0xFF121C2A),
                              fontSize: 18,
                              height: 25 / 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              FigmaSvg(
                                'assets/icons/quick_view_13.svg',
                                width: 14,
                                height: 14,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Hội An, Quảng Nam',
                                style: TextStyle(
                                  color: Color(0xFF667085),
                                  fontSize: 13,
                                  height: 19.5 / 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3F2),
                        border: Border.all(color: const Color(0xFFFEE4E2)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          FigmaSvg(
                            'assets/icons/quick_view_14.svg',
                            width: 14,
                            height: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '4,8',
                            style: TextStyle(
                              color: Color(0xFF121C2A),
                              fontSize: 13,
                              height: 19.5 / 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    _AmenityChip(icon: 'quick_view_15.svg', label: 'Bếp'),
                    SizedBox(width: 8),
                    _AmenityChip(icon: 'quick_view_16.svg', label: 'Wi-Fi'),
                    SizedBox(width: 8),
                    _AmenityChip(icon: 'quick_view_17.svg', label: 'Điều hòa'),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFF2F4F7))),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'GIÁ MINH HỌA',
                      style: TextStyle(
                        color: Color(0xFF667085),
                        fontSize: 11,
                        height: 16.5 / 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .6,
                      ),
                    ),
                    SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '850.000đ',
                          style: TextStyle(
                            color: Color(0xFF121C2A),
                            fontSize: 20,
                            height: 30 / 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '/ đêm',
                          style: TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 12,
                            height: 18 / 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: () => context.push('/properties/may-homestay'),
                  style: FilledButton.styleFrom(
                    backgroundColor: StayNestColors.tealBright,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Xem chi tiết',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 22.5 / 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      FigmaSvg(
                        'assets/icons/quick_view_18.svg',
                        width: 16,
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _QuietPricePin extends StatelessWidget {
  const _QuietPricePin({required this.price});
  final String price;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE4E7EC)),
          borderRadius: BorderRadius.circular(99),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          price,
          style: const TextStyle(
            color: Color(0xFF172B4D),
            fontSize: 12,
            height: 18 / 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      const SizedBox(height: 2),
      const CircleAvatar(radius: 4, backgroundColor: Color(0xFF172B4D)),
    ],
  );
}

class _ActivePricePin extends StatelessWidget {
  const _ActivePricePin();
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: StayNestColors.tealBright,
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(99),
          boxShadow: const [
            BoxShadow(
              color: Color(0x550F8B8D),
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: const Row(
          children: [
            FigmaSvg('assets/icons/quick_view_08.svg', width: 14, height: 14),
            SizedBox(width: 4),
            Text(
              '850.000đ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                height: 19.5 / 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 3),
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: StayNestColors.tealBright,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    ],
  );
}

class _AmenityChip extends StatelessWidget {
  const _AmenityChip({required this.icon, required this.label});
  final String icon, label;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        border: Border.all(color: const Color(0xFFE4E7EC)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FigmaSvg('assets/icons/$icon', width: 12, height: 12),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF344054), fontSize: 11),
            ),
          ),
        ],
      ),
    ),
  );
}

class _TealPill extends StatelessWidget {
  const _TealPill(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF7F6),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: StayNestColors.teal,
        fontSize: 11,
        height: 16.5 / 11,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
