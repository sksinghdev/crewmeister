import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:crewmeister/domain/usecases/get_absences.dart';
import 'package:crewmeister/domain/repositories/absence_repository.dart';
import 'package:crewmeister/data/models/paged_absence_result.dart';
import 'package:crewmeister/domain/entities/absence.dart';
import 'package:crewmeister/core/error/failure.dart';

class MockAbsenceRepository extends Mock implements AbsenceRepository {}

void main() {
  late GetAbsencesUseCase useCase;
  late MockAbsenceRepository repository;

  setUp(() {
    repository = MockAbsenceRepository();
    useCase = GetAbsencesUseCase(repository);
  });

  const int page = 1;
  const int limit = 10;
  const String typeFilter = 'vacation';
  final dateFilter = DateTimeRange(
    start: DateTime(2023, 1, 1),
    end: DateTime(2023, 1, 10),
  );

  final tAbsences = [
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
    ),
  ];

  final tPagedResult = PagedAbsenceResult(absences: tAbsences, totalCount: 1);

  test(
      'Given valid filters, When repository returns data, Then it returns Right with PagedAbsenceResult',
      () async {
    // Arrange
    when(() => repository.getAbsences(
          page: page,
          limit: limit,
          typeFilter: typeFilter,
          dateFilter: dateFilter,
        )).thenAnswer((_) async => Right(tPagedResult));

    // Act
    final result = await useCase(
      page: page,
      limit: limit,
      typeFilter: typeFilter,
      dateFilter: dateFilter,
    );

    // Assert
    expect(result, Right(tPagedResult));
    verify(() => repository.getAbsences(
          page: page,
          limit: limit,
          typeFilter: typeFilter,
          dateFilter: dateFilter,
        )).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('Given repository fails, When called, Then it returns Left with Failure',
      () async {
    // Arrange
    final failure = const ServerFailure('Something went wrong');
    when(() => repository.getAbsences(
          page: page,
          limit: limit,
          typeFilter: typeFilter,
          dateFilter: dateFilter,
        )).thenAnswer((_) async => Left(failure));

    // Act
    final result = await useCase(
      page: page,
      limit: limit,
      typeFilter: typeFilter,
      dateFilter: dateFilter,
    );

    // Assert
    expect(result, Left(failure));
    verify(() => repository.getAbsences(
          page: page,
          limit: limit,
          typeFilter: typeFilter,
          dateFilter: dateFilter,
        )).called(1);
    verifyNoMoreInteractions(repository);
  });
}
