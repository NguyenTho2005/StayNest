import 'package:flutter_riverpod/flutter_riverpod.dart';

class FigmaBookingFixture {
  const FigmaBookingFixture({
    required this.id,
    required this.bookingCode,
    required this.propertyName,
    required this.propertyAddress,
    required this.destinationName,
    required this.roomName,
    required this.checkInDate,
    required this.checkOutDate,
    required this.roomCount,
    required this.adults,
    required this.children,
    required this.totalVnd,
    required this.status,
    required this.guestName,
    required this.guestEmail,
    required this.guestPhone,
    this.voucherCode = 'DEMO-1024',
    this.refundCode = 'RF-1024',
  });

  final int id;
  final String bookingCode;
  final String propertyName;
  final String propertyAddress;
  final String destinationName;
  final String roomName;
  final String checkInDate;
  final String checkOutDate;
  final int roomCount;
  final int adults;
  final int children;
  final int totalVnd;
  final String status;
  final String guestName;
  final String guestEmail;
  final String guestPhone;
  final String voucherCode;
  final String refundCode;

  Map<String, dynamic> toMap() => {
    'id': id,
    'booking_code': bookingCode,
    'property_name': propertyName,
    'property_address': propertyAddress,
    'destination_name': destinationName,
    'room_name': roomName,
    'check_in_date': checkInDate,
    'check_out_date': checkOutDate,
    'room_count': roomCount,
    'adults': adults,
    'children': children,
    'total_vnd': totalVnd,
    'status': status,
    'guest_name': guestName,
    'guest_email': guestEmail,
    'guest_phone': guestPhone,
    'voucher_code': voucherCode,
    'refund_code': refundCode,
  };
}

class FigmaFixtures {
  static const sampleConfirmedBooking = FigmaBookingFixture(
    id: 1024,
    bookingCode: 'SN-1024',
    propertyName: 'Mây Homestay',
    propertyAddress: 'Cẩm Thanh, Hội An, Quảng Nam',
    destinationName: 'Hội An',
    roomName: 'Phòng Studio có bếp',
    checkInDate: '2026-11-14',
    checkOutDate: '2026-11-16',
    roomCount: 1,
    adults: 2,
    children: 0,
    totalVnd: 1800000,
    status: 'CONFIRMED_DEMO',
    guestName: 'Nguyễn An',
    guestEmail: 'an.demo@example.com',
    guestPhone: '0900 000 123',
  );

  static const sampleCompletedBooking = FigmaBookingFixture(
    id: 1020,
    bookingCode: 'SN-1020',
    propertyName: 'An Villa',
    propertyAddress: 'Cẩm Thanh, Hội An, Quảng Nam',
    destinationName: 'Hội An',
    roomName: 'Villa 1 phòng ngủ hướng hồ',
    checkInDate: '2026-09-10',
    checkOutDate: '2026-09-12',
    roomCount: 1,
    adults: 2,
    children: 0,
    totalVnd: 2400000,
    status: 'COMPLETED',
    guestName: 'Nguyễn An',
    guestEmail: 'an.demo@example.com',
    guestPhone: '0900 000 123',
  );

  static const sampleCancelledBooking = FigmaBookingFixture(
    id: 1018,
    bookingCode: 'SN-1018',
    propertyName: 'Mây Homestay',
    propertyAddress: 'Cẩm Thanh, Hội An, Quảng Nam',
    destinationName: 'Hội An',
    roomName: 'Phòng Studio có bếp nhỏ',
    checkInDate: '2026-11-14',
    checkOutDate: '2026-11-16',
    roomCount: 1,
    adults: 2,
    children: 0,
    totalVnd: 1800000,
    status: 'CANCELLED',
    guestName: 'Nguyễn An',
    guestEmail: 'an.demo@example.com',
    guestPhone: '0900 000 123',
  );
}

final figmaFixturesProvider = Provider<FigmaFixtures>((ref) => FigmaFixtures());

