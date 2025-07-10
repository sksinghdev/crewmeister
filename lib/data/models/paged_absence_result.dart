import '../../domain/entities/absence.dart';

class PagedAbsenceResult {
  final List<Absence> absences;
  final int totalCount;

  PagedAbsenceResult({
    required this.absences,
    required this.totalCount,
  });
}
