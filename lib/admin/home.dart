import 'package:flutter/material.dart';
import 'package:my_app/API/api_service.dart';
import 'package:my_app/admin/editForm.dart';
import 'package:my_app/widgets/custom_card.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  /// Incrementing this triggers the FutureBuilder to re-fetch the user list.
  int _refreshKey = 0;

  void _refresh() {
    setState(() => _refreshKey++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        key: ValueKey(_refreshKey),
        future: ApiService().getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CustomCardWidget(
                  user: snapshot.data![index],
                  onRefresh: _refresh,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditForm(onClickSave: _refresh),
            ),
          );
        },
        backgroundColor: Colors.blue,
        tooltip: 'Crear usuario',
        child: const Icon(Icons.add),
      ),
    );
  }
}
