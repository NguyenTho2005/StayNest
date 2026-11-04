import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design/tokens.dart';
import '../widgets/figma_asset.dart';

class PropertyAmenitiesScreen extends StatelessWidget {
  const PropertyAmenitiesScreen({super.key});
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const background = Color(0xFFF7F9FC);
  static const pale = Color(0xFFEAF7F6);

  static const bedroom = [
    (
      'Giường đôi cỡ Queen',
      'Đệm cao su non thiên nhiên, ga trải cotton lụa',
      'amenities_03.svg',
      16.667,
      11.667,
    ),
    (
      'Điều hòa hai chiều Inverter',
      'Lọc khí êm ái, chủ động điều chỉnh nhiệt độ',
      'amenities_04.svg',
      16.667,
      16.667,
    ),
    (
      'Tủ quần áo & móc treo gỗ',
      'Gỗ sồi mộc tự nhiên kèm ngăn bảo quản đồ',
      'amenities_05.svg',
      16.667,
      13.333,
    ),
    (
      'Bàn làm việc & ghế tựa mây',
      'Thích hợp làm việc từ xa kết hợp ánh sáng tự nhiên',
      'amenities_06.svg',
      16.667,
      10.0,
    ),
  ];
  static const kitchen = [
    (
      'Bếp riêng đầy đủ dụng cụ nấu nướng',
      'Chảo, nồi, bát đĩa gốm sứ mộc và gia vị cơ bản',
      'amenities_08.svg',
      17.75,
      14.167,
    ),
    (
      'Tủ lạnh mini 90L',
      'Ngăn đá riêng bảo quản tươi mát nước giải khát',
      'amenities_09.svg',
      14.167,
      16.667,
    ),
    (
      'Ấm siêu tốc & bộ ấm trà gốm',
      'Bộ ấm trà thủ công làng nghề kèm trà thảo mộc',
      'amenities_10.svg',
      13.333,
      16.667,
    ),
  ];
  static const personal = [
    (
      'Wi-Fi tốc độ cao 100 Mbps (miễn phí)',
      'Phủ sóng toàn bộ khuôn viên phòng và sân vườn',
      'amenities_12.svg',
      20.0,
      14.167,
    ),
    (
      'Máy sấy tóc ion âm',
      'Bảo vệ tóc, công suất mạnh 1800W',
      'amenities_13.svg',
      16.667,
      14.167,
    ),
    (
      'Bàn ủi hơi nước cầm tay',
      'Dễ dàng là phẳng trang phục trước khi dạo phố',
      'amenities_14.svg',
      16.667,
      10.0,
    ),
    (
      'Chỗ đỗ xe máy miễn phí',
      'Khuôn viên có mái che, an ninh có camera 24/7',
      'amenities_15.svg',
      20.0,
      11.667,
    ),
  ];
  static const rules = [
    (
      'Không hút thuốc trong phòng',
      'Khu vực hút thuốc chỉ áp dụng tại sân vườn ngoài trời',
      'amenities_17.svg',
      17.167,
      17.167,
    ),
    (
      'Không mang theo thú cưng',
      'Đảm bảo không gian nghỉ ngơi yên tĩnh và hạn chế dị ứng',
      'amenities_18.svg',
      16.667,
      15.833,
    ),
    (
      'Nhận phòng: 14:00 • Trả phòng: 12:00',
      'Hỗ trợ giữ hành lý trước giờ check-in nếu có thông báo',
      'amenities_19.svg',
      16.667,
      16.667,
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: background,
    bottomNavigationBar: Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14172B4D),
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Giá chỉ từ',
                  style: TextStyle(fontSize: 11, color: muted),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '750.000đ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: StayNestColors.teal,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text('/đêm', style: TextStyle(fontSize: 12, color: muted)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: () => context.push('/properties/may-homestay/rooms'),
              style: FilledButton.styleFrom(
                disabledBackgroundColor: StayNestColors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Chọn phòng',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  FigmaSvg(
                    'assets/icons/amenities_21.svg',
                    width: 12,
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
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
                          'assets/icons/amenities_22.svg',
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Text(
                      'Chọn Phòng Và Đặt Chỗ',
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
                        'assets/icons/amenities_23.svg',
                        width: 15,
                        height: 16.667,
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: StayNestColors.teal,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: FigmaSvg(
                        'assets/icons/amenities_24.svg',
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
                  const Row(
                    children: [
                      FigmaSvg(
                        'assets/icons/amenities_01.svg',
                        width: 14.667,
                        height: 13.333,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Mây Homestay • Hội An',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tiện nghi chỗ ở',
                    style: TextStyle(
                      fontSize: 20,
                      height: 26 / 20,
                      fontWeight: FontWeight.w600,
                      color: ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Được trang bị đầy đủ để mang lại cảm giác thoải mái, yên ả như tại nhà',
                    style: TextStyle(
                      fontSize: 12,
                      height: 18 / 12,
                      color: muted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _group(
                    'Phòng & Giường ngủ',
                    '4 tiện nghi',
                    'amenities_02.svg',
                    15,
                    10.5,
                    bedroom,
                  ),
                  const SizedBox(height: 16),
                  _group(
                    'Bếp & Ăn uống',
                    '3 tiện nghi',
                    'amenities_07.svg',
                    15.975,
                    12.75,
                    kitchen,
                  ),
                  const SizedBox(height: 16),
                  _group(
                    'Kết nối & Tiện ích cá nhân',
                    '4 tiện nghi',
                    'amenities_11.svg',
                    18,
                    12.75,
                    personal,
                  ),
                  const SizedBox(height: 16),
                  _group(
                    'Quy định chung & Lưu ý',
                    'Lưu tâm',
                    'amenities_16.svg',
                    12,
                    15,
                    rules,
                    warning: true,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: pale,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        FigmaSvg(
                          'assets/icons/amenities_20.svg',
                          width: 17,
                          height: 17,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cần thêm tiện nghi đặc biệt?',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: StayNestColors.teal,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Homestay có dịch vụ thuê xe đạp dạo phố cổ và nôi em bé miễn phí khi yêu cầu trước.',
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 18 / 12,
                                  color: muted,
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
          ],
        ),
      ),
    ),
  );

  Widget _group(
    String title,
    String count,
    String icon,
    double width,
    double height,
    List<(String, String, String, double, double)> items, {
    bool warning = false,
  }) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: warning ? const Color(0xFFDFE9FC) : pale,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FigmaSvg(
                  'assets/icons/$icon',
                  width: width,
                  height: height,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  height: 24 / 16,
                  fontWeight: FontWeight.w600,
                  color: ink,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: warning ? const Color(0x1AF79009) : background,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                count,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: warning ? const Color(0xFFF79009) : muted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        for (final item in items) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: warning ? const Color(0x99FFDAD6) : pale,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: FigmaSvg(
                    'assets/icons/${item.$3}',
                    width: item.$4,
                    height: item.$5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.$1,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 22 / 14,
                        fontWeight: FontWeight.w500,
                        color: ink,
                      ),
                    ),
                    Text(
                      item.$2,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 18 / 12,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
        ],
      ],
    ),
  );
}
