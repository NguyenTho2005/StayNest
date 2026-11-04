import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design/tokens.dart';
import '../widgets/figma_asset.dart';

class PropertyReviewsListScreen extends StatefulWidget {
  const PropertyReviewsListScreen({super.key});
  @override
  State<PropertyReviewsListScreen> createState() =>
      _PropertyReviewsListScreenState();
}

class _PropertyReviewsListScreenState extends State<PropertyReviewsListScreen> {
  bool useful0 = false;
  bool useful1 = false;
  bool useful2 = false;
  bool useful3 = false;
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const bg = Color(0xFFF7F9FC);
  static const teal = StayNestColors.teal;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: bg,
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
                        : context.go(
                            '/properties/may-homestay/reviews/overview',
                          ),
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Center(
                        child: FigmaSvg(
                          'assets/icons/reviews_46_icon_11.svg',
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
                        'assets/icons/reviews_46_icon_12.svg',
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
                        'assets/icons/reviews_46_icon_13.svg',
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Row(
                children: [
                  InkWell(
                    onTap: () =>
                        context.push('/properties/may-homestay/reviews/filter'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        '☷  Bộ lọc (1 đang bật)',
                        style: TextStyle(fontSize: 12, color: teal),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Sắp xếp: Mới nhất⌄',
                    style: TextStyle(fontSize: 12, color: ink),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  _reviewCard(
                    initials: 'MT',
                    name: 'Minh Trang',
                    stay: 'Studio có bếp • 2 đêm',
                    date: 'Tháng 4/2026 (2 tuần trước)',
                    quote: 'Không gian cực kỳ ấm cúng và yên tĩnh, bếp riêng rất tiện lợi, chủ nhà thân thiện chu đáo. Nhất định sẽ giới thiệu bạn bè khi đến Hội An!',
                    useful: 8,
                    selected: useful0,
                    onUseful: () => setState(() => useful0 = !useful0),
                    featured: true,
                  ),
                  const SizedBox(height: 10),
                  _reviewCard(
                    initials: 'HL',
                    name: 'Hoàng Long',
                    stay: 'Studio có bếp • 3 đêm',
                    date: 'Tháng 3/2026',
                    quote: 'Vị trí gần phố cổ, đi lại tiện. Đèn mây và nội thất gỗ mộc rất có gu. Buổi tối ngồi ban công uống trà rất chill.',
                    useful: 5,
                    selected: useful1,
                    onUseful: () => setState(() => useful1 = !useful1),
                  ),
                  const SizedBox(height: 10),
                  _reviewCard(
                    initials: 'PA',
                    name: 'Phương Anh',
                    stay: 'Studio có bếp • 1 đêm',
                    date: 'Tháng 2/2026',
                    quote: 'Phòng ốc sạch sẽ, đầy đủ tiện nghi nấu nướng. Cách âm khá ổn, chủ nhà hỗ trợ gửi xe nhiệt tình. Sẽ quay lại.',
                    useful: 3,
                    selected: useful2,
                    onUseful: () => setState(() => useful2 = !useful2),
                    fourStars: true,
                  ),
                  const SizedBox(height: 10),
                  _reviewCard(
                    initials: 'TK',
                    name: 'Tuấn Kiệt',
                    stay: 'Studio có bếp • 2 đêm',
                    date: 'Tháng 1/2026',
                    quote: 'Trải nghiệm tuyệt vời, giường nệm êm ái, wifi mạnh làm việc từ xa mượt mà.',
                    useful: 12,
                    selected: useful3,
                    onUseful: () => setState(() => useful3 = !useful3),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Xem thêm 124 đánh giá ⌄',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: teal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF3FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'ⓘ  Dữ liệu đánh giá mang tính chất minh họa cho bản demo StayNest.',
                      style: TextStyle(fontSize: 11, color: muted),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _reviewCard({
    required String initials,
    required String name,
    required String stay,
    required String date,
    required String quote,
    required int useful,
    required bool selected,
    required VoidCallback onUseful,
    bool featured = false,
    bool fourStars = false,
  }) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (featured) ...[
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '4.9',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: teal,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '★★★★★',
                      style: TextStyle(fontSize: 16, color: Color(0xFFF79009)),
                    ),
                    Text(
                      'Dựa trên 128 lượt trải nghiệm',
                      style: TextStyle(fontSize: 11, color: muted),
                    ),
                  ],
                ),
              ),
              const Text(
                '100% Đã ở',
                style: TextStyle(fontSize: 11, color: teal),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFEAF7F6),
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: teal,
                ),
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
                    stay,
                    style: const TextStyle(fontSize: 11, color: muted),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  fourStars ? '★★★★☆' : '★★★★★',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFFF79009),
                  ),
                ),
                Text(date, style: const TextStyle(fontSize: 10, color: muted)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          quote,
          style: const TextStyle(fontSize: 12, height: 18 / 12, color: ink),
        ),
        if (featured) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              for (int i = 1; i <= 3; i++) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: FigmaRaster(
                    'assets/images/reviews_46_image_$i.jpg',
                    width: 88,
                    height: 70,
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '↪ Phản hồi từ Mây Homestay',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: teal,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Cảm ơn bạn Minh Trang nhiều nhé. Rất vui được đón tiếp bạn! Chúc bạn và gia đình luôn có nhiều hành trình vui vẻ.',
                  style: TextStyle(fontSize: 11, height: 16 / 11, color: muted),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: onUseful,
            child: Text(
              '♧ Hữu ích (${useful + (selected ? 1 : 0)})',
              style: TextStyle(fontSize: 11, color: selected ? teal : muted),
            ),
          ),
        ),
      ],
    ),
  );
}
