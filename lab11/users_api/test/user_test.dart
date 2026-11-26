import 'package:flutter_test/flutter_test.dart';
import 'package:users_api/features/users/user.dart';

void main() {
  test('User.fromJson and User.toJson round trip', () {
    final json = <String, dynamic>{
      'id': 1,
      'name': 'Leanne Graham',
      'username': 'Bret',
      'email': 'test@example.com',
      'phone': '(123) 45-67',
      'website': null,
      'address': <String, dynamic>{
        'street': 'Kulas Light',
        'suite': 'Apt. 556',
        'city': 'Gwenborough',
        'zipcode': '92998',
        'geo': <String, dynamic>{'lat': '-37.3159', 'lng': '81.1496'},
      },
      'company': <String, dynamic>{
        'name': 'Romaguera-Crona',
        'catchPhrase': 'Multi-layered client-server',
      },
    };

    final user = User.fromJson(json);

    final roundTrip = User.fromJson(user.toJson());

    expect(roundTrip, user);

    expect(roundTrip.address.geo.lat, -37.3159);

    expect(roundTrip.phoneDigits, '1234567');

    expect(roundTrip.website, isNull);
  });

  test('Wrong coordinate type raises an error', () {
    expect(
      () => Geo.fromJson(<String, dynamic>{'lat': 5.0, 'lng': '2'}),
      throwsA(isA<TypeError>()),
    );
  });
}
