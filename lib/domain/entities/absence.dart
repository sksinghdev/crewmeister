import 'package:equatable/equatable.dart';

class Absence extends Equatable {
  final int id;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final String? memberNote;
  final String? admitterNote;
  final String status;
  final int userId;
  final String memberName;
  final String memberImage;

  const Absence({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    this.memberNote,
    this.admitterNote,
    required this.status,
    required this.userId,
    required  this.memberName,
    required this.memberImage,
  });

  @override
  List<Object?> get props => [
        id, type, startDate, endDate,
        memberNote, admitterNote, status, userId,memberName,memberImage
      ];
}
