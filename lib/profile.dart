import 'package:flutter/material.dart';
import 'package:my_app/models/User.dart';
import 'package:my_app/role.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User example = User(
    id: 1,
    name: "John Doe",
    email: "john.doe@example.com",
    password: "secret_password",
    role: Role.USER,
    isAproved: false,
    profilePhoto: "assets/placeholder.png",
    createdAt: "2026-01-01",
    updatedAt: "2026-07-23",
    deletedAt: null,
  );

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = example.name ?? "";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Image(image: AssetImage("assets/placeholder.png"), height: 250),
          const SizedBox(height: 15),
          const Text(
            "ACCOUNT",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const Text(
            "Profile Info",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(onPressed: () {}, child: const Text("Change Avatar")),
          const SizedBox(height: 15),

          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
              hintText: 'Enter Name',
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Column(
                children: [
                  const Text(
                    "Rol",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(example.role.name),
                ],
              ),
              Column(
                children: [
                  const Text(
                    "Email Address",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(example.email ?? "No email provided"),
                ],
              ),
            ],
          ),

          const SizedBox(height: 15),
          const Text(
            "Member Since",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 5),
          Text(example.createdAt ?? "N/A"),
          const SizedBox(height: 15),
          const Text(
            "Last Updated",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 5),
          Text(example.updatedAt ?? "N/A"),
          const SizedBox(height: 15),
          const Divider(
            color: Colors.grey,
            thickness: 2,
            indent: 20,
            endIndent: 20,
            height: 40,
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _passController,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              hintText: 'Enter Password',
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _confirmController,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Confirm Password',
              hintText: 'Confirm password',
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              //TODO
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text("Update Profile"),
          ),
        ],
      ),
    );
  }
}
