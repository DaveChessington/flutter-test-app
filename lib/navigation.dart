import 'package:flutter/material.dart';
import 'package:my_app/destinations.dart';
import 'package:my_app/role.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key, required this.chosenRole});
  final Role chosenRole;

  @override
  State<StatefulWidget> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;
  final List<NavigationDestination> _navigationDestinations = [];
  final List<(Widget,Destination)> _screens = [];

  @override
  void initState() {
    super.initState();
    
    for (var d in Destination.values) {
      if (d.role == widget.chosenRole || d.role==null) { 
        _navigationDestinations.add(
          NavigationDestination(
            icon: d.icon,
            label: d.name,
          ),
        );
        _screens.add((d.widgetBuilder(),d)); 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_screens.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No tienes acceso a ninguna pantalla")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_currentIndex].$2.name),
        leading: _screens[_currentIndex].$2.icon,
        actions: [IconButton(onPressed: (){
          //log out logic 
          Navigator.pop(context);
        },icon: Icon(Icons.logout),tooltip: "Log out",)],
      ),
      body: _screens[_currentIndex].$1,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index; 
          });
        },
        destinations: _navigationDestinations, 
      ),
    );
  }
} 
