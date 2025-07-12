import 'package:flutter_test/flutter_test.dart';
import 'package:crewmeister/core/api/api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Every member has required keys', () {
    final requiredKeys = ['id', 'name', 'userId', 'image'];

    for (final key in requiredKeys) {
      test('Member contains key: $key', () async {
        final memberData = await members();
        for (final member in memberData) {
          expect(member.containsKey(key), isTrue, reason: 'Missing key: $key');
        }
      });
    }
  });

  group('Every absence has required keys', () {
    final requiredKeys = [
      'admitterNote',
      'confirmedAt',
      'createdAt',
      'crewId',
      'endDate',
      'id',
      'memberNote',
      'rejectedAt',
      'startDate',
      'type',
      'userId',
    ];

    for (final key in requiredKeys) {
      test('Absence contains key: $key', () async {
        final absenceData = await absences();
        for (final absence in absenceData) {
          expect(absence.containsKey(key), isTrue, reason: 'Missing key: $key');
        }
      });
    }
  });
}
