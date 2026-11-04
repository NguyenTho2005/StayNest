import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/staynest_api.dart';
import '../design/tokens.dart';
import '../widgets/figma_asset.dart';

class PropertyDetailScreen extends ConsumerStatefulWidget {
  const PropertyDetailScreen({super.key, this.slug = 'may-homestay'});
  final String slug;
  @override
  ConsumerState<PropertyDetailScreen> createState() =>
      _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends ConsumerState<PropertyDetailScreen> {
  bool saved = false;
  bool saving = false;
  late final Future<Map<String, dynamic>> property;

  @override
  void initState() {
    super.initState();
    property = ref.read(stayNestApiProvider).property(widget.slug);
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final api = ref.read(stayNestApiProvider);
    if (await api.token == null) return;
    try {
      final favorites = await api.favorites();
      if (mounted) {
        setState(
          () => saved = favorites.any((item) => item['slug'] == widget.slug),
        );
      }
    } catch (_) {
      // The detail page remains usable when favorites cannot load.
    }
  }

  Future<void> _toggleFavorite() async {
    if (saving) return;
    final api = ref.read(stayNestApiProvider);
    if (await api.token == null) {
      if (!mounted) return;
      context.push('/login');
      return;
    }
    setState(() => saving = true);
    try {
      await api.setFavorite(widget.slug, !saved);
      if (mounted) {
        setState(() => saved = !saved);
        ref.invalidate(myFavoritesProvider);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$error')));
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const pale = Color(0xFFEAF7F6);
  static const background = Color(0xFFF7F9FC);
  static const cardShadow = BoxShadow(
    color: Color(0x0A172B4D),
    blurRadius: 8,
    offset: Offset(0, 4),
  );

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
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: property,
              builder: (context, snapshot) {
                final rooms = snapshot.data?['rooms'] as List? ?? [];
                final price = rooms.isEmpty
                    ? null
                    : toInt(rooms.first['base_price_vnd']);
                final formattedPrice = price == null
                    ? '—'
                    : '$price'.replaceAllMapped(
                        RegExp(r'\B(?=(\d{3})+(?!\d))'),
                        (_) => '.',
                      );
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$formattedPriceđ',
                          style: const TextStyle(
                            fontSize: 20,
                            height: 26 / 20,
                            fontWeight: FontWeight.w600,
                            color: ink,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '/ đêm',
                          style: TextStyle(fontSize: 12, color: muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 3,
                          backgroundColor: Color(0xFF12B76A),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          snapshot.hasError
                              ? 'Không tải được giá'
                              : 'Giá theo dữ liệu StayNest',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF12B76A),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          FutureBuilder<Map<String, dynamic>>(
            future: property,
            builder: (context, snapshot) {
              final data = snapshot.data;
              final rooms = data?['rooms'] as List? ?? [];
              return SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: rooms.isEmpty
                      ? null
                      : () {
                          final draft = ref.read(bookingDraftProvider);
                          draft.selectProperty(
                            slug: widget.slug,
                            name: '${data?['name'] ?? 'Chỗ ở'}',
                            destination: '${data?['destination_slug'] ?? ''}',
                            address: '${data?['address'] ?? ''}',
                          );
                          context.push(
                            widget.slug == 'may-homestay'
                                ? '/properties/may-homestay/rooms'
                                : '/properties/${widget.slug}/rooms',
                          );
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: StayNestColors.teal,
                    disabledBackgroundColor: const Color(0xFF98A2B3),
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
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      FigmaSvg(
                        'assets/icons/property_detail_25.svg',
                        width: 15,
                        height: 16.667,
                      ),
                    ],
                  ),
                ),
              );
            },
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
                        : context.go('/search/results'),
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Center(
                        child: FigmaSvg(
                          'assets/icons/property_detail_26.svg',
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: property,
                      builder: (context, snapshot) {
                        final propName =
                            snapshot.data?['name'] ?? 'Mây Homestay';
                        return Text(
                          'Chi Tiết $propName',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: StayNestColors.ink,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: FigmaSvg(
                        'assets/icons/property_detail_27.svg',
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
                        'assets/icons/property_detail_28.svg',
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: property,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: StayNestColors.teal,
                      ),
                    );
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Không tải được thông tin chỗ ở.'),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: () => setState(() {
                              property = ref
                                  .read(stayNestApiProvider)
                                  .property(widget.slug);
                            }),
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    );
                  }
                  final data = snapshot.data!;
                  final propName = '${data['name'] ?? 'Mây Homestay'}';
                  final address = '${data['address'] ?? 'Hội An, Quảng Nam'}';
                  final destinationName =
                      '${data['destination_name'] ?? 'Trung tâm'}';
                  final description =
                      '${data['description'] ?? 'Homestay mang phong cách mộc mạc Hội An với nội thất gỗ tự nhiên, gạch bông cổ điển và khu vườn nhiệt đới xanh mát ngập tràn nắng chiều ấm áp.'}';
                  final rating =
                      '${data['rating'] ?? data['reviewSummary']?['average'] ?? '4.8'}';
                  final reviewCount = data['reviewSummary']?['count'] ?? 128;
                  final images = (data['images'] as List?) ?? [];
                  final mainImg = images.isNotEmpty
                      ? 'assets/images/${images[0]['image_path']}'
                      : (widget.slug == 'may-homestay'
                            ? 'assets/images/property_detail_1.jpg'
                            : 'assets/images/destination_hotels_ocean.jpg');
                  final thumb1 = images.length > 1
                      ? 'assets/images/${images[1]['image_path']}'
                      : 'assets/images/property_detail_2.jpg';
                  final thumb2 = images.length > 2
                      ? 'assets/images/${images[2]['image_path']}'
                      : 'assets/images/property_detail_3.jpg';
                  final amenitiesList = (data['amenities'] as List?) ?? [];
                  final tagNames = amenitiesList.isNotEmpty
                      ? amenitiesList
                            .map((a) => '${a['name']}')
                            .take(3)
                            .toList()
                      : const ['Bếp riêng', 'Wi-Fi miễn phí', 'Điều hòa'];

                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Stack(
                        children: [
                          FigmaRaster(
                            mainImg,
                            width: double.infinity,
                            height: 270,
                          ),
                          Positioned(
                            left: 16,
                            top: 12,
                            child: _round(
                              'property_detail_02.svg',
                              14.667,
                              14.667,
                              () => context.canPop()
                                  ? context.pop()
                                  : context.go('/search/results'),
                            ),
                          ),
                          Positioned(
                            right: 64,
                            top: 12,
                            child: _round(
                              'property_detail_03.svg',
                              15,
                              16.667,
                              null,
                            ),
                          ),
                          Positioned(
                            right: 16,
                            top: 12,
                            child: saved
                                ? InkWell(
                                    onTap: _toggleFavorite,
                                    child: const CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Color(0xD9FFFFFF),
                                      child: Icon(
                                        Icons.favorite,
                                        color: StayNestColors.teal,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                : _round(
                                    'property_detail_04.svg',
                                    18.333,
                                    16.821,
                                    _toggleFavorite,
                                  ),
                          ),
                          Positioned(
                            left: 16,
                            bottom: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xE6FFFFFF),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Row(
                                children: [
                                  FigmaSvg(
                                    'assets/icons/property_detail_01.svg',
                                    width: 14.667,
                                    height: 14,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Chủ nhà tin cậy',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: StayNestColors.teal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () =>
                            context.push('/properties/may-homestay/gallery'),
                        child: Transform.translate(
                          offset: const Offset(0, -16),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [cardShadow],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: FigmaRaster(
                                    thumb1,
                                    width: 64,
                                    height: 48,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: FigmaRaster(
                                    thumb2,
                                    width: 64,
                                    height: 48,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: pale,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const FigmaSvg(
                                          'assets/icons/property_detail_05.svg',
                                          width: 15,
                                          height: 15,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '+${images.length > 3 ? images.length - 2 : 6} ảnh',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: StayNestColors.teal,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    propName,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      height: 30 / 24,
                                      fontWeight: FontWeight.w600,
                                      color: ink,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: pale,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Row(
                                    children: [
                                      const FigmaSvg(
                                        'assets/icons/property_detail_06.svg',
                                        width: 13.333,
                                        height: 12.667,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        rating,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: StayNestColors.teal,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '($reviewCount)',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const FigmaSvg(
                                  'assets/icons/property_detail_07.svg',
                                  width: 12,
                                  height: 15,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    address,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: ink,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Xem bản đồ ›',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: StayNestColors.teal,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (var i = 0; i < tagNames.length; i++)
                                  _Highlight(
                                    tagNames[i],
                                    i == 0
                                        ? 'property_detail_09.svg'
                                        : (i == 1
                                              ? 'property_detail_10.svg'
                                              : 'property_detail_11.svg'),
                                    14,
                                    14,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _card(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      FigmaSvg(
                                        'assets/icons/property_detail_12.svg',
                                        width: 18.333,
                                        height: 16.667,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Không gian nghỉ dưỡng',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: ink,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    description,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      height: 22.75 / 14,
                                      color: muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            _card(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Tiện nghi chỗ ở',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: ink,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${amenitiesList.isEmpty ? 12 : amenitiesList.length} tiện nghi',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _amenity(
                                          'Giường Queen',
                                          'property_detail_13.svg',
                                          16,
                                          12,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _amenity(
                                          'Bếp riêng',
                                          'property_detail_14.svg',
                                          12,
                                          16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _amenity(
                                          'Wi-Fi 100Mbps',
                                          'property_detail_15.svg',
                                          16,
                                          12,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _amenity(
                                          'Điều hòa êm',
                                          'property_detail_16.svg',
                                          13.333,
                                          13.333,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  InkWell(
                                    onTap: () => context.push(
                                      '/properties/may-homestay/amenities',
                                    ),
                                    child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: pale,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              'Xem tất cả tiện nghi (${amenitiesList.isEmpty ? 12 : amenitiesList.length})',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: StayNestColors.teal,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          const FigmaSvg(
                                            'assets/icons/property_detail_17.svg',
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
                            const SizedBox(height: 24),
                            InkWell(
                              onTap: () => context.push(
                                '/properties/may-homestay/reviews/overview',
                              ),
                              child: _card(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            'Đánh giá từ khách',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: ink,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Tất cả $reviewCount',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: StayNestColors.teal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: background,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const CircleAvatar(
                                                radius: 18,
                                                backgroundColor: Color(
                                                  0xFFBFD2FD,
                                                ),
                                                child: Text(
                                                  'MT',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF475A7E),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              const Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Minh Trang',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: ink,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      'Đã lưu trú 2 đêm • Tháng 4/2024',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: muted,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ...List.generate(
                                                5,
                                                (_) => const FigmaSvg(
                                                  'assets/icons/property_detail_18.svg',
                                                  width: 13.333,
                                                  height: 12.667,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            '“Không gian cực kỳ ấm cúng và yên tĩnh, bếp riêng rất tiện lợi, chủ nhà thân thiện chu đáo.”',
                                            style: TextStyle(
                                              fontSize: 14,
                                              height: 22.75 / 14,
                                              fontStyle: FontStyle.italic,
                                              color: ink,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            _card(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Vị trí chỗ ở',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: ink,
                                          ),
                                        ),
                                      ),
                                      FigmaSvg(
                                        'assets/icons/property_detail_19.svg',
                                        width: 10.667,
                                        height: 12.667,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        'Khu vực $destinationName',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: StayNestColors.teal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  InkWell(
                                    onTap: () => context.push(
                                      widget.slug == 'may-homestay'
                                          ? '/properties/may-homestay/location'
                                          : '/catalog/properties/${widget.slug}',
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: SizedBox(
                                        height: 144,
                                        width: double.infinity,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            const Positioned.fill(
                                              child: ColoredBox(
                                                color: Color(0xFFD3D4EA),
                                              ),
                                            ),
                                            const FigmaSvg(
                                              'assets/icons/property_detail_20.svg',
                                              width: 318,
                                              height: 318,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: StayNestColors.teal,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          999,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const FigmaSvg(
                                                        'assets/icons/property_detail_21.svg',
                                                        width: 12.833,
                                                        height: 8.75,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Flexible(
                                                        child: Text(
                                                          propName,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                const FigmaSvg(
                                                  'assets/icons/property_detail_22.svg',
                                                  width: 21.333,
                                                  height: 26.667,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const FigmaSvg(
                                        'assets/icons/property_detail_23.svg',
                                        width: 9.333,
                                        height: 13.333,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          address,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: muted,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: pale,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  FigmaSvg(
                                    'assets/icons/property_detail_24.svg',
                                    width: 16,
                                    height: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Đặt phòng bảo đảm',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: StayNestColors.teal,
                                          ),
                                        ),
                                        Text(
                                          'Hủy miễn phí trước nhận phòng 48 giờ',
                                          style: TextStyle(
                                            fontSize: 12,
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _round(
    String icon,
    double width,
    double height,
    VoidCallback? onTap,
  ) => InkWell(
    onTap: onTap,
    child: Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xD9FFFFFF),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: FigmaSvg('assets/icons/$icon', width: width, height: height),
      ),
    ),
  );
  Widget _card(Widget content) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [cardShadow],
    ),
    child: content,
  );
  Widget _amenity(
    String label,
    String icon,
    double width,
    double height,
  ) => Container(
    height: 64,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(color: pale, shape: BoxShape.circle),
          child: Center(
            child: FigmaSvg('assets/icons/$icon', width: width, height: height),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, height: 22 / 14, color: ink),
          ),
        ),
      ],
    ),
  );
}

class _Highlight extends StatelessWidget {
  const _Highlight(this.label, this.icon, this.width, this.height);
  final String label, icon;
  final double width, height;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF7F6),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FigmaSvg('assets/icons/$icon', width: width, height: height),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: StayNestColors.teal,
          ),
        ),
      ],
    ),
  );
}
