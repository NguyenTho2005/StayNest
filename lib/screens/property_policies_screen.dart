import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

class PropertyPoliciesScreen extends StatelessWidget {
  const PropertyPoliciesScreen({super.key});
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const teal = Color(0xFF006768);

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F9FC),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            Container(
              height: 44,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go('/properties/may-homestay/rooms/studio'),
                    icon: const Icon(Icons.arrow_back, size: 19),
                  ),
                  const Expanded(
                    child: Text(
                      'Room Selection',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                  ),
                  const Icon(Icons.share_outlined, size: 17, color: muted),
                  const SizedBox(width: 12),
                  const CircleAvatar(
                    radius: 11,
                    backgroundColor: teal,
                    child: Icon(
                      Icons.person_outline,
                      size: 13,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.home_outlined,
                              size: 19,
                              color: teal,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mây Homestay - Hội An  ✿',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: ink,
                                  ),
                                ),
                                Text(
                                  'Quy chuẩn và nội quy áp dụng cho tất cả khách lưu trú',
                                  style: TextStyle(
                                    fontSize: 10,
                                    height: 1.4,
                                    color: muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _heading('Thời gian nhận & trả phòng', 3),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _time('Nhận phòng', '14:00 - 22:00', 4),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _time('Trả phòng', 'Trước 12:00', 5),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(11),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF0FE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'ⓘ  Vui lòng thông báo trước nếu bạn nhận phòng sau 22:00. Hỗ trợ nhận phòng sớm nếu homestay có phòng sẵn sàng.',
                              style: TextStyle(
                                fontSize: 10,
                                height: 1.5,
                                color: muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _heading('Quy định lưu trú & Nội quy', 7),
                          const SizedBox(height: 12),
                          _rule(
                            'Không hút thuốc lá trong phòng',
                            'Chỉ hút tại khu vực sân vườn hoặc ban công ngoài trời có gạt tàn.',
                            8,
                          ),
                          _rule(
                            'Không mang theo thú cưng',
                            'Đảm bảo không gian thanh tĩnh và vệ sinh chung cho mọi khách lưu trú.',
                            9,
                          ),
                          _rule(
                            'Giờ yên tĩnh sau 22:00',
                            'Hạn chế tiếng ồn lớn nhằm tôn trọng giấc ngủ của cư dân phố cổ lân cận.',
                            10,
                          ),
                          _rule(
                            'Không tụ tập tiệc tùng đông người',
                            'Nghiêm cấm hoạt động tiệc vượt quá số lượng khách đăng ký ban đầu.',
                            11,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _heading('Trẻ em & Giường phụ', 12),
                          const SizedBox(height: 12),
                          _rule(
                            'Phù hợp và chào đón khách ở mọi độ tuổi.',
                            '',
                            13,
                          ),
                          _rule(
                            'Miễn phí cho trẻ dưới 6 tuổi nếu dùng chung giường sẵn có với bố mẹ.',
                            '',
                            14,
                          ),
                          _rule(
                            'Homestay không hỗ trợ thêm nệm phụ (extra bed) do cấu trúc thiết kế mộc mạc nguyên bản.',
                            '',
                            15,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _heading('Hủy phòng & Đặt cọc', 16),
                          const SizedBox(height: 12),
                          _rule(
                            'Áp dụng chính sách hủy linh hoạt theo khung giờ chuẩn hóa của StayNest.',
                            '',
                            17,
                          ),
                          _rule(
                            'Không thu tiền cọc mặt khi check-in, chỉ cần xuất trình CCCD hoặc Hộ chiếu gốc hợp lệ.',
                            '',
                            18,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    InkWell(
                      onTap: () => context.push(
                        '/properties/may-homestay/policies/refund',
                      ),
                      child: Container(
                        height: 46,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF7F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Xem chi tiết hủy & hoàn tiền  →',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: teal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Lưu ý: Chính sách và quy định trên là nội dung minh họa của dự án StayNest (Khách sạn & Homestay Việt Nam).',
                      style: TextStyle(
                        fontSize: 10,
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _card(Widget child) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: child,
  );
  Widget _heading(String text, int icon) => Row(
    children: [
      FigmaSvg(
        'assets/icons/policy_051_${icon.toString().padLeft(2, '0')}.svg',
        width: 17,
        height: 17,
      ),
      const SizedBox(width: 9),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ink,
          ),
        ),
      ),
    ],
  );
  Widget _time(String label, String value, int icon) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFF7F9FC),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FigmaSvg(
              'assets/icons/policy_051_${icon.toString().padLeft(2, '0')}.svg',
              width: 12,
              height: 12,
            ),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 10, color: muted)),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: ink,
          ),
        ),
      ],
    ),
  );
  Widget _rule(String title, String detail, int icon) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FigmaSvg(
          'assets/icons/policy_051_${icon.toString().padLeft(2, '0')}.svg',
          width: 16,
          height: 16,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: ink)),
              if (detail.isNotEmpty)
                Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.45,
                    color: muted,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
