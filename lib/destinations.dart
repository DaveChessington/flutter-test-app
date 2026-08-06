import 'package:flutter/material.dart';
import 'package:my_app/admin/home.dart';
import 'package:my_app/models/User.dart';
import 'package:my_app/profile.dart';
import 'package:my_app/role.dart';
import 'package:my_app/user/home.dart';

enum Destination {
  userHome(
    name: "Home",
    icon: Icon(Icons.home),
    widgetBuilder: _userHomeBuilder,
    role: Role.USER,
  ),
  adminHome(
    name: "Admin Console",
    icon: Icon(Icons.settings),
    widgetBuilder: _adminHomeBuilder,
    role: Role.ADMIN,
  ),
  profile(
    name: "Profile",
    icon: Icon(Icons.person),
    widgetBuilder: _profileBuilder,
    role: null,
  );

  final String name;
  final Icon icon;
  final Widget Function(User? user) widgetBuilder;
  final Role? role;

  const Destination({
    required this.name,
    required this.icon,
    required this.widgetBuilder,
    this.role,
  });
}

Widget _userHomeBuilder(User? user) => const UserHome();
Widget _adminHomeBuilder(User? user) => const AdminHome();
Widget _profileBuilder(User? user) => Profile(user: user);
