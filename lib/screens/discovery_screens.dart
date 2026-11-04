import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/staynest_api.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/figma_asset.dart';
import '../widgets/figma_status_bar.dart';

class DestinationsScreen extends StatefulWidget {
  const DestinationsScreen({super.key});
  @override
  State<DestinationsScreen> createState() => _DestinationsScreenState();
}

class _DestinationsScreenState extends State<DestinationsScreen> {
  String region = 'Tất cả';
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    bottomNavigationBar: const StayNestBottomNavigation(selectedIndex: 0),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            const FigmaStatusBar(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Khám phá điểm đến',
                    style: TextStyle(
                      color: Color(0xFF172B4D),
                      fontSize: 22,
                      height: 1.3,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tìm nơi dừng chân cho chuyến đi tiếp theo',
                    style: TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: ['Tất cả', 'Miền Bắc', 'Miền Trung', 'Miền Nam']
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(item),
                          selected: region == item,
                          onSelected: (_) => setState(() => region = item),
                          selectedColor: const Color(0xFFEAF7F6),
                          backgroundColor: const Color(0xFFF8F9FC),
                          side: BorderSide(
                            color: region == item
                                ? const Color(0xFF0F8B8D)
                                : const Color(0xFFE5E7EB),
                          ),
                          labelStyle: TextStyle(
                            color: region == item
                                ? const Color(0xFF006768)
                                : const Color(0xFF667085),
                            fontSize: 12,
                            fontWeight: region == item
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          showCheckmark: false,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Miền Trung',
                          style: TextStyle(
                            color: Color(0xFF172B4D),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Xem tất cả',
                          style: TextStyle(
                            color: Color(0xFF0F8B8D),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _DestinationCard(
                      image: 'assets/images/destinations_image_01.jpg',
                      tag: 'Miền Trung',
                      name: 'Đà Nẵng',
                      description: 'Thành phố biển đáng…',
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Text(
                          'Khám phá theo phong cách',
                          style: TextStyle(
                            color: Color(0xFF172B4D),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StyleTile(
                            image: 'assets/images/destinations_image_02.jpg',
                            category: 'Di sản',
                            name: 'Hội An',
                            subtitle: 'Phố cổ di sản & mộc mạc',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StyleTile(
                            image: 'assets/images/destinations_image_03.jpg',
                            category: 'Nghỉ dưỡng',
                            name: 'Đà Lạt',
                            subtitle: 'Cao nguyên ngàn hoa',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _DestinationCard(
                      image: 'assets/images/destinations_image_04.jpg',
                      tag: 'Biển đảo',
                      name: 'Nha Trang',
                      description: 'Vịnh biển nhiệt đới',
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Dữ liệu địa điểm minh họa cho bản demo StayNest',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF98A2B3),
                        fontSize: 10,
                        height: 1.5,
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
}

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF8F9FC),
    bottomNavigationBar: const StayNestBottomNavigation(selectedIndex: 0),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            const FigmaStatusBar(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    child: const FigmaSvg(
                      'assets/icons/offers_icon_01.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Ưu đãi',
                    style: TextStyle(
                      color: Color(0xFF172B4D),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        FigmaSvg(
                          'assets/icons/offers_icon_03.svg',
                          width: 13,
                          height: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'CHƯƠNG TRÌNH ĐẶC QUYỀN',
                          style: TextStyle(
                            color: Color(0xFF9C3F20),
                            fontSize: 11,
                            letterSpacing: .55,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Ưu đãi cuối tuần',
                      style: TextStyle(
                        color: Color(0xFF121C2A),
                        fontSize: 24,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Khám phá lựa chọn lưu trú cho kỳ nghỉ của bạn',
                      style: TextStyle(
                        color: Color(0xFF3D4949),
                        fontSize: 14,
                        height: 22 / 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF3FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF9C3F20),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'STAY100',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: .6,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const FigmaSvg(
                                      'assets/icons/offers_icon_04.svg',
                                      width: 13,
                                      height: 12,
                                    ),
                                    const SizedBox(width: 3),
                                    const Text(
                                      'Hợp lệ',
                                      style: TextStyle(
                                        color: Color(0xFF006768),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Giảm 100.000đ cho đơn từ 1.500.000đ',
                                  style: TextStyle(
                                    color: Color(0xFF121C2A),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  'Áp dụng cho đặt phòng từ 14–16/11/2026',
                                  style: TextStyle(
                                    color: Color(0xFF3D4949),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () => ScaffoldMessenger.of(context)
                                .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Lưu mã ưu đãi chưa được kết nối.',
                                    ),
                                  ),
                                ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFD9E3F6),
                              foregroundColor: const Color(0xFF006768),
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              minimumSize: const Size(0, 40),
                            ),
                            child: const Row(
                              children: [
                                FigmaSvg(
                                  'assets/icons/offers_icon_05.svg',
                                  width: 12,
                                  height: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Lưu mã',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '* Ưu đãi minh họa cho bản demo. Giá phòng và mức giảm giả lập.',
                      style: TextStyle(
                        color: Color(0xFF3D4949),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        height: 18 / 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Text(
                          'Ưu đãi dành cho bạn',
                          style: TextStyle(
                            color: Color(0xFF172B4D),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Xem tất cả',
                          style: TextStyle(
                            color: Color(0xFF0F8B8D),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAF7F6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'STAY100',
                                  style: TextStyle(
                                    color: Color(0xFF006768),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                'Hợp lệ',
                                style: TextStyle(
                                  color: Color(0xFF12B76A),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Giảm 100.000đ cho đơn từ 1.500.000đ',
                            style: TextStyle(
                              color: Color(0xFF172B4D),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Áp dụng cho đặt phòng từ 14–16/11/2026',
                            style: TextStyle(
                              color: Color(0xFF667085),
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton(
                              onPressed: null,
                              child: const Text('Lưu mã'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: [
                        _OfferChip('Dưới 1 triệu'),
                        _OfferChip('Giảm 10%'),
                        _OfferChip('Ở 2 đêm'),
                        _OfferChip('Hủy miễn phí'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Chỗ ở đang có ưu đãi',
                      style: TextStyle(
                        color: Color(0xFF172B4D),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _OfferStayCard(
                      image: 'assets/images/offers_image_01.jpg',
                      location: 'Hội An, Quảng Nam',
                      title: 'Mây Homestay',
                      kind: 'Homestay',
                      rating: '4.8 (128)',
                      price: '850.000đ',
                      note: 'Áp dụng mã STAY100 giảm 100.000đ',
                    ),
                    const SizedBox(height: 12),
                    _OfferStayCard(
                      image: 'assets/images/offers_image_02.jpg',
                      location: 'Đà Nẵng · Cách biển Mỹ Khê 200m',
                      title: 'Ocean Pearl Hotel',
                      kind: 'Khách sạn 4 sao',
                      rating: '4.8 (214)',
                      price: '1.250.000đ',
                      note: 'Ưu đãi tặng bữa sáng & đưa đón sân bay',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Điều kiện áp dụng',
                      style: TextStyle(
                        color: Color(0xFF172B4D),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _OfferRule(
                      'Mã STAY100 áp dụng cho đơn đặt phòng có giá trị từ 1.500.000đ trở lên.',
                    ),
                    const _OfferRule(
                      'Mức giảm STAY100 tính trên tổng đơn hàng, không giảm trực tiếp vào đơn giá theo đêm.',
                    ),
                    const _OfferRule(
                      'Không áp dụng đồng thời với các chương trình giảm giá sự kiện khác.',
                    ),
                    const _OfferRule(
                      'Chính sách hoàn hủy: Hủy miễn phí trước 18:00, 12/11/2026.',
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '* Ưu đãi minh họa cho bản demo. Giá phòng và mức giảm giả lập.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF98A2B3),
                        fontSize: 10,
                        height: 1.5,
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
}

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});
  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  String style = 'Biển';
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF8F9FC),
    bottomNavigationBar: const StayNestBottomNavigation(selectedIndex: 0),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            const FigmaStatusBar(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Dành cho bạn',
                    style: TextStyle(
                      color: Color(0xFF172B4D),
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Khám phá chỗ ở theo phong cách của bạn',
                    style: TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: ['Biển', 'Núi', 'Yên tĩnh', 'Di sản']
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(item),
                          selected: style == item,
                          onSelected: (_) => setState(() => style = item),
                          selectedColor: const Color(0xFFEAF7F6),
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: style == item
                                ? const Color(0xFF0F8B8D)
                                : const Color(0xFFE5E7EB),
                          ),
                          labelStyle: TextStyle(
                            color: style == item
                                ? const Color(0xFF006768)
                                : const Color(0xFF667085),
                            fontSize: 12,
                          ),
                          showCheckmark: false,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  children: [
                    _RecommendedStayCard(
                      image: 'assets/images/recommendations_image_01.jpg',
                      place: 'Hội An',
                      rating: '4.8',
                      name: 'Mây Homestay',
                      features: 'Bếp riêng · Wifi',
                      price: '850.000đ',
                    ),
                    _RecommendedStayCard(
                      image: 'assets/images/recommendations_image_02.jpg',
                      place: 'Đà Nẵng',
                      rating: '4.8',
                      name: 'Ocean Pearl Hotel',
                      features: 'Gần biển · Hồ bơi',
                      price: '1.250.000đ',
                    ),
                    _RecommendedStayCard(
                      image: 'assets/images/recommendations_image_03.jpg',
                      place: 'Hội An',
                      rating: '4.7',
                      name: 'An Villa',
                      features: 'Sân vườn · Yên tĩnh',
                      price: '980.000đ',
                    ),
                    _RecommendedStayCard(
                      image: 'assets/images/recommendations_image_04.jpg',
                      place: 'Đà Lạt',
                      rating: '4.9',
                      name: 'Pine House',
                      features: 'Lò sưởi · Ban công',
                      price: '920.000đ',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Đang hiển thị chỗ ở phù hợp nhất với sở thích du lịch $style và thư giãn.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF667085),
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Dữ liệu gợi ý và điểm đánh giá mang tính chất minh họa DEMO.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF98A2B3),
                        fontSize: 10,
                        height: 1.5,
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
}

class _DestinationCard extends ConsumerWidget {
  const _DestinationCard({
    required this.image,
    required this.tag,
    required this.name,
    required this.description,
  });
  final String image, tag, name, description;
  @override
  Widget build(BuildContext context, WidgetRef ref) => ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: InkWell(
      onTap: () {
        if (name == 'Đà Nẵng') {
          context.push('/destinations/da-nang');
        } else if (name == 'Hội An') {
          ref.read(bookingDraftProvider).destinationSlug = 'hoi-an';
          context.push('/search/results');
        } else if (name == 'Đà Lạt') {
          ref.read(bookingDraftProvider).destinationSlug = 'da-lat';
          context.push('/search/results');
        } else {
          context.push('/search/results');
        }
      },
      child: Stack(
        children: [
          FigmaRaster(image, width: double.infinity, height: 182),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, const Color(0xB3000000)],
                ),
              ),
            ),
          ),
          Positioned(left: 12, top: 12, child: _LabelPill(tag)),
          Positioned(
            left: 14,
            bottom: 13,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          Positioned(
            right: 12,
            bottom: 14,
            child: _RoundAction(label: 'Khám phá'),
          ),
        ],
      ),
    ),
  );
}

class _StyleTile extends ConsumerWidget {
  const _StyleTile({
    required this.image,
    required this.category,
    required this.name,
    required this.subtitle,
  });
  final String image, category, name, subtitle;
  @override
  Widget build(BuildContext context, WidgetRef ref) => ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: InkWell(
      onTap: () {
        if (name == 'Hội An') {
          ref.read(bookingDraftProvider).destinationSlug = 'hoi-an';
          context.push('/search/results');
        } else if (name == 'Đà Lạt') {
          ref.read(bookingDraftProvider).destinationSlug = 'da-lat';
          context.push('/search/results');
        } else if (name == 'Đà Nẵng') {
          context.push('/destinations/da-nang');
        } else {
          context.push('/search/results');
        }
      },
      child: Stack(
        children: [
          FigmaRaster(image, width: double.infinity, height: 186),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, const Color(0xC9000000)],
                ),
              ),
            ),
          ),
          Positioned(left: 10, top: 10, child: _LabelPill(category)),
          Positioned(
            left: 11,
            right: 8,
            bottom: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                const SizedBox(height: 6),
                const _RoundAction(label: 'Khám phá'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _LabelPill extends StatelessWidget {
  const _LabelPill(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Color(0xFF172B4D),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF172B4D),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4),
        const FigmaSvg(
          'assets/icons/destinations_icon_05.svg',
          width: 10,
          height: 10,
        ),
      ],
    ),
  );
}

class _OfferChip extends StatelessWidget {
  const _OfferChip(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFE4E7EC)),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      text,
      style: const TextStyle(color: Color(0xFF475467), fontSize: 11),
    ),
  );
}

class _OfferStayCard extends StatelessWidget {
  const _OfferStayCard({
    required this.image,
    required this.location,
    required this.title,
    required this.kind,
    required this.rating,
    required this.price,
    required this.note,
  });
  final String image, location, title, kind, rating, price, note;
  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFE5E7EB)),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            FigmaRaster(image, width: double.infinity, height: 145),
            Positioned(
              left: 10,
              top: 10,
              child: _LabelPill('Ưu đãi cuối tuần'),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const FigmaSvg(
                  'assets/icons/offers_icon_07.svg',
                  width: 16,
                  height: 16,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location,
                style: const TextStyle(color: Color(0xFF667085), fontSize: 11),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF172B4D),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '★ $rating',
                    style: const TextStyle(
                      color: Color(0xFF344054),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                kind,
                style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 11),
              ),
              const SizedBox(height: 8),
              Text(
                note,
                style: const TextStyle(
                  color: Color(0xFF006768),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      color: Color(0xFF172B4D),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '/ đêm',
                    style: TextStyle(color: Color(0xFF667085), fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _OfferRule extends StatelessWidget {
  const _OfferRule(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4, right: 8),
          child: Icon(Icons.circle, size: 5, color: Color(0xFF0F8B8D)),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF667085),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}

class _RecommendedStayCard extends StatelessWidget {
  const _RecommendedStayCard({
    required this.image,
    required this.place,
    required this.rating,
    required this.name,
    required this.features,
    required this.price,
  });
  final String image, place, rating, name, features, price;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFE5E7EB)),
      borderRadius: BorderRadius.circular(14),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        final slug = switch (name) {
          'Mây Homestay' => 'may-homestay',
          'Ocean Pearl Hotel' => 'ocean-pearl-hotel',
          'An Villa' => 'an-villa',
          'Pine House' => 'pine-hill-homestay',
          _ => 'may-homestay',
        };
        if (slug == 'may-homestay') {
          context.push('/properties/may-homestay');
        } else {
          context.push('/catalog/properties/$slug');
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FigmaRaster(image, width: 112, height: 118),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          place,
                          style: const TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.star,
                        size: 13,
                        color: Color(0xFFFDB022),
                      ),
                      Text(
                        rating,
                        style: const TextStyle(
                          color: Color(0xFF344054),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Color(0xFF172B4D),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    features,
                    style: const TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 11),
                  Row(
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          color: Color(0xFF172B4D),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '/ đêm',
                        style: TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
