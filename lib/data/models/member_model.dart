import 'package:equatable/equatable.dart';
import '../../domain/entities/member.dart';

class MemberModel extends Equatable {
  final int userId;
  final String name;
  final String image;

  const MemberModel({
    required this.userId,
    required this.name,
    required this.image,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      userId: json['userId'],
      name: json['name'],
      image: json['image'],
    );
  }

  Member toEntity() => Member(
        userId: userId,
        name: name,
        image: image,
      );

  @override
  List<Object?> get props => [userId, name, image];
}
