import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/staynest_api.dart';
import '../widgets/figma_asset.dart';

class RoomSelectionScreen extends ConsumerStatefulWidget {
  const RoomSelectionScreen({super.key, this.slug = 'may-homestay'});
  final String slug;

  @override
  ConsumerState<RoomSelectionScreen> createState() =>
      _RoomSelectionScreenState();
}

class _RoomSelectionScreenState extends ConsumerState<RoomSelectionScreen> {
  late Future<Map<String, dynamic>> property;

  @override
  void initState() {
    super.initState();
    property = ref.read(stayNestApiProvider).property(widget.slug);
  }

  String money(Object? amount) => '${amount ?? 0}'.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  int get nights => ref
      .read(bookingDraftProvider)
      .checkOut
      .difference(ref.read(bookingDraftProvider).checkIn)
      .inDays;

  Future<void> selectRoom({
    required int id,
    required String name,
    required bool primary,
    required Map<String, dynamic> propertyData,
    required String roomImage,
  }) async {
    final draft = ref.read(bookingDraftProvider);
    draft.selectProperty(
      slug: widget.slug,
      name: '${propertyData['name'] ?? 'Chỗ ở'}',
      destination: '${propertyData['destination_slug'] ?? ''}',
      address: '${propertyData['address'] ?? ''}',
    );
    draft.selectedRoomTypeId = id;
    draft.selectedRoomName = name;
    draft.selectedRoomImage = roomImage;
    draft.quote = null;
    draft.booking = null;
    draft.idempotencyKey = null;

    final api = ref.read(stayNestApiProvider);
    if (await api.token != null) {
      try {
        final user = await api.getMe();
        draft.prefillGuestFromUser(user);
      } catch (_) {}
    }

    if (!mounted) return;
    if (widget.slug == 'may-homestay' && primary) {
      context.push('/properties/may-homestay/rooms/studio');
    } else {
      context.push('/booking/summary');
    }
  }

  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const teal = Color(0xFF006768);

  @override
  Widget build(BuildContext context) {
    final draft = ref.read(bookingDraftProvider);
    final nights = draft.checkOut.difference(draft.checkIn).inDays;
    return Scaffold(
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
                          : context.go(
                              widget.slug == 'may-homestay'
                                  ? '/properties/may-homestay'
                                  : '/catalog/properties/${widget.slug}',
                            ),
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
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF7F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              color: teal,
                              size: 19,
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: FutureBuilder<Map<String, dynamic>>(
                                future: property,
                                builder: (context, snapshot) {
                                  final propName =
                                      snapshot.data?['name'] ?? 'Chỗ ở';
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$propName  •  $nights đêm',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: ink,
                                        ),
                                      ),
                                      Text(
                                        '${draft.checkIn.day}/${draft.checkIn.month} - ${draft.checkOut.day}/${draft.checkOut.month}/${draft.checkOut.year} • ${draft.adults + draft.children} khách, ${draft.roomCount} phòng',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: muted,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const Icon(Icons.tune, color: teal, size: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Các hạng phòng có sẵn',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Giá và hạng phòng lấy từ StayNest',
                        style: TextStyle(fontSize: 10, color: muted),
                      ),
                      const SizedBox(height: 12),
                      FutureBuilder<Map<String, dynamic>>(
                        future: property,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData && !snapshot.hasError) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Column(
                              children: [
                                const Text('Không tải được hạng phòng.'),
                                TextButton(
                                  onPressed: () => setState(() {
                                    property = ref
                                        .read(stayNestApiProvider)
                                        .property(widget.slug);
                                  }),
                                  child: const Text('Thử lại'),
                                ),
                              ],
                            );
                          }
                          final propertyData = snapshot.data!;
                          final rooms = propertyData['rooms'] as List? ?? [];
                          if (rooms.isEmpty) {
                            return const Text('Chưa có hạng phòng.');
                          }
                          return Column(
                            children: [
                              for (
                                var index = 0;
                                index < rooms.length;
                                index++
                              ) ...[
                                _room(
                                  context,
                                  roomTypeId: toInt(rooms[index]['id']),
                                  image: index == 0
                                      ? 'assets/images/room_studio_049.jpg'
                                      : 'assets/images/room_garden_049.jpg',
                                  title: '${rooms[index]['name']}',
                                  summary: index == 0
                                      ? '28m² • 1 giường đôi Queen • Tối đa 2 người lớn • Bếp riêng • Ban công thoáng'
                                      : '32m² • 1 giường King • Tối đa 2 người lớn • View vườn • Bồn tắm',
                                  features: index == 0
                                      ? const [
                                          'Giường nệm linen',
                                          'Bếp điện, gia vị',
                                          'Wifi 150 Mbps',
                                          'Điều hòa 2 chiều',
                                        ]
                                      : const [
                                          'Bồn tắm gỗ ngâm',
                                          'Ban công sân vườn',
                                          'Máy pha cà phê',
                                          'Hướng nhìn nhiệt đới',
                                        ],
                                  price:
                                      '${money(rooms[index]['base_price_vnd'])}đ',
                                  total:
                                      '${money(toInt(rooms[index]['base_price_vnd']) * nights * draft.roomCount)}đ',
                                  badge: index == 0
                                      ? 'Phòng Studio'
                                      : 'Garden View',
                                  primary: index == 0,
                                  onSelect: () => selectRoom(
                                    id: toInt(rooms[index]['id']),
                                    name: '${rooms[index]['name']}',
                                    primary: index == 0,
                                    propertyData: propertyData,
                                    roomImage: index == 0
                                        ? 'assets/images/room_studio_049.jpg'
                                        : 'assets/images/room_garden_049.jpg',
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              color: teal,
                              size: 21,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Đảm bảo giá tốt nhất tại StayNest',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: ink,
                                    ),
                                  ),
                                  Text(
                                    'Xác nhận đặt phòng tức thì & hỗ trợ 24/7 bằng tiếng Việt',
                                    style: TextStyle(
                                      fontSize: 10,
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
                      const Text(
                        '♧  Giá phòng chưa gồm thuế, phí và mã ưu đãi',
                        style: TextStyle(fontSize: 10, color: muted),
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

  Widget _room(
    BuildContext context, {
    required int roomTypeId,
    required String image,
    required String title,
    required String summary,
    required List<String> features,
    required String price,
    required String total,
    required String badge,
    required bool primary,
    required VoidCallback onSelect,
  }) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              FigmaRaster(image, width: 326, height: 125),
              Positioned(
                right: 5,
                top: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(fontSize: 9, color: teal),
                  ),
                ),
              ),
              Positioned(
                left: 5,
                bottom: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xCC182230),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    primary ? '▣ 8 ảnh' : '▣ 12 ảnh',
                    style: const TextStyle(fontSize: 9, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ink,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          summary,
          style: const TextStyle(fontSize: 11, height: 1.5, color: muted),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF3FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < features.length; i++)
                SizedBox(
                  width: 143,
                  child: Row(
                    children: [
                      FigmaSvg(
                        'assets/icons/room_049_${(i + 5).toString().padLeft(2, '0')}.svg',
                        width: 12,
                        height: 12,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          features[i],
                          style: const TextStyle(fontSize: 9, color: ink),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE9FAF1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '● Xem điều kiện hủy khi xác nhận giá',
            style: TextStyle(fontSize: 10, color: Color(0xFF00A56A)),
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: price,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: teal,
                ),
              ),
              const TextSpan(
                text: ' / đêm',
                style: TextStyle(fontSize: 10, color: muted),
              ),
            ],
          ),
        ),
        Text(
          'Tổng $nights đêm: $total${primary ? ' (chưa gồm thuế phí)' : ''}',
          style: const TextStyle(fontSize: 10, color: muted),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 36,
          child: primary
              ? ElevatedButton(
                  onPressed: onSelect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: const Text(
                    'Chọn phòng này  →',
                    style: TextStyle(fontSize: 11),
                  ),
                )
              : TextButton(
                  onPressed: onSelect,
                  child: const Text(
                    'Chọn phòng ›',
                    style: TextStyle(fontSize: 11, color: teal),
                  ),
                ),
        ),
      ],
    ),
  );
}
