import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staynest/data/staynest_api.dart';
import 'package:staynest/screens/live_payment_success_screen.dart';

class PendingBookingApi extends StayNestApi {
  @override
  Future<Map<String, dynamic>> booking(int id) async => {
    'id': id,
    'status': 'PENDING_PAYMENT',
  };
}

void main() {
  testWidgets('pending booking never renders payment success', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [stayNestApiProvider.overrideWithValue(PendingBookingApi())],
        child: const MaterialApp(home: LivePaymentSuccessScreen(bookingId: 42)),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Đặt phòng này chưa được xác nhận thanh toán mô phỏng.'),
      findsOneWidget,
    );
    expect(find.text('Đặt phòng đã xác nhận'), findsNothing);
  });
}
