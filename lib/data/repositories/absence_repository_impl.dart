import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../core/api/api.dart';
import '../../core/error/failure.dart';
import '../../domain/repositories/absence_repository.dart';
import '../mappers/absence_mapper.dart';
import '../models/absence_model.dart';
import '../models/member_model.dart';
import '../models/paged_absence_result.dart';

class AbsenceRepositoryImpl implements AbsenceRepository {
  AbsenceRepositoryImpl();

  @override
  Future<Either<Failure, PagedAbsenceResult>> getAbsences({
    int page = 1,
    int limit = 10,
    String? typeFilter,
    DateTimeRange? dateFilter,
  }) async {
    try {
      final absencesRawData = await absences();
      final membersRawData = await members();
      final absenceModelList =
          absencesRawData.map((json) => AbsenceModel.fromJson(json)).toList();
      final memberList =
          membersRawData.map((json) => MemberModel.fromJson(json)).toList();

      final filtered = _getFilteredList(
        absenceModelList,
        typeFilter,
        dateFilter,
      );

      final paginated = filtered.skip((page - 1) * limit).take(limit).toList();
      final result2 = paginated.map((a) {
        final member = memberList.firstWhere(
          (m) => m.userId == a.userId,
          orElse: () =>
              MemberModel(userId: a.userId, name: 'Unknown', image: 'Unknown'),
        );
        return AbsenceMapper.toDomain(a, member);
      }).toList();

      return Right(PagedAbsenceResult(absences: result2, totalCount: filtered.length));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalAbsenceCount({
    String? typeFilter,
    DateTimeRange? dateFilter,
  }) async {
    try {
      final absenceModelList = await absences();
      final filtered = _getFilteredList(
        absenceModelList.map((json) => AbsenceModel.fromJson(json)).toList(),
        typeFilter,
        dateFilter,
      );

      return Right(filtered.length);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  List<dynamic> _getFilteredList(
    List<dynamic> absenceModelList,
    String? typeFilter,
    DateTimeRange? dateFilter,
  ) {
    final filtered = absenceModelList.where((a) {
      final start = a.startDate;
      final end = a.endDate;

      if (typeFilter != null && a.type != typeFilter) return false;
      if (dateFilter != null &&
          (end.isBefore(dateFilter.start) || start.isAfter(dateFilter.end))) {
        return false;
      }

      return true;
    }).toList();

    return filtered;
  }
}
