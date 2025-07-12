

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/absence.dart';
 
class ICalGenerator {
    Future<File> generateICS(List<Absence> absences) async {
    final buffer = StringBuffer();

    buffer.writeln('BEGIN:VCALENDAR');
    buffer.writeln('VERSION:2.0');
    buffer.writeln('PRODID:-//Crewmeister//Absence Calendar//EN');

    for (var absence in absences) {
      final start = DateFormat('yyyyMMdd').format(absence.startDate);
      final end = DateFormat('yyyyMMdd').format(absence.endDate.add(const Duration(days: 1)));  

      buffer.writeln('BEGIN:VEVENT');
      buffer.writeln('UID:${absence.id}@crewmeister.com');
      buffer.writeln('DTSTAMP:${DateFormat('yyyyMMddTHHmmssZ').format(DateTime.now().toUtc())}');
      buffer.writeln('DTSTART:$start');
      buffer.writeln('DTEND:$end');
      buffer.writeln('SUMMARY:${absence.type.toUpperCase()} - ${absence.memberName}');
      buffer.writeln('DESCRIPTION:Status: ${absence.status}\\nNotes: ${absence.memberNote ?? 'None'}');
      buffer.writeln('END:VEVENT');
    }

    buffer.writeln('END:VCALENDAR');

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/absences.ics');
    return file.writeAsString(buffer.toString());  
  }
}
