import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/absence.dart';

class AbsenceCard extends StatelessWidget {
  final Absence absence;

  const AbsenceCard({super.key, required this.absence});

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green.shade600;
      case 'requested':
        return Colors.orange.shade600;
      case 'rejected':
        return Colors.red.shade600;
      default:
        return Colors.grey;
    }
  }

  String formatDateRange(DateTime start, DateTime end) {
    final format = DateFormat('dd MMM yyyy');
    return '${format.format(start)} to ${format.format(end)}';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(absence.status);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEBF5FF),
              Color(0xFFE3F2FD),
              Color(0xFFF1F8E9),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: absence.memberImage.isNotEmpty
                            ? NetworkImage(absence.memberImage)
                            : null,
                        backgroundColor: Colors.grey.shade300,
                        child: absence.memberImage.isEmpty
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          absence.memberName,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E1E1E),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          absence.status,
                          style: GoogleFonts.poppins(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  buildAbsenceTypeIcon(absence.type),
                  const SizedBox(height: 4),
                  Text(
                    "Period: ${formatDateRange(absence.startDate, absence.endDate)}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF444444),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (absence.memberNote != null &&
                      absence.memberNote!.isNotEmpty)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.note_alt_outlined,
                            size: 18, color: Color(0xFF666666)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            absence.memberNote!,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 6),
                  if (absence.admitterNote != null &&
                      absence.admitterNote!.isNotEmpty)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.comment_bank_outlined,
                            size: 18, color: Color(0xFF666666)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            absence.admitterNote!,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAbsenceTypeIcon(String type) {
    Icon iconData;
    Color iconColor;

    switch (type.toLowerCase()) {
      case 'sickness':
        iconData = const Icon(Icons.sick, size: 18);
        iconColor = Colors.teal;
        break;
      case 'vacation':
        iconData = const Icon(Icons.beach_access, size: 18);
        iconColor = Colors.blue;
        break;
      case 'personal':
        iconData = const Icon(Icons.person, size: 18);
        iconColor = Colors.green;
        break;
      default:
        iconData = const Icon(Icons.help_outline, size: 18);
        iconColor = Colors.grey;
    }

    return Row(
      children: [
        Icon(iconData.icon, color: iconColor, size: 18),
        const SizedBox(width: 6),
        Text(
          type,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF444444),
          ),
        ),
      ],
    );
  }
}
