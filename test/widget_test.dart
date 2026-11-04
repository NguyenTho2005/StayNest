import 'package:flutter_test/flutter_test.dart';
import 'package:staynest/data/staynest_api.dart';

void main() {
  test('booking request uses selected dates and guest capacity', () {
    final draft = BookingDraft()
      ..checkIn = DateTime(2027, 2, 9)
      ..checkOut = DateTime(2027, 2, 12)
      ..adults = 3
      ..children = 1
      ..roomCount = 2;

    expect(draft.details(42), {
      'roomTypeId': 42,
      'checkIn': '2027-02-09',
      'checkOut': '2027-02-12',
      'adults': 3,
      'children': 1,
      'roomCount': 2,
      'promotionCode': 'STAY100',
    });
  });
}
