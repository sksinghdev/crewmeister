import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import '../../data/models/paged_absence_result.dart';
import '../../../../core/error/failure.dart';
import '../entities/absence.dart';

abstract class AbsenceRepository {
  Future<Either<Failure, PagedAbsenceResult>> getAbsences({
    int page,
    int limit,
    String? typeFilter,
    DateTimeRange? dateFilter,
  });

  Future<Either<Failure, int>> getTotalAbsenceCount({
    String? typeFilter,
    DateTimeRange? dateFilter,
  });

  Future<Either<Failure, int>> getTotalAbsenceCountWethoutFilter();
  Future<File> generateICalFile(List<Absence> absences);
}
