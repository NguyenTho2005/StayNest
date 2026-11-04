import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design/tokens.dart';
import '../widgets/figma_asset.dart';

class PropertyReviewsOverviewScreen extends StatelessWidget {
  const PropertyReviewsOverviewScreen({super.key});
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const background = Color(0xFFF7F9FC);
  static const teal = StayNestColors.teal;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: background,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.white,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go('/properties/may-homestay'),
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Center(
                        child: FigmaSvg(
                          'assets/icons/reviews_45_icon_13.svg',
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Text(
                      'Chi Tiết Chỗ Nghỉ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: StayNestColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: FigmaSvg(
                        'assets/icons/reviews_45_icon_14.svg',
                        width: 15,
                        height: 16.667,
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: teal,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: FigmaSvg(
                        'assets/icons/reviews_45_icon_15.svg',
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF7F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        FigmaSvg(
                          'assets/icons/reviews_45_icon_01.svg',
                          width: 18,
                          height: 18,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Đánh giá xác thực 100%',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ink,
                                ),
                              ),
                              Text(
                                'Khách hàng thực tế sau kỳ lưu trú',
                                style: TextStyle(fontSize: 11, color: muted),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'StayNest Verified',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 110,
                          child: Column(
                            children: [
                              Text(
                                '4.8',
                                style: TextStyle(
                                  fontSize: 36,
                                  height: 1.1,
                                  fontWeight: FontWeight.w700,
                                  color: ink,
                                ),
                              ),
                              Text(
                                '★★★★★',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFFF79009),
                                ),
                              ),
                              Text(
                                '128 đánh giá',
                                style: TextStyle(fontSize: 11, color: muted),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            children: [
                              for (final row in [
                                ('5', 105, .82),
                                ('4', 18, .15),
                                ('3', 4, .04),
                                ('2', 1, .02),
                                ('1', 0, 0.0),
                              ])
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      Text(
                                        row.$1,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: ink,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                          child: LinearProgressIndicator(
                                            value: row.$3,
                                            minHeight: 6,
                                            backgroundColor: const Color(
                                              0xFFDFE9FC,
                                            ),
                                            color: teal,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      SizedBox(
                                        width: 22,
                                        child: Text(
                                          '${row.$2}',
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: muted,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Text(
                        'Tiêu chí chi tiết',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ink,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Rất ấn tượng',
                        style: TextStyle(fontSize: 12, color: teal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _criterion(
                          'Sạch sẽ',
                          '4.9',
                          'reviews_45_icon_03.svg',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _criterion(
                          'Vị trí',
                          '4.8',
                          'reviews_45_icon_04.svg',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _criterion(
                          'Dịch vụ chủ nhà',
                          '4.9',
                          'reviews_45_icon_05.svg',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _criterion(
                          'Giá trị nhận được',
                          '4.7',
                          'reviews_45_icon_06.svg',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text(
                        'Nhận xét tiêu biểu',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ink,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '2 trên 128',
                        style: TextStyle(fontSize: 12, color: muted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _review(
                    'MT',
                    'Minh Trang',
                    'Tháng 4/2026',
                    '“Không gian cực kỳ ấm cúng và yên tĩnh, bếp riêng rất tiện lợi, chủ nhà thân thiện chu đáo. Chắc chắn sẽ quay lại khi có dịp ra Hà Nội.”',
                    'Phòng Ban Công Mây',
                    '3 đêm',
                  ),
                  const SizedBox(height: 10),
                  _review(
                    'HL',
                    'Hoàng Long',
                    'Tháng 3/2026',
                    '“Vị trí gần phố cổ, đi lại tiện. Đèn mây và nội thất gỗ mộc rất có gu và tỉ mỉ. Thích nhất là không gian thưởng trà sáng yên tĩnh trên sân thượng.”',
                    'Studio Gỗ Mộc',
                    '2 đêm',
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6EEFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        FigmaSvg(
                          'assets/icons/reviews_45_icon_11.svg',
                          width: 18,
                          height: 18,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '96% khách khuyên nên lưu trú tại đây',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: ink,
                                ),
                              ),
                              Text(
                                'Dựa trên các chuyến đi hoàn tất 6 tháng qua',
                                style: TextStyle(fontSize: 11, color: muted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () =>
                        context.push('/properties/may-homestay/reviews'),
                    child: Container(
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Xem tất cả 128 đánh giá →',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: teal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Mọi đánh giá đều từ khách hàng thực tế sau khi hoàn tất kỳ nghỉ (Mô phỏng demo)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _criterion(String title, String rating, String icon) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FigmaSvg('assets/icons/$icon', width: 16, height: 16),
            const Spacer(),
            Text(
              rating,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(fontSize: 12, color: ink)),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: const LinearProgressIndicator(
            value: .94,
            minHeight: 5,
            backgroundColor: Color(0xFFDFE9FC),
            color: teal,
          ),
        ),
      ],
    ),
  );

  Widget _review(
    String initials,
    String name,
    String date,
    String quote,
    String room,
    String nights,
  ) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFEAF7F6),
              child: Text(
                initials,
                style: const TextStyle(fontSize: 12, color: teal),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ink,
                    ),
                  ),
                  Text(
                    'Đã lưu trú • $date',
                    style: const TextStyle(fontSize: 11, color: muted),
                  ),
                ],
              ),
            ),
            const Text(
              '★★★★★',
              style: TextStyle(fontSize: 16, color: Color(0xFFF79009)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          quote,
          style: const TextStyle(fontSize: 12, height: 18 / 12, color: ink),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                room,
                style: const TextStyle(fontSize: 11, color: muted),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                nights,
                style: const TextStyle(fontSize: 11, color: muted),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
