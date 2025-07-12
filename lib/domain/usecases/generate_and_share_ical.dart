

import 'dart:io';
import '../entities/absence.dart';
import '../repositories/absence_repository.dart';

class GenerateAndShareICal {
  final AbsenceRepository repository;

  GenerateAndShareICal(this.repository);

  Future<File> call(List<Absence> absences) async {
    return repository.generateICalFile(absences);
  }
}
