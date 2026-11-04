import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

class CompareSelectionScreen extends StatefulWidget {
  const CompareSelectionScreen({super.key});
  @override
  State<CompareSelectionScreen> createState() => _CompareSelectionScreenState();
}

class _CompareSelectionScreenState extends State<CompareSelectionScreen> {
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const teal = Color(0xFF006768);
  final Set<int> selected = {0, 1};
  static const rooms = [
    (
      'Mây Homestay',
      'Phường Cẩm Hà, Hội An',
      'Ban công gỗ',
      '850.000đ',
      '4.8',
      '128',
      'Phổ biến',
    ),
    (
      'An Villa',
      'Cẩm Thanh, Hội An',
      'Sân vườn, hồ bơi',
      '980.000đ',
      '4.7',
      '86',
      'Ưa thích',
    ),
    (
      'Riverside Home',
      'Cẩm Nam, Hội An',
      'Ven sông Thu Bồn',
      '920.000đ',
      '4.6',
      '62',
      '',
    ),
    (
      'Hương Cau Homestay',
      'Minh An, Phố cổ Hội An',
      'Gần Chùa Cầu',
      '780.000đ',
      '4.9',
      '142',
      '',
    ),
  ];

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
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go('/favorites'),
                    icon: const Icon(Icons.arrow_back, size: 20),
                  ),
                  const Expanded(
                    child: Text(
                      'Chi Tiết Phòng Nghỉ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                  ),
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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Chọn tối đa 3 chỗ ở cùng khu vực để đối chiếu chi tiết',
                            style: TextStyle(fontSize: 12, color: muted),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Hội An',
                          style: TextStyle(fontSize: 11, color: teal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, color: teal, size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Đang lọc các chỗ ở tại Hội An cùng ngày 14 - 16/11/2026 để so sánh chính xác mức giá & tiện ích.',
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
                    const SizedBox(height: 10),
                    for (var i = 0; i < rooms.length; i++) ...[
                      _room(i),
                      const SizedBox(height: 9),
                    ],
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF0FE),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Text(
                        '♧  Lưu ý: Chỉ hỗ trợ so sánh tối đa 3 chỗ ở cùng khoảng thời gian lưu trú để đảm bảo tính chuẩn xác của báo giá và tình trạng phòng trống.',
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
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '● Đã chọn ${selected.length}/3 chỗ ở',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ink,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => setState(selected.clear),
                        child: const Text(
                          'Bỏ chọn tất cả',
                          style: TextStyle(fontSize: 11, color: teal),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: selected.length >= 2
                          ? () => context.push('/favorites/compare')
                          : null,
                      icon: const Icon(Icons.compare_arrows),
                      label: Text('So sánh ngay (${selected.length})'),
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: teal,
                        disabledForegroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
  );

  Widget _room(int index) {
    final room = rooms[index];
    final checked = selected.contains(index);
    return InkWell(
      onTap: () => setState(() {
        if (checked) {
          selected.remove(index);
        } else if (selected.length < 3) {
          selected.add(index);
        }
      }),
      child: Container(
        height: 131,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: checked ? teal : const Color(0xFFE0E8F4),
            width: checked ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: checked ? teal : Colors.white,
                border: checked
                    ? null
                    : Border.all(color: const Color(0xFFE6EAF2)),
              ),
              child: checked
                  ? const Icon(Icons.check, size: 15, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Stack(
                children: [
                  FigmaRaster(
                    'assets/images/compare_056_0${index + 1}.png',
                    width: 80,
                    height: 80,
                  ),
                  if (room.$7.isNotEmpty)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          room.$7,
                          style: const TextStyle(fontSize: 9, color: teal),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          room.$1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ink,
                          ),
                        ),
                      ),
                      const Text('⭐', style: TextStyle(fontSize: 10)),
                      Text(
                        room.$5,
                        style: const TextStyle(fontSize: 10, color: ink),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '♧ ${room.$2}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: muted),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          room.$3,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10, color: muted),
                        ),
                      ),
                      Text(
                        room.$4,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: teal,
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
    );
  }
}
