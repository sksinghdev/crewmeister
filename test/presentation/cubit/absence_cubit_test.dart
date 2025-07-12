import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:crewmeister/core/error/failure.dart';
import 'package:crewmeister/data/models/paged_absence_result.dart';
import 'package:crewmeister/domain/services/share_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:crewmeister/domain/entities/absence.dart';
import 'package:crewmeister/domain/usecases/generate_and_share_ical.dart';
import 'package:crewmeister/domain/usecases/get_absence_count.dart';
import 'package:crewmeister/domain/usecases/get_absences.dart';
import 'package:crewmeister/domain/usecases/filter_absences.dart';
import 'package:crewmeister/presentation/cubit/absence_cubit.dart';
import 'package:share_plus/share_plus.dart';

class MockShareService extends Mock implements ShareService {}

class MockGetAbsences extends Mock implements GetAbsencesUseCase {}

class MockGetAbsenceCount extends Mock implements GetAbsenceCountUseCase {}

class MockFilterAbsences extends Mock implements FilterAbsencesUseCase {}

class MockGenerateICalUseCase extends Mock implements GenerateAndShareICal {}

class MockFile extends Mock implements File {}

class FakeXFile extends Fake implements XFile {}

void main() {
  late AbsenceCubit cubit;
  late MockGetAbsences getAbsences;
  late MockGetAbsenceCount getAbsenceCount;
  late MockFilterAbsences filterAbsences;
  late MockGenerateICalUseCase generateICal;
  late MockShareService shareService;
  final mockFile = MockFile();
  shareService = MockShareService();

  setUp(() {
    getAbsences = MockGetAbsences();
    getAbsenceCount = MockGetAbsenceCount();
    filterAbsences = MockFilterAbsences();
    generateICal = MockGenerateICalUseCase();
    when(() => shareService.shareFile(any(),
        text: any(named: 'text'),
        subject: any(named: 'subject'))).thenAnswer((_) async {});
    cubit = AbsenceCubit(
      getAbsencesUseCase: getAbsences,
      getAbsenceCountUseCase: getAbsenceCount,
      filterAbsencesUseCase: filterAbsences,
      generateICalUseCase: generateICal,
      shareService: shareService,
    );
  });
  setUpAll(() {
    registerFallbackValue(shareService);
    registerFallbackValue(FakeXFile());
    registerFallbackValue(mockFile);
  });

  group('AbsenceCubit', () {
    final tAbsences = [
      Absence(
        id: 1,
        type: 'sickness',
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 1, 3),
        memberNote: 'Flu',
        admitterNote: null,
        status: 'CONFIRMED',
        userId: 1,
        memberName: 'John Doe',
        memberImage: 'image.png',
      )
    ];

    test('initial state is AbsenceInitial', () {
      expect(cubit.state, AbsenceInitial());
    });

    blocTest<AbsenceCubit, AbsenceState>(
      'Given valid response, When loadAbsences is called, Then emits [AbsenceLoading, AbsenceLoaded]',
      build: () {
        when(() => getAbsences(
              page: 1,
              limit: 10,
              typeFilter: any(named: 'typeFilter'),
              dateFilter: any(named: 'dateFilter'),
            )).thenAnswer(
          (_) async => Right(PagedAbsenceResult(
            absences: List.of(tAbsences), // ✅ CRUCIAL!
            totalCount: 1,
          )),
        );

        return AbsenceCubit(
          getAbsencesUseCase: getAbsences,
          getAbsenceCountUseCase: getAbsenceCount,
          filterAbsencesUseCase: filterAbsences,
          generateICalUseCase: generateICal,
          shareService: shareService,
        );
      },
      act: (cubit) => cubit.loadAbsences(isRefresh: false),
      expect: () => [
        const AbsenceLoading(absences: [], isFirstFetch: true),
        AbsenceLoaded(
            absences: tAbsences, hasMore: false, page: 1, totalAbsence: 1),
      ],
    );

    blocTest<AbsenceCubit, AbsenceState>(
      'emits [AbsenceLoading, AbsenceEmpty] when loadAbsences returns empty list',
      build: () {
        when(() => getAbsences(
              page: 1,
              limit: 10,
              typeFilter: any(named: 'typeFilter'),
              dateFilter: any(named: 'dateFilter'),
            )).thenAnswer(
          (_) async => Right(PagedAbsenceResult(absences: [], totalCount: 0)),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadAbsences(),
      expect: () => [
        const AbsenceLoading(absences: [], isFirstFetch: true),
        AbsenceEmpty(),
      ],
    );

    blocTest<AbsenceCubit, AbsenceState>(
      'emits [AbsenceLoading, AbsenceError] when loadAbsences fails',
      build: () {
        when(() => getAbsences(
              page: 1,
              limit: 10,
              typeFilter: any(named: 'typeFilter'),
              dateFilter: any(named: 'dateFilter'),
            )).thenAnswer(
          (_) async => const Left(ServerFailure('Error fetching data')),
        );
        return cubit;
      },
      act: (cubit) => cubit.loadAbsences(),
      expect: () => [
        const AbsenceLoading(absences: [], isFirstFetch: true),
        const AbsenceError('Error fetching data'),
      ],
    );

    blocTest<AbsenceCubit, AbsenceState>(
      'emits [AbsenceCountLoaded] when getAbsenceCount is successful',
      build: () {
        when(() => getAbsenceCount(
              typeFilter: any(named: 'typeFilter'),
              dateFilter: any(named: 'dateFilter'),
            )).thenAnswer((_) async => const Right(5));
        return cubit;
      },
      act: (cubit) => cubit.getAbsenceCount(),
      expect: () => [const AbsenceCountLoaded(5)],
    );

    blocTest<AbsenceCubit, AbsenceState>(
      'emits [AbsenceExporting, AbsenceExportSuccess] when exportAbsencesToICal succeeds',
      build: () {
        when(() => mockFile.path).thenReturn('path/to/fake.ics');
        when(() => generateICal(any())).thenAnswer((_) async => mockFile);

        return AbsenceCubit(
          getAbsencesUseCase: getAbsences,
          getAbsenceCountUseCase: getAbsenceCount,
          filterAbsencesUseCase: filterAbsences,
          generateICalUseCase: generateICal,
          shareService: shareService,
        );
      },
      act: (cubit) => cubit.exportAbsencesToICal(tAbsences),
      expect: () => [
        AbsenceExporting(),
        AbsenceInitial(),
        AbsenceExportSuccess(),
        AbsenceInitial()
      ],
    );

    blocTest<AbsenceCubit, AbsenceState>(
      'emits [AbsenceExporting, AbsenceInitial, AbsenceExportFailure, AbsenceInitial] when exportAbsencesToICal fails',
      build: () {
        when(() => generateICal(any())).thenThrow(Exception('fail'));
        return cubit;
      },
      act: (cubit) => cubit.exportAbsencesToICal(tAbsences),
      expect: () => [
        AbsenceExporting(),
        AbsenceInitial(),
        const AbsenceExportFailure('Failed to generate iCal file.'),
        AbsenceInitial(),
      ],
    );
  });
}
