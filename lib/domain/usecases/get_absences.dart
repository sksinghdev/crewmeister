import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../core/error/failure.dart';
import '../../data/models/paged_absence_result.dart';
import '../repositories/absence_repository.dart';
 
class GetAbsencesUseCase {
  final AbsenceRepository repository;

  GetAbsencesUseCase(this.repository);

  Future<Either<Failure, PagedAbsenceResult>> call({
    required int page,
    int limit = 10,
    String? typeFilter,
    DateTimeRange? dateFilter,
  }) {
    return repository.getAbsences(
      page: page,
      limit: limit,
      typeFilter: typeFilter,
      dateFilter: dateFilter,
    );
  }
}
