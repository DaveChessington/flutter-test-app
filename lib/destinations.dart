import 'package:flutter/material.dart';
import 'package:my_app/admin/home.dart';
import 'package:my_app/profile.dart';
import 'package:my_app/role.dart';
import 'package:my_app/user/home.dart';

enum Destination{
  userHome(name:"Home",icon:Icon(Icons.home),widgetBuilder:UserHome.new,role:Role.USER),
  adminHome(name:"Admin Console",icon:Icon(Icons.settings),widgetBuilder:AdminHome.new, role:Role.ADMIN),
  profile(name: "Profile",icon: Icon(Icons.person),widgetBuilder: Profile.new, role: null);

  final String name;
  final Icon icon;
  final Widget Function() widgetBuilder; //save the function that builds the widget
  final Role? role;

  const Destination({
    required this.name,required this.icon, required this.widgetBuilder, this.role
  });

}