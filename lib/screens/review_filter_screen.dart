import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design/tokens.dart';
import '../widgets/figma_asset.dart';

class ReviewFilterScreen extends StatefulWidget {
  const ReviewFilterScreen({super.key});
  @override
  State<ReviewFilterScreen> createState() => _ReviewFilterScreenState();
}

class _ReviewFilterScreenState extends State<ReviewFilterScreen> {
  int rating = 0;
  bool photos = true;
  bool verified = true;
  bool hostReply = false;
  String period = 'Gần đây nhất (3 tháng qua)';
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const teal = StayNestColors.teal;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF1D5D6),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                width: 34,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9E2E3),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lọc đánh giá',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: ink,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Tìm các chia sẻ chân thực phù hợp nhất',
                            style: TextStyle(fontSize: 12, color: muted),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => context.canPop()
                          ? context.pop()
                          : context.go('/properties/may-homestay/reviews'),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE6EEFF),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: FigmaSvg(
                            'assets/icons/reviews_47_icon_01.svg',
                            width: 12,
                            height: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Xếp hạng sao',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ink,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '128 đánh giá',
                          style: TextStyle(fontSize: 12, color: muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _rating('Tất cả số sao', 0, 'Tất cả'),
                    const SizedBox(height: 8),
                    _rating('5 sao ★', 5, '98 đánh giá'),
                    const SizedBox(height: 8),
                    _rating('4 sao ★', 4, '24 đánh giá'),
                    const SizedBox(height: 8),
                    _rating('3 sao trở xuống', 3, '6 đánh giá'),
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        Text(
                          'Nội dung & Hình ảnh',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ink,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Tùy chọn độ tin cậy',
                          style: TextStyle(fontSize: 12, color: teal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _option(
                      'Chỉ hiển thị đánh giá có hình ảnh',
                      'Hình chụp không gian thực tế từ khách du lịch',
                      'reviews_47_icon_04.svg',
                      photos,
                      () => setState(() => photos = !photos),
                    ),
                    const SizedBox(height: 8),
                    _option(
                      'Đã xác thực lưu trú thực tế',
                      'Đặt phòng và hoàn tất thanh toán qua StayNest',
                      'reviews_47_icon_05.svg',
                      verified,
                      () => setState(() => verified = !verified),
                    ),
                    const SizedBox(height: 8),
                    _option(
                      'Có phản hồi từ chủ nhà',
                      'Bao gồm giải đáp và hỗ trợ từ homestay',
                      'reviews_47_icon_06.svg',
                      hostReply,
                      () => setState(() => hostReply = !hostReply),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Thời gian lưu trú',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Lọc trải nghiệm gần với chuyến đi của bạn',
                      style: TextStyle(fontSize: 12, color: muted),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          [
                                'Tất cả thời gian',
                                'Gần đây nhất (3 tháng qua)',
                                'Trong năm 2026',
                              ]
                              .map(
                                (label) => InkWell(
                                  onTap: () => setState(() => period = label),
                                  borderRadius: BorderRadius.circular(999),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 9,
                                    ),
                                    decoration: BoxDecoration(
                                      color: period == label
                                          ? const Color(0xFFEAF7F6)
                                          : const Color(0xFFEFF3FF),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      period == label ? '• $label' : label,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: period == label
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: period == label ? teal : muted,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF3FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          FigmaSvg(
                            'assets/icons/reviews_47_icon_07.svg',
                            width: 18,
                            height: 18,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Đang hiển thị 42 đánh giá chân thực phù hợp tiêu chí của bạn.',
                              style: TextStyle(
                                fontSize: 12,
                                height: 18 / 12,
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
              Container(
                height: 94,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x14172B4D),
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () => setState(() {
                        rating = 0;
                        photos = false;
                        verified = false;
                        hostReply = false;
                        period = 'Tất cả thời gian';
                      }),
                      child: const Text(
                        'Đặt lại',
                        style: TextStyle(fontSize: 14, color: muted),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: FilledButton(
                          onPressed: () => context.canPop()
                              ? context.pop()
                              : context.go('/properties/may-homestay/reviews'),
                          style: FilledButton.styleFrom(
                            backgroundColor: teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FigmaSvg(
                                'assets/icons/reviews_47_icon_08.svg',
                                width: 14,
                                height: 14,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Áp dụng bộ lọc',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _rating(String title, int value, String count) => InkWell(
    onTap: () => setState(() => rating = value),
    borderRadius: BorderRadius.circular(12),
    child: Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: rating == value
            ? const Color(0xFFEAF7F6)
            : const Color(0xFFEFF3FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: rating == value ? teal : const Color(0xFFDFE9FC),
              shape: BoxShape.circle,
            ),
            child: rating == value
                ? const Center(
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: rating == value ? FontWeight.w500 : FontWeight.w400,
                color: rating == value ? teal : ink,
              ),
            ),
          ),
          Text(
            count,
            style: TextStyle(
              fontSize: 12,
              color: rating == value ? teal : muted,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _option(
    String title,
    String subtitle,
    String icon,
    bool selected,
    VoidCallback onTap,
  ) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 3)],
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: selected ? teal : const Color(0xFFDFE9FC),
              borderRadius: BorderRadius.circular(6),
            ),
            child: selected
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: ink,
                        ),
                      ),
                    ),
                    FigmaSvg('assets/icons/$icon', width: 14, height: 14),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: muted),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
