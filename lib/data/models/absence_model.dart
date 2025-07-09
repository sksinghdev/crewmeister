import 'package:equatable/equatable.dart';
import '../../domain/entities/absence.dart';

class AbsenceModel extends Equatable {
  final int id;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final String? memberNote;
  final String? admitterNote;
  final String? confirmedAt;
  final String? rejectedAt;
  final int userId;

  const AbsenceModel({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    this.memberNote,
    this.admitterNote,
    this.confirmedAt,
    this.rejectedAt,
    required this.userId,
  });

  factory AbsenceModel.fromJson(Map<String, dynamic> json) {
    final status = json["confirmedAt"] != null
        ? "Confirmed"
        : json["rejectedAt"] != null
            ? "Rejected"
            : "Requested";

    return AbsenceModel(
      id: json['id'],
      type: json['type'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      memberNote: json['memberNote'],
      admitterNote: json['admitterNote'],
      confirmedAt: status,
      rejectedAt: json['rejectedAt'],
      userId: json['userId'],
    );
  }

  Absence toEntity() {
    return Absence(
      id: id,
      type: type,
      startDate: startDate,
      endDate: endDate,
      memberNote: memberNote,
      admitterNote: admitterNote,
      status: confirmedAt! ,
      userId: userId,
      memberName:  '',
       memberImage:  '',
    );
  }

  @override
  List<Object?> get props => [
        id, type, startDate, endDate,
        memberNote, admitterNote, confirmedAt, rejectedAt, userId,
        
      ];
}
