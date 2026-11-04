import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

class HostChatDemoScreen extends StatelessWidget {
  const HostChatDemoScreen({super.key});
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
                        : context.go('/properties/may-homestay'),
                    icon: const Icon(Icons.arrow_back, size: 19),
                  ),
                  const Expanded(
                    child: Text(
                      'Liên Hệ Chủ Nhà',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                  ),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  ClipOval(
                    child: const FigmaRaster(
                      'assets/images/chat_059_03.jpg',
                      width: 32,
                      height: 32,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mây Homestay   Chủ nhà',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ink,
                          ),
                        ),
                        Text(
                          '● Trực tuyến • Phản hồi trong 15 phút',
                          style: TextStyle(fontSize: 10, color: muted),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.call_outlined, color: muted, size: 18),
                  const SizedBox(width: 20),
                  const Icon(Icons.info_outline, color: muted, size: 18),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '♧ Cuộc trò chuyện mang tính chất mô phỏng DEMO cho đồ án StayNest.',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: teal,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Mọi thông tin phòng và tiện ích dựa trên cơ sở dữ liệu thực tế tại Hội An.',
                            style: TextStyle(fontSize: 10, color: muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 9),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: const FigmaRaster(
                              'assets/images/chat_059_02.jpg',
                              width: 54,
                              height: 54,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Đang trao đổi về',
                                  style: TextStyle(fontSize: 9, color: muted),
                                ),
                                Text(
                                  'Phòng Studio có bếp nhỏ & ban công',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: ink,
                                  ),
                                ),
                                Text(
                                  '14 - 16/11/2026  •  850.000đ/đêm',
                                  style: TextStyle(fontSize: 9, color: teal),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: muted,
                            size: 17,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Center(
                      child: Text(
                        'Hôm nay, 14 Tháng 11',
                        style: TextStyle(fontSize: 10, color: muted),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _bubble(
                      'Chào bạn An! Cảm ơn bạn đã quan tâm đến Mây Homestay Hội An. Mình có thể hỗ trợ gì cho kỳ nghỉ của bạn?',
                      false,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '09:30 • Đã nhận',
                      style: TextStyle(fontSize: 9, color: muted),
                    ),
                    const SizedBox(height: 14),
                    _bubble(
                      'Chào bạn, phòng Studio bên mình có sẵn gia vị và đồ nấu ăn cơ bản không ạ?',
                      true,
                    ),
                    const SizedBox(height: 4),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '09:32 ✓✓',
                        style: TextStyle(fontSize: 9, color: muted),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _bubble(
                      'Chào bạn, phòng Studio đã trang bị đầy đủ bếp từ, nồi chảo, dao thớt và các loại gia vị cơ bản (dầu ăn, muối, đường, tiêu) để bạn tự nấu nướng thoải mái nhé! 🌿🍳',
                      false,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '09:33 Tự động phản hồi',
                      style: TextStyle(fontSize: 9, color: teal),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Text(
                          'Gợi ý câu hỏi nhanh:',
                          style: TextStyle(fontSize: 10, color: muted),
                        ),
                        Spacer(),
                        Text(
                          'Chạm để gửi',
                          style: TextStyle(fontSize: 9, color: teal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    const SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Chip(
                            label: Text(
                              'Chỗ ở có chỗ để xe máy không?',
                              style: TextStyle(fontSize: 9),
                            ),
                          ),
                          SizedBox(width: 5),
                          Chip(
                            label: Text(
                              'Giờ nhận phòng sớm nhất là mấy giờ?',
                              style: TextStyle(fontSize: 9),
                            ),
                          ),
                          SizedBox(width: 5),
                          Chip(
                            label: Text(
                              'Có xe đạp dạo phố cổ không?',
                              style: TextStyle(fontSize: 9),
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
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              color: Colors.white,
              child: const Row(
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: muted,
                    size: 21,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Nhập tin nhắn...',
                        hintStyle: TextStyle(fontSize: 11),
                        filled: true,
                        fillColor: Color(0xFFF7F9FC),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: teal,
                    child: Icon(
                      Icons.send_outlined,
                      color: Colors.white,
                      size: 18,
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

  Widget _bubble(String text, bool mine) => Align(
    alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      constraints: const BoxConstraints(maxWidth: 240),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: mine ? teal : Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          height: 1.5,
          color: mine ? Colors.white : ink,
        ),
      ),
    ),
  );
}
