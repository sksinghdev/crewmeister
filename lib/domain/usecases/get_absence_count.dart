import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../repositories/absence_repository.dart';
import '../../../../core/error/failure.dart';




class GetAbsenceCountUseCase {
  final AbsenceRepository repository;

  GetAbsenceCountUseCase(this.repository);

  Future<Either<Failure, int>> call({String? typeFilter, DateTimeRange? dateFilter}) {
    return repository.getTotalAbsenceCount(
      typeFilter: typeFilter,
      dateFilter: dateFilter,
    );
  }
}
