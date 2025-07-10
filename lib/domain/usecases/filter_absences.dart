import 'package:crewmeister/data/models/paged_absence_result.dart';
import 'package:flutter/material.dart';

import '../../core/error/failure.dart';
import '../repositories/absence_repository.dart';
 import 'package:dartz/dartz.dart';
 
class FilterAbsencesUseCase {
  final AbsenceRepository repository;

  FilterAbsencesUseCase(this.repository);

  Future<Either<Failure, PagedAbsenceResult>> call({
    required int page,
    String? typeFilter,
    DateTimeRange? dateFilter,
    int limit = 10,
  }) {
    return repository.getAbsences(
      page: page,
      typeFilter: typeFilter,
      limit: limit,
      dateFilter: dateFilter,
    );
  }
}
