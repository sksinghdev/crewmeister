import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crewmeister/core/shared/ical/ical_generator.dart';
import 'package:crewmeister/data/repositories/absence_repository_impl.dart';
import 'package:crewmeister/domain/entities/absence.dart';
import 'package:crewmeister/domain/repositories/absence_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockICalGenerator extends Mock implements ICalGenerator {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AbsenceRepository repository;
  late MockICalGenerator mockGenerator;

  const fakeAbsencesJson = '''
  {
    "payload": [
      {
        "id": 1,
        "type": "vacation",
        "startDate": "2023-01-01",
        "endDate": "2023-01-03",
        "memberNote": "Out of office",
        "admitterNote": null,
        "status": "CONFIRMED",
        "userId": 1,
        "createdAt": "2023-01-01",
        "confirmedAt": "2023-01-01",
        "rejectedAt": null,
        "crewId": 1
      }
    ]
  }
  ''';

  const fakeMembersJson = '''
  {
    "payload": [
      {
        "userId": 1,
        "name": "John Doe",
        "image": "https://image.png"
      }
    ]
  }
  ''';

  // Mocks Flutter asset bundle loading
  void mockRootBundleJson() {
    ServicesBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async {
      final methodCall = const StandardMethodCodec().decodeMethodCall(message!);
      final String key = methodCall.arguments;

      if (key == 'assets/json_files/absences.json') {
        final encoded = utf8.encode(fakeAbsencesJson);
        final byteData = ByteData.view(Uint8List.fromList(encoded).buffer);
        return const StandardMethodCodec().encodeSuccessEnvelope(byteData);
      }

      if (key == 'assets/json_files/members.json') {
        final encoded = utf8.encode(fakeMembersJson);
        final byteData = ByteData.view(Uint8List.fromList(encoded).buffer);
        return const StandardMethodCodec().encodeSuccessEnvelope(byteData);
      }

      return null;
    });
  }

  setUp(() {
    mockGenerator = MockICalGenerator();
    repository = AbsenceRepositoryImpl(mockGenerator);
    mockRootBundleJson();
  });

  group('AbsenceRepositoryImpl', () {
    test('returns paged absences when getAbsences succeeds', () async {
      final result = await repository.getAbsences(page: 1);
      expect(result.isRight(), false);

      final data =
          result.getOrElse(() => throw Exception('Failed to get data'));
      expect(data.absences, isNotEmpty);
      expect(data.totalCount, greaterThan(0));
    });

    test('returns count of filtered absences', () async {
      final result = await repository.getTotalAbsenceCount();
      expect(result.isRight(), false);

      final count = result.getOrElse(() => -1);
      expect(count, lessThan(0));
    });

    test('returns count without filters', () async {
      final result = await repository.getTotalAbsenceCountWethoutFilter();
      expect(result.isRight(), false);

      final count = result.getOrElse(() => -1);
      expect(count, lessThan(0));
    });

    test('calls ICalGenerator.generateICS when generateICalFile is called',
        () async {
      final dummyFile = File('dummy.ics');

      when(() => mockGenerator.generateICS(any()))
          .thenAnswer((_) async => dummyFile);

      final result = await repository.generateICalFile([
        Absence(
          id: 1,
          type: 'vacation',
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 1, 2),
          memberNote: 'Note',
          admitterNote: null,
          status: 'CONFIRMED',
          userId: 1,
          memberName: 'John Doe',
          memberImage: 'image.png',
        ),
      ]);

      expect(result, isA<File>());
      verify(() => mockGenerator.generateICS(any())).called(1);
    });
  });
}
