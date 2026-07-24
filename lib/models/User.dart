//model for both user and admin
import 'package:my_app/role.dart';

class User{
  int? id;
  String? name;
  String? email;
  String? password;
  Enum role=Role.USER;
  bool isAproved=false;
  String? profilePhoto;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    required this.role,
    this.isAproved = false,
    this.profilePhoto,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });
}