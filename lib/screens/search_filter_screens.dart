import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design/tokens.dart';
import '../widgets/figma_asset.dart';
import '../widgets/figma_status_bar.dart';

class PricePropertyFilterScreen extends StatefulWidget {
  const PricePropertyFilterScreen({super.key});

  @override
  State<PricePropertyFilterScreen> createState() =>
      _PricePropertyFilterScreenState();
}

class _PricePropertyFilterScreenState extends State<PricePropertyFilterScreen> {
  RangeValues price = const RangeValues(500000, 1500000);
  String propertyType = 'Tất cả';

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: StayNestColors.canvas,
    body: Column(
      children: [
        const FigmaStatusBar(),
        _FilterHeader(title: 'Lọc kết quả', backIcon: 'filter_price_07.svg'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  decoration: _filterCard(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Ngân sách mỗi đêm', style: _heading),
                          ),
                          const FigmaSvg(
                            'assets/icons/filter_price_01.svg',
                            width: 18,
                            height: 14,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Giá phòng tiêu chuẩn cho 1 đêm nghỉ',
                        style: _helper,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 60,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children:
                              [
                                    9.6,
                                    16.8,
                                    28.8,
                                    40.8,
                                    60.0,
                                    36.0,
                                    43.2,
                                    24.0,
                                    14.4,
                                    7.2,
                                    4.8,
                                  ]
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 1.5,
                                        ),
                                        child: Container(
                                          height: entry.value,
                                          decoration: BoxDecoration(
                                            color:
                                                entry.key < 2 || entry.key > 7
                                                ? const Color(0xFFDFE9FC)
                                                : Color.fromRGBO(
                                                    0,
                                                    103,
                                                    104,
                                                    [
                                                      0.3,
                                                      0.6,
                                                      1.0,
                                                      1.0,
                                                      0.7,
                                                      0.5,
                                                    ][entry.key - 2],
                                                  ),
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(2),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                      RangeSlider(
                        min: 0,
                        max: 3000000,
                        divisions: 60,
                        values: price,
                        activeColor: StayNestColors.teal,
                        inactiveColor: const Color(0xFFDFE9FC),
                        onChanged: (value) => setState(() => price = value),
                      ),
                      Row(
                        children: [
                          _PriceValue(label: 'TỪ', value: _money(price.start)),
                          const SizedBox(width: 12),
                          _PriceValue(label: 'ĐẾN', value: _money(price.end)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text('Loại chỗ ở', style: _heading),
                      ),
                      const Text(
                        'Chọn 1',
                        style: TextStyle(
                          color: Color(0xFF4C5E83),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tùy biến không gian lưu trú cho phong cách du lịch của bạn',
                    style: _helper,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: _filterCard(),
                  child: Column(
                    children: [
                      _PropertyOption(
                        title: 'Tất cả',
                        subtitle:
                            'Hiển thị khách sạn, homestay và villa cao cấp',
                        badge: 'Đa dạng',
                        icon: 'filter_price_02.svg',
                        selected: propertyType == 'Tất cả',
                        onTap: () => setState(() => propertyType = 'Tất cả'),
                      ),
                      const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Color(0xFFE6EEFF),
                      ),
                      _PropertyOption(
                        title: 'Khách sạn',
                        subtitle: 'Phù hợp chuyến đi nghỉ dưỡng, công tác chuyên nghiệp',
                        icon: 'filter_price_03.svg',
                        selected: propertyType == 'Khách sạn',
                        onTap: () => setState(() => propertyType = 'Khách sạn'),
                      ),
                      const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Color(0xFFE6EEFF),
                      ),
                      _PropertyOption(
                        title: 'Homestay',
                        subtitle:
                            'Trải nghiệm không gian ấm cúng, đậm chất bản địa',
                        icon: 'filter_price_04.svg',
                        selected: propertyType == 'Homestay',
                        onTap: () => setState(() => propertyType = 'Homestay'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _FilterFooter(
          resetIcon: 'filter_price_05.svg',
          actionIcon: 'filter_price_06.svg',
          resetLabel: 'Đặt lại',
          actionLabel: 'Tiếp tục',
          onReset: () => setState(() {
            price = const RangeValues(0, 3000000);
            propertyType = 'Tất cả';
          }),
          onApply: () =>
              context.pop({'price': price, 'propertyType': propertyType}),
        ),
      ],
    ),
  );
}

class AmenityFilterScreen extends StatefulWidget {
  const AmenityFilterScreen({super.key});

  @override
  State<AmenityFilterScreen> createState() => _AmenityFilterScreenState();
}

class _AmenityFilterScreenState extends State<AmenityFilterScreen> {
  final selected = <String>{'Wi-Fi miễn phí', 'Điều hòa', 'Bếp nấu ăn'};
  static const items = [
    ('Wi-Fi miễn phí', 'filter_amenity_01.svg'),
    ('Điều hòa', 'filter_amenity_03.svg'),
    ('Bữa sáng', 'filter_amenity_04.svg'),
    ('Hồ bơi', 'filter_amenity_05.svg'),
    ('Bếp nấu ăn', 'filter_amenity_06.svg'),
    ('Chỗ đỗ xe', 'filter_amenity_07.svg'),
    ('Ban công', 'filter_amenity_08.svg'),
    ('Cho phép thú cưng', 'filter_amenity_09.svg'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: StayNestColors.canvas,
    body: Column(
      children: [
        const FigmaStatusBar(),
        _FilterHeader(title: 'Tiện nghi', backIcon: 'filter_amenity_12.svg'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Chọn tiện nghi bạn cần cho kỳ nghỉ',
                    style: TextStyle(
                      color: Color(0xFF3D4949),
                      fontSize: 14,
                      height: 22 / 14,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 116,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemBuilder: (context, index) {
                      final (label, icon) = items[index];
                      final isSelected = selected.contains(label);
                      return InkWell(
                        onTap: () => setState(
                          () => isSelected
                              ? selected.remove(label)
                              : selected.add(label),
                        ),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFEFF3FF)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0D172B4D),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: FigmaSvg(
                                      'assets/icons/$icon',
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? StayNestColors.teal
                                          : const Color(0xFFDFE9FC),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: isSelected
                                        ? const FigmaSvg(
                                            'assets/icons/filter_amenity_02.svg',
                                            width: 12,
                                            height: 10,
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  label,
                                  style: const TextStyle(
                                    color: Color(0xFF121C2A),
                                    fontSize: 14,
                                    height: 22 / 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 8),
                  child: Row(
                    children: [
                      const FigmaSvg(
                        'assets/icons/filter_amenity_10.svg',
                        width: 17,
                        height: 17,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Đã chọn ${selected.length} tiện nghi',
                        style: const TextStyle(
                          color: Color(0xFF3D4949),
                          fontSize: 14,
                          height: 22 / 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _FilterFooter(
          resetIcon: null,
          actionIcon: 'filter_amenity_11.svg',
          resetLabel: 'Đặt lại',
          actionLabel: 'Xem kết quả',
          onReset: () => setState(selected.clear),
          onApply: () => context.pop(selected.toList()),
        ),
      ],
    ),
  );
}

class _FilterHeader extends StatelessWidget {
  const _FilterHeader({required this.title, required this.backIcon});
  final String title;
  final String backIcon;

  @override
  Widget build(BuildContext context) => Container(
    height: 56,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: const BoxDecoration(
      color: Color(0xCCF8F9FF),
      boxShadow: [BoxShadow(color: Color(0x0A172B4D), blurRadius: 8)],
    ),
    child: Row(
      children: [
        InkWell(
          onTap: () => context.pop(),
          child: FigmaSvg('assets/icons/$backIcon', width: 18, height: 18),
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF121C2A),
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 36),
      ],
    ),
  );
}

class _PriceValue extends StatelessWidget {
  const _PriceValue({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF4C5E83),
              fontSize: 11,
              letterSpacing: .55,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF121C2A),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

class _PropertyOption extends StatelessWidget {
  const _PropertyOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.badge,
  });
  final String title, subtitle, icon;
  final String? badge;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? StayNestColors.teal : const Color(0xFFDFE9FC),
              shape: BoxShape.circle,
            ),
            child: selected
                ? const DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(width: 10, height: 10),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF121C2A),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (badge != null) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x1A006768),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            color: StayNestColors.teal,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF4C5E83),
                    fontSize: 12,
                    height: 18 / 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FigmaSvg('assets/icons/$icon', width: 20, height: 18),
        ],
      ),
    ),
  );
}

class _FilterFooter extends StatelessWidget {
  const _FilterFooter({
    required this.resetIcon,
    required this.actionIcon,
    required this.resetLabel,
    required this.actionLabel,
    required this.onReset,
    required this.onApply,
  });
  final String? resetIcon;
  final String actionIcon, resetLabel, actionLabel;
  final VoidCallback onReset, onApply;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
    decoration: const BoxDecoration(
      color: Color(0xE6F8F9FF),
      boxShadow: [
        BoxShadow(
          color: Color(0x0F172B4D),
          blurRadius: 8,
          offset: Offset(0, -1),
        ),
      ],
    ),
    child: Row(
      children: [
        TextButton.icon(
          onPressed: onReset,
          icon: resetIcon == null
              ? const SizedBox.shrink()
              : FigmaSvg('assets/icons/$resetIcon', width: 14, height: 16),
          label: Text(
            resetLabel,
            style: const TextStyle(
              color: Color(0xFF4C5E83),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: TextButton.styleFrom(
            fixedSize: const Size(72, 52),
            padding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: onApply,
              icon: Text(
                actionLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              label: FigmaSvg(
                'assets/icons/$actionIcon',
                width: 14,
                height: 14,
              ),
              style: FilledButton.styleFrom(
                backgroundColor: StayNestColors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

BoxDecoration _filterCard() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: const [
    BoxShadow(color: Color(0x0D172B4D), blurRadius: 2, offset: Offset(0, 1)),
  ],
);
String _money(double value) =>
    '${(value / 1000).round().toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')} .000đ'
        .replaceAll(' .000đ', '.000đ');

const _heading = TextStyle(
  color: Color(0xFF121C2A),
  fontSize: 16,
  height: 24 / 16,
  fontWeight: FontWeight.w600,
);
const _helper = TextStyle(
  color: Color(0xFF3D4949),
  fontSize: 12,
  height: 18 / 12,
);
