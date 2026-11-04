import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

class RecentSearchesScreen extends StatefulWidget {
  const RecentSearchesScreen({super.key});

  @override
  State<RecentSearchesScreen> createState() => _RecentSearchesScreenState();
}

class _RecentSearchesScreenState extends State<RecentSearchesScreen> {
  final searches = <_HistoryEntry>[
    const _HistoryEntry(
      city: 'Hội An',
      dates: '14–16/11/2026',
      guests: '2 người lớn · 1 phòng',
      recent: true,
    ),
    const _HistoryEntry(
      city: 'Đà Nẵng',
      dates: '14–16/11/2026',
      guests: '2 người lớn · 1 phòng',
    ),
    const _HistoryEntry(
      city: 'Đà Lạt',
      dates: '14–16/11/2026',
      guests: '2 người lớn · 1 phòng',
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F9FC),
    body: Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => context.pop(),
                      child: const SizedBox(
                        width: 40,
                        height: 44,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FigmaSvg(
                            'assets/icons/recent_search_01.svg',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Tìm kiếm gần đây',
                      style: TextStyle(
                        color: Color(0xFF172B4D),
                        fontSize: 20,
                        height: 30 / 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: searches.isEmpty
                        ? null
                        : () => setState(searches.clear),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      minimumSize: const Size(0, 29),
                    ),
                    child: const Text(
                      'Xóa tất cả',
                      style: TextStyle(
                        color: Color(0xFF0F8B8D),
                        fontSize: 14,
                        height: 21 / 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ...searches.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _HistoryCard(
                      entry: entry.value,
                      onDelete: () =>
                          setState(() => searches.removeAt(entry.key)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              'Chạm vào để áp dụng tìm kiếm',
              style: TextStyle(
                color: Color(0xFF98A2B3),
                fontSize: 12,
                height: 18 / 12,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _HistoryEntry {
  const _HistoryEntry({
    required this.city,
    required this.dates,
    required this.guests,
    this.recent = false,
  });
  final String city, dates, guests;
  final bool recent;
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.entry, required this.onDelete});
  final _HistoryEntry entry;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFE4E7EC)),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFEAF7F6),
            shape: BoxShape.circle,
          ),
          child: const FigmaSvg(
            'assets/icons/recent_search_02.svg',
            width: 20,
            height: 20,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    entry.city,
                    style: const TextStyle(
                      color: Color(0xFF172B4D),
                      fontSize: 16,
                      height: 24 / 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (entry.recent) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Text(
                        'Gần nhất',
                        style: TextStyle(
                          color: Color(0xFF0F8B8D),
                          fontSize: 10,
                          height: 15 / 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                entry.dates,
                style: const TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 13,
                  height: 20 / 13,
                ),
              ),
              Text(
                entry.guests,
                style: const TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 13,
                  height: 20 / 13,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onDelete,
          borderRadius: BorderRadius.circular(99),
          child: SizedBox(
            width: 36,
            height: 44,
            child: Center(
              child: FigmaSvg(
                'assets/icons/recent_search_03.svg',
                width: 16,
                height: 16,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
