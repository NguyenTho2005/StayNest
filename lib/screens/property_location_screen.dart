import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

class PropertyLocationScreen extends StatelessWidget {
  const PropertyLocationScreen({super.key});

  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const teal = Color(0xFF006768);
  static const pale = Color(0xFFEAF7F6);

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F9FC),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            Container(
              height: 56,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go('/properties/may-homestay'),
                    icon: const Icon(Icons.arrow_back, size: 20),
                  ),
                  const Expanded(
                    child: Text(
                      'Chi Tiết Chỗ Nghỉ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                  ),
                  const Icon(Icons.share_outlined, color: muted, size: 19),
                  const SizedBox(width: 16),
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: teal,
                    child: Icon(
                      Icons.person_outline,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _map(),
                    const SizedBox(height: 16),
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: 18,
                                backgroundColor: pale,
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: teal,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ĐỊA CHỈ CHI TIẾT',
                                      style: TextStyle(
                                        fontSize: 10,
                                        letterSpacing: 1,
                                        color: muted,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Phường Cẩm Hà, TP. Hội An, Tỉnh Quảng Nam',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: ink,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.copy_outlined,
                                size: 16,
                                color: muted,
                              ),
                            ],
                          ),
                          const Divider(height: 28, color: Color(0xFFE6EEFF)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: 18,
                                backgroundColor: Color(0xFFE6EEFF),
                                child: Icon(
                                  Icons.navigation_outlined,
                                  color: teal,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Khoảng cách trung tâm   1.2 km',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: ink,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Cách phố cổ Hội An 1.2 km (khoảng 5 phút đi xe máy, 15 phút đi bộ).',
                                      style: TextStyle(
                                        fontSize: 11,
                                        height: 1.5,
                                        color: muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F9FC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '♧   Khu dân cư yên tĩnh, gần sông và cánh đồng hoa, thuận tiện di chuyển cả ra biển An Bàng và vào trung tâm phố cổ.',
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.5,
                                color: muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                'Điểm tham quan lân cận',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ink,
                                ),
                              ),
                              Spacer(),
                              Text(
                                '5 địa điểm',
                                style: TextStyle(fontSize: 11, color: muted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _place(
                            Icons.account_balance_outlined,
                            'Chùa Cầu Hội An',
                            'Di tích văn hóa lịch sử',
                            '1.4 km (6 ph)',
                          ),
                          _place(
                            Icons.shopping_bag_outlined,
                            'Chợ đêm Hội An & Phố đi bộ',
                            'Ẩm thực đường phố, đèn lồng',
                            '1.6 km (7 ph)',
                          ),
                          _place(
                            Icons.wb_sunny_outlined,
                            'Bãi biển An Bàng',
                            'Bãi tắm tự nhiên, quán cafe bờ biển',
                            '3.5 km (10 ph)',
                          ),
                          _place(
                            Icons.eco_outlined,
                            'Làng rau Trà Quế',
                            'Trải nghiệm nông nghiệp sinh thái',
                            '2.1 km (8 ph xe đạp)',
                          ),
                          _place(
                            Icons.flight_outlined,
                            'Sân bay Quốc tế Đà Nẵng',
                            'Điểm kết nối hàng không chính',
                            '28 km (45 ph taxi)',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: pale,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.lightbulb_outline,
                              color: teal,
                              size: 18,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mẹo di chuyển từ Mây Homestay',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: teal,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Homestay có sẵn xe đạp miễn phí cho khách lưu trú dạo phố cổ bất cứ lúc nào. Buổi sáng sớm và chiều tà là thời điểm đạp xe ngắm cánh đồng đẹp nhất!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.6,
                                    color: ink,
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
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.near_me_outlined),
                  label: const Text('Chỉ đường (Mô phỏng)'),
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: teal,
                    disabledForegroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _map() => ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: SizedBox(
      height: 320,
      child: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: Color(0xFFF4F8F6))),
          const Positioned.fill(
            child: FigmaSvg(
              'assets/images/location_map_base.svg',
              width: 350,
              height: 320,
            ),
          ),
          const Positioned(
            left: -20,
            top: 0,
            child: FigmaSvg(
              'assets/images/location_map_park.svg',
              width: 370,
              height: 65,
            ),
          ),
          const Positioned.fill(
            child: FigmaSvg(
              'assets/images/location_map_layer1.svg',
              width: 355,
              height: 325,
            ),
          ),
          const Positioned.fill(
            child: FigmaSvg(
              'assets/images/location_map_layer2.svg',
              width: 353,
              height: 323,
            ),
          ),
          const Positioned(
            left: 60,
            top: 0,
            child: FigmaSvg(
              'assets/images/location_map_road1.svg',
              width: 150,
              height: 320,
            ),
          ),
          const Positioned(
            left: 60,
            top: 0,
            child: FigmaSvg(
              'assets/images/location_map_road2.svg',
              width: 150,
              height: 320,
            ),
          ),
          const Positioned(
            left: 0,
            top: 185,
            child: FigmaSvg(
              'assets/images/location_map_road3.svg',
              width: 350,
              height: 30,
            ),
          ),
          const Positioned(
            left: 0,
            top: 185,
            child: FigmaSvg(
              'assets/images/location_map_road4.svg',
              width: 350,
              height: 30,
            ),
          ),
          const Positioned(
            left: 0,
            bottom: 0,
            child: FigmaSvg(
              'assets/images/location_map_water2.svg',
              width: 120,
              height: 95,
            ),
          ),
          const Positioned(
            right: -20,
            bottom: 10,
            child: FigmaSvg(
              'assets/images/location_map_water1.svg',
              width: 120,
              height: 132,
            ),
          ),
          const Positioned(
            bottom: 18,
            left: 18,
            child: Text(
              'Hội An, Quảng Nam • Phường Cẩm Hà',
              style: TextStyle(
                fontSize: 10,
                color: ink,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          const Positioned(
            top: 34,
            left: 20,
            child: Text(
              'VƯỜN HOA CẨM HÀ',
              style: TextStyle(fontSize: 8, color: Color(0xFF569E7A)),
            ),
          ),
          const Positioned(
            bottom: 28,
            right: 18,
            child: Text(
              'SÔNG THU BỒN',
              style: TextStyle(fontSize: 8, color: Color(0xFF5E9DBB)),
            ),
          ),
          Center(
            child: Container(
              width: 176,
              height: 176,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1A006768),
              ),
              child: Center(
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x26006768),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    '● Mây Homestay   ★ 4.9',
                    style: TextStyle(
                      fontSize: 11,
                      color: teal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: teal,
                  child: Icon(Icons.home, color: Colors.white, size: 21),
                ),
              ],
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: Column(
              children: [
                for (final icon in [Icons.add, Icons.remove, Icons.my_location])
                  Container(
                    width: 40,
                    height: 42,
                    margin: const EdgeInsets.only(bottom: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 18, color: ink),
                  ),
              ],
            ),
          ),
          const Positioned(
            left: 76,
            top: 106,
            child: Text(
              '♧ Trà Quế',
              style: TextStyle(
                fontSize: 11,
                color: muted,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          const Positioned(
            left: 171,
            bottom: 54,
            child: Text(
              '♧ Chùa Cầu',
              style: TextStyle(
                fontSize: 11,
                color: muted,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _card(Widget child) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: child,
  );

  Widget _place(IconData icon, String title, String detail, String distance) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF0FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: ink, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: ink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    detail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, color: muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Text(distance, style: const TextStyle(fontSize: 10, color: ink)),
          ],
        ),
      );
}
