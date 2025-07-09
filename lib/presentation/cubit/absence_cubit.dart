import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/absence.dart';
import '../../domain/repositories/absence_repository.dart';

part 'absence_state.dart';

class AbsenceCubit extends Cubit<AbsenceState> {
  final AbsenceRepository repository;

  int _currentPage = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;
  List<Absence> _allAbsences = [];

  AbsenceCubit(this.repository) : super(AbsenceInitial());

  void loadAbsences({bool refresh = false, String? typeFilter, DateTimeRange? dateFilter}) async {
    if (state is AbsenceLoading) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _allAbsences.clear();
    }

    emit(AbsenceLoading(absences: _allAbsences, isFirstFetch: _currentPage == 1));
    print('Loading page $_currentPage, hasMore: $_hasMore');
  
  final result = await repository.getAbsences(
    page: _currentPage,
    typeFilter: typeFilter,
    limit: 10,
    dateFilter: dateFilter,
  );

  result.fold(
    (failure) {
      emit(AbsenceError(failure.message));
    },
    (data) {
      if (data.isEmpty) {
        _hasMore = false;
      } else {
        _currentPage++;
        _allAbsences.addAll(data);
      }

      if (_allAbsences.isEmpty) {
        emit(AbsenceEmpty());
      } else {
        emit(AbsenceLoaded(absences: _allAbsences, hasMore: _hasMore));
      }
    },
  );


  }
}
