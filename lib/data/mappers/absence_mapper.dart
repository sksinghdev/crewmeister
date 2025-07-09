import '../../domain/entities/absence.dart';
import '../models/absence_model.dart';
import '../models/member_model.dart';

class AbsenceMapper {
  static Absence toDomain(AbsenceModel absence, MemberModel? member) {
    String status;
    if (absence.rejectedAt != null) {
      status = 'Rejected';
    } else if (absence.confirmedAt != null) {
      status = 'Confirmed';
    } else {
      status = 'Requested';
    }

    return Absence(
      id: absence.id,
      memberName: member?.name ?? 'Unknown',
      memberImage: member?.image ?? 'https://via.placeholder.com/150',
      type: absence.type,
      startDate: absence.startDate,
      endDate: absence.endDate,
      memberNote: absence.memberNote,
      admitterNote: absence.admitterNote,
      status: status,
      userId: absence.userId,
    );
  }
}
