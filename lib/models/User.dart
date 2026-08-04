//model for both user and admin
import 'package:my_app/role.dart';

class User {
  int? id;
  String? name;
  String? email;
  String? password;
  Enum role = Role.USER;
  bool isAproved = false;
  String? profilePhoto;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.role = Role.USER,
    this.isAproved = false,
    this.profilePhoto,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  void fromMap(Map user) {
    id = user["id"];
    name = user["name"];
    email = user["email"];
    password = user["password"];
    role = Role.values.byName(user["role"]);
    isAproved = user["is_aproved"];
    profilePhoto = user["profile_photo"];
    createdAt = user["created_at"];
    updatedAt = user["updated_at"];
    deletedAt = user["deleted_at"];
  }
}
