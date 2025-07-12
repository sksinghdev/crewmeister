import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:crewmeister/core/utils/single_emit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/absence.dart';
import '../../domain/services/share_service.dart';
import '../../domain/usecases/filter_absences.dart';
import '../../domain/usecases/generate_and_share_ical.dart';
import '../../domain/usecases/get_absence_count.dart';
import '../../domain/usecases/get_absences.dart';

part 'absence_state.dart';

class AbsenceCubit extends Cubit<AbsenceState> {
  final GetAbsencesUseCase getAbsencesUseCase;
  final GetAbsenceCountUseCase getAbsenceCountUseCase;
  final FilterAbsencesUseCase filterAbsencesUseCase;
  final GenerateAndShareICal generateICalUseCase;
  final ShareService shareService;

  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMore = true;
  bool get hasMore => _hasMore;
  final List<Absence> _allAbsences = [];

  AbsenceCubit({
    required this.getAbsencesUseCase,
    required this.getAbsenceCountUseCase,
    required this.filterAbsencesUseCase,
    required this.generateICalUseCase,
    required this.shareService,
  }) : super(AbsenceInitial());

  void loadAbsences({
    bool isRefresh = false,
    String? typeFilter,
    DateTimeRange? dateFilter,
  }) async {
    if (state is AbsenceLoading) return;

    if (isRefresh) {
      _currentPage = 1;
      _hasMore = true;
      _allAbsences.clear();
    }

    emit(AbsenceLoading(absences: [], isFirstFetch: _currentPage == 1));

    final result = await getAbsencesUseCase(
      page: _currentPage,
      limit: _limit,
      typeFilter: typeFilter,
      dateFilter: dateFilter,
    );

    result.fold(
      (failure) => emit(AbsenceError(failure.message)),
      (pagedResult) {
        final data = pagedResult.absences;
        final totalCount = pagedResult.totalCount;

        _hasMore = (_allAbsences.length + data.length) < totalCount;

        if (data.isNotEmpty) {
          _allAbsences.addAll(data);
          _currentPage++;
        }

        if (_allAbsences.isEmpty) {
          emit(AbsenceEmpty());
        } else {
          emit(AbsenceLoaded(
              absences: _allAbsences,
              hasMore: _hasMore,
              page: _currentPage - 1,
              totalAbsence: totalCount));
        }
      },
    );
  }

  void loadMore({
    String? typeFilter,
    DateTimeRange? dateFilter,
  }) {
    if (_hasMore) {
      loadAbsences(
        isRefresh: false,
        typeFilter: typeFilter,
        dateFilter: dateFilter,
      );
    }
  }

  void refresh({
    String? typeFilter,
    DateTimeRange? dateFilter,
  }) {
    loadAbsences(
      isRefresh: true,
      typeFilter: typeFilter,
      dateFilter: dateFilter,
    );
  }

  Future<void> getAbsenceCount({
    String? typeFilter,
    DateTimeRange? dateFilter,
  }) async {
    final result = await getAbsenceCountUseCase(
      typeFilter: typeFilter,
      dateFilter: dateFilter,
    );

    result.fold(
      (failure) => emit(AbsenceError(failure.message)),
      (count) => emit(AbsenceCountLoaded(count)),
    );
  }

  Future<void> exportAbsencesToICal(List<Absence> absences) async {
    emitSingleTop(AbsenceExporting());
    try {
      final File icalFile = await generateICalUseCase(absences);
      await shareService.shareFile(
        icalFile,
        text: 'Absence Calendar',
        subject: 'Absences',
      );

      emitSingleTop(AbsenceExportSuccess());
    } catch (e) {
      emitSingleTop(
          const AbsenceExportFailure('Failed to generate iCal file.'));
    }
  }
}
