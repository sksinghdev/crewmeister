import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:crewmeister/core/error/failure.dart';
import 'package:crewmeister/domain/entities/absence.dart';
import 'package:crewmeister/data/models/paged_absence_result.dart';
import 'package:crewmeister/domain/repositories/absence_repository.dart';

class MockAbsenceRepository extends Mock implements AbsenceRepository {}

void main() {
  late MockAbsenceRepository mockRepository;

  setUp(() {
    mockRepository = MockAbsenceRepository();
  });

  final testAbsences = [
    Absence(
      id: 1,
      type: 'vacation',
      startDate: DateTime(2023, 1, 1),
      endDate: DateTime(2023, 1, 3),
      memberNote: 'Out of office',
      admitterNote: null,
      status: 'CONFIRMED',
      userId: 1,
      memberName: 'John Doe',
      memberImage: 'image.png',
    )
  ];

  final pagedResult = PagedAbsenceResult(
    absences: testAbsences,
    totalCount: 1,
  );

  final dateRange = DateTimeRange(
    start: DateTime(2023, 1, 1),
    end: DateTime(2023, 1, 10),
  );

  test('getAbsences returns paged result on success', () async {
    // Arrange
    when(() => mockRepository.getAbsences(
          page: 1,
          limit: 10,
          typeFilter: 'vacation',
          dateFilter: dateRange,
        )).thenAnswer((_) async => Right(pagedResult));

    // Act
    final result = await mockRepository.getAbsences(
      page: 1,
      limit: 10,
      typeFilter: 'vacation',
      dateFilter: dateRange,
    );

    // Assert
    expect(result, Right(pagedResult));
    verify(() => mockRepository.getAbsences(
          page: 1,
          limit: 10,
          typeFilter: 'vacation',
          dateFilter: dateRange,
        )).called(1);
  });

  test('getTotalAbsenceCount returns failure on error', () async {
    // Arrange
    final failure = const ServerFailure('Something went wrong');
    when(() => mockRepository.getTotalAbsenceCount(
          typeFilter: null,
          dateFilter: null,
        )).thenAnswer((_) async => Left(failure));

    // Act
    final result = await mockRepository.getTotalAbsenceCount();

    // Assert
    expect(result, Left(failure));
    verify(() => mockRepository.getTotalAbsenceCount(
          typeFilter: null,
          dateFilter: null,
        )).called(1);
  });

  test('generateICalFile returns a file', () async {
    final dummyFile = File('dummy.ics');
    when(() => mockRepository.generateICalFile(any()))
        .thenAnswer((_) async => dummyFile);

    final result = await mockRepository.generateICalFile(testAbsences);

    expect(result, dummyFile);
    verify(() => mockRepository.generateICalFile(testAbsences)).called(1);
  });
}
