import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import '../entities/absence.dart';
import '../../../../core/error/failure.dart';

abstract class AbsenceRepository {
  Future<Either<Failure, List<Absence>>> getAbsences({
    int page,
    int limit,
    String? type,
    DateTimeRange? dateRange,
  });

  Future<Either<Failure, int>> getTotalAbsenceCount();
}
