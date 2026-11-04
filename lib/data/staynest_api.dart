import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const stayNestApiUrl = String.fromEnvironment(
  'STAYNEST_API_URL',
  defaultValue: 'http://127.0.0.1:3000',
);

int toInt(dynamic value, [int fallback = 0]) {
  if (value == null) return fallback;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

final stayNestApiProvider = Provider<StayNestApi>((ref) => StayNestApi());
final currentUserProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final api = ref.watch(stayNestApiProvider);
  final token = await api.token;
  if (token == null) return null;
  try {
    return await api.getMe();
  } on StayNestApiException catch (error) {
    if (error.status == 401) {
      await api.logout();
      return null;
    }
    rethrow;
  }
});
final myBookingsProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.watch(stayNestApiProvider);
  if (await api.token == null) return [];
  return api.bookings();
});
final myFavoritesProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.watch(stayNestApiProvider);
  if (await api.token == null) return [];
  return api.favorites();
});
final availableVouchersProvider = FutureProvider<List<dynamic>>(
  (ref) async => ref.watch(stayNestApiProvider).vouchers(),
);

final bookingDraftProvider = Provider<BookingDraft>((ref) => BookingDraft());

class BookingDraft {
  String destinationSlug = 'hoi-an';
  String get destinationName => switch (destinationSlug) {
    'da-nang' => 'Đà Nẵng',
    'da-lat' => 'Đà Lạt',
    _ => 'Hội An',
  };
  String propertySlug = 'may-homestay';
  String propertyName = 'Mây Homestay';
  String propertyAddress = 'Phường Cẩm Hà, TP. Hội An, Quảng Nam';
  DateTime checkIn = DateTime.now().add(const Duration(days: 14));
  DateTime checkOut = DateTime.now().add(const Duration(days: 16));
  int adults = 2;
  int children = 0;
  int roomCount = 1;
  int? selectedRoomTypeId;
  String selectedRoomName = 'Phòng Studio có bếp';
  String selectedRoomImage = 'assets/images/room_studio_049.jpg';
  String guestName = '';
  String guestEmail = '';
  String guestPhone = '';
  String? specialRequest;
  String? arrivalWindow;
  String? promotionCode = 'STAY100';
  Map<String, dynamic>? quote;
  Map<String, dynamic>? booking;
  String? idempotencyKey;
  bool resumeAfterLogin = false;

  void selectProperty({
    required String slug,
    required String name,
    String? destination,
    String? address,
  }) {
    propertySlug = slug;
    propertyName = name;
    if (destination != null && destination.isNotEmpty) {
      destinationSlug = destination;
    }
    if (address != null && address.isNotEmpty) {
      propertyAddress = address;
    }
  }

  void selectRoom({
    required int roomTypeId,
    required String roomName,
    String? roomImage,
  }) {
    selectedRoomTypeId = roomTypeId;
    selectedRoomName = roomName;
    if (roomImage != null && roomImage.isNotEmpty) {
      selectedRoomImage = roomImage;
    }
    quote = null;
    booking = null;
    idempotencyKey = null;
  }

  void prefillGuestFromUser(Map<String, dynamic>? user) {
    if (user == null) return;
    if (guestName.isEmpty &&
        user['full_name'] != null &&
        '${user['full_name']}'.trim().isNotEmpty) {
      guestName = '${user['full_name']}'.trim();
    }
    if (guestEmail.isEmpty &&
        user['email'] != null &&
        '${user['email']}'.trim().isNotEmpty) {
      guestEmail = '${user['email']}'.trim();
    }
    if (guestPhone.isEmpty &&
        user['phone'] != null &&
        '${user['phone']}'.trim().isNotEmpty) {
      guestPhone = '${user['phone']}'.trim();
    }
  }

  int get nights => checkOut.difference(checkIn).inDays;
  String get roomSubtotalLabel {
    final amount = int.tryParse('${quote?['roomSubtotalVnd']}');
    if (amount == null) return 'Xem giá ở bước tiếp theo';
    final formatted = '$amount'.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return '$formattedđ';
  }

  String get checkInIso => checkIn.toIso8601String().substring(0, 10);
  String get checkOutIso => checkOut.toIso8601String().substring(0, 10);

  Map<String, dynamic> details(int roomTypeId) => {
    'roomTypeId': roomTypeId,
    'checkIn': checkInIso,
    'checkOut': checkOutIso,
    'adults': adults,
    'children': children,
    'roomCount': roomCount,
    if (promotionCode != null) 'promotionCode': promotionCode,
  };
}

class StayNestApiException implements Exception {
  const StayNestApiException(this.code, this.message, this.status);
  final String code;
  final String message;
  final int status;

  @override
  String toString() => message;
}

class StayNestApi {
  StayNestApi({http.Client? client, FlutterSecureStorage? storage})
    : _client = client ?? http.Client(),
      _storage = storage ?? const FlutterSecureStorage();

  final http.Client _client;
  final FlutterSecureStorage _storage;
  static const _tokenKey = 'staynest_session_token';
  String? _token;

  Uri mediaUrl(String path) => Uri.parse('$stayNestApiUrl/media/$path');

  Future<String?> get token async {
    if (_token != null) return _token;
    try {
      _token = await _storage.read(key: _tokenKey);
    } catch (_) {
      _token = null;
    }
    return _token;
  }

  Future<dynamic> request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final savedToken = await token;
    final http.Response result;
    try {
      final response = await _client.send(
        http.Request(method, Uri.parse('$stayNestApiUrl/api/v1$path'))
          ..headers.addAll({
            'Accept': 'application/json',
            if (body != null) 'Content-Type': 'application/json',
            if (savedToken != null) 'Authorization': 'Bearer $savedToken',
            ...?headers,
          })
          ..body = body == null ? '' : jsonEncode(body),
      );
      result = await http.Response.fromStream(response);
    } on http.ClientException {
      throw const StayNestApiException(
        'NETWORK_ERROR',
        'Không thể kết nối đến máy chủ StayNest API ($stayNestApiUrl). Vui lòng kiểm tra backend server đã được khởi chạy chưa (npm run dev --prefix backend).',
        0,
      );
    } catch (e) {
      if (e is StayNestApiException) rethrow;
      throw StayNestApiException('NETWORK_ERROR', 'Lỗi kết nối mạng: $e', 0);
    }
    final decoded = result.body.isEmpty ? null : jsonDecode(result.body);
    if (result.statusCode >= 400) {
      final error = decoded is Map ? decoded['error'] : null;
      throw StayNestApiException(
        error is Map ? '${error['code']}' : 'HTTP_${result.statusCode}',
        error is Map ? '${error['message']}' : 'Không thể kết nối StayNest',
        result.statusCode,
      );
    }
    return decoded;
  }

  Future<Map<String, dynamic>> login(String identity, String password) async {
    final result = await request(
      'POST',
      '/auth/login',
      body: {'identity': identity, 'password': password},
    ) as Map<String, dynamic>;
    _token = result['token'] as String;
    try {
      await _storage.write(key: _tokenKey, value: _token);
    } catch (_) {}
    return result;
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final result = await request(
      'POST',
      '/auth/register',
      body: {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'password': password,
      },
    ) as Map<String, dynamic>;
    _token = result['token'] as String;
    try {
      await _storage.write(key: _tokenKey, value: _token);
    } catch (_) {}
    return result;
  }

  Future<Map<String, dynamic>> getMe() async =>
      await request('GET', '/me') as Map<String, dynamic>;

  Future<Map<String, dynamic>> updateMe(Map<String, dynamic> changes) async =>
      await request('PATCH', '/me', body: changes) as Map<String, dynamic>;

  Future<void> logout() async {
    try {
      await request('POST', '/logout');
    } finally {
      _token = null;
      try {
        await _storage.delete(key: _tokenKey);
      } catch (_) {}
    }
  }

  Future<List<dynamic>> destinations() async =>
      (await request('GET', '/destinations') as Map<String, dynamic>)['items']
          as List;

  Future<List<dynamic>> properties({
    String? destination,
    String? query,
    int? minPrice,
    int? maxPrice,
    String? propertyType,
    String? sort,
    String? checkIn,
    String? checkOut,
    int? adults,
  }) async {
    final parameters = <String, String>{};
    if (destination != null) {
      parameters['destination'] = destination;
    }
    if (query != null && query.isNotEmpty) {
      parameters['q'] = query;
    }
    if (minPrice != null) parameters['minPrice'] = '$minPrice';
    if (maxPrice != null) parameters['maxPrice'] = '$maxPrice';
    if (propertyType != null) parameters['type'] = propertyType;
    if (sort != null) parameters['sort'] = sort;
    if (checkIn != null) parameters['checkIn'] = checkIn;
    if (checkOut != null) parameters['checkOut'] = checkOut;
    if (adults != null) parameters['adults'] = '$adults';
    final path = Uri(
      path: '/properties',
      queryParameters: parameters.isEmpty ? null : parameters,
    ).toString();
    return (await request('GET', path) as Map<String, dynamic>)['items']
        as List;
  }

  Future<Map<String, dynamic>> property(String slug) async =>
      await request('GET', '/properties/$slug') as Map<String, dynamic>;

  Future<List<dynamic>> favorites() async =>
      (await request('GET', '/me/favorites') as Map<String, dynamic>)['items']
          as List;

  Future<List<dynamic>> vouchers() async =>
      (await request('GET', '/vouchers') as Map<String, dynamic>)['items']
          as List;

  Future<void> setFavorite(String slug, bool saved) async =>
      await request(saved ? 'PUT' : 'DELETE', '/me/favorites/$slug');

  Future<Map<String, dynamic>> quote(Map<String, dynamic> details) async =>
      await request('POST', '/booking-quotes', body: details)
          as Map<String, dynamic>;

  Future<Map<String, dynamic>> book(
    Map<String, dynamic> details,
    String idempotencyKey,
  ) async => await request(
    'POST',
    '/bookings',
    body: details,
    headers: {'Idempotency-Key': idempotencyKey},
  ) as Map<String, dynamic>;

  Future<List<dynamic>> bookings() async =>
      (await request('GET', '/me/bookings') as Map<String, dynamic>)['items']
          as List;

  Future<Map<String, dynamic>> booking(int id) async =>
      await request('GET', '/bookings/$id') as Map<String, dynamic>;

  Future<Map<String, dynamic>> receipt(int id) async =>
      await request('GET', '/bookings/$id/receipt') as Map<String, dynamic>;

  Future<Map<String, dynamic>> cancellationPreview(int id) async =>
      await request('GET', '/bookings/$id/cancellation-preview')
          as Map<String, dynamic>;

  Future<Map<String, dynamic>> cancelBooking(int id, String reason) async =>
      await request(
        'POST',
        '/bookings/$id/cancellations',
        body: {'reason': reason},
      ) as Map<String, dynamic>;

  Future<Map<String, dynamic>> refund(int id) async =>
      await request('GET', '/bookings/$id/refund') as Map<String, dynamic>;

  Future<Map<String, dynamic>> changeDates(
    int id,
    String checkIn,
    String checkOut,
  ) async => await request(
    'POST',
    '/bookings/$id/change-date-requests',
    body: {'newCheckIn': checkIn, 'newCheckOut': checkOut},
  ) as Map<String, dynamic>;

  Future<Map<String, dynamic>> review(
    int id,
    int rating,
    String comment,
  ) async => await request(
    'POST',
    '/bookings/$id/reviews',
    body: {'rating': rating, 'comment': comment},
  ) as Map<String, dynamic>;

  Future<Map<String, dynamic>> demoPayment(
    int bookingId,
    String method,
  ) async => await request(
    'POST',
    '/bookings/$bookingId/demo-payment',
    body: {'method': method},
  ) as Map<String, dynamic>;
}
