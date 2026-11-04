import 'package:intl/intl.dart';

/// Phân tích chuỗi hoặc đối tượng ngày tháng an toàn.
///
/// Đối với chuỗi chỉ có ngày 'YYYY-MM-DD', hàm khởi tạo theo ngày lịch cục bộ (calendar date)
/// để tránh hiện tượng múi giờ UTC làm lùi 1 ngày ở Việt Nam (GMT+7).
/// Đối với chuỗi ISO có giờ hoặc ký tự 'Z', chuyển sang múi giờ cục bộ (.toLocal()).
DateTime? parseStayDate(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  final raw = value.toString().trim();
  if (raw.isEmpty) return null;

  // Chuỗi chỉ có ngày: YYYY-MM-DD
  final dateOnlyPattern = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$');
  final match = dateOnlyPattern.firstMatch(raw);
  if (match != null) {
    final year = int.tryParse(match.group(1)!);
    final month = int.tryParse(match.group(2)!);
    final day = int.tryParse(match.group(3)!);
    if (year != null && month != null && day != null) {
      return DateTime(year, month, day);
    }
  }

  // Chuỗi ISO timestamp hoặc dạng khác
  try {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return null;
    return raw.endsWith('Z') || raw.contains('+') || raw.contains('-')
        ? parsed.toLocal()
        : parsed;
  } catch (_) {
    return null;
  }
}

/// Định dạng ngày lưu trú theo chuẩn 'dd/MM/yyyy' tiếng Việt.
String formatStayDate(Object? value, {String fallback = 'Chưa cập nhật'}) {
  final dt = parseStayDate(value);
  if (dt == null) return fallback;
  try {
    return DateFormat('dd/MM/yyyy', 'vi_VN').format(dt);
  } catch (_) {
    // Fallback định dạng thủ công nếu locale vi_VN gặp sự cố
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    return '$day/$month/${dt.year}';
  }
}

/// Định dạng khoảng thời gian nhận và trả phòng: 'dd/MM/yyyy – dd/MM/yyyy'.
String formatStayDateRange(
  Object? checkIn,
  Object? checkOut, {
  String fallback = 'Chưa cập nhật',
  String separator = ' – ',
}) {
  final startStr = formatStayDate(checkIn, fallback: fallback);
  final endStr = formatStayDate(checkOut, fallback: fallback);
  if (startStr == fallback && endStr == fallback) return fallback;
  return '$startStr$separator$endStr';
}
