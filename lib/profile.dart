import 'package:flutter/material.dart';
import 'package:my_app/API/api_service.dart';
import 'package:my_app/models/User.dart';
import 'package:my_app/role.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, this.user});
  final User? user;

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user?.name ?? "";
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
    final apiService = ApiService();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (widget.user?.id != null)
            FutureBuilder<ImageProvider?>(
              future: apiService.getAvatar(widget.user!.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 250,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final imageProvider =
                    snapshot.data ?? const AssetImage("assets/placeholder.png");
                return Image(image: imageProvider, height: 250);
              },
            )
          else
            const Image(
              image: AssetImage("assets/placeholder.png"),
              height: 250,
            ),
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
                  Text(widget.user?.role.name ?? Role.USER.name),
                ],
              ),
              const SizedBox(width: 15),
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
                  Text(widget.user?.email ?? "No email provided"),
                ],
              ),
            ],
          ),

          const SizedBox(height: 15),
          Row(
            children: [
              Column(
                children: [
                  const Text(
                    "Member Since",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(widget.user?.createdAt ?? "N/A"),
                ],
              ),
              const SizedBox(width: 15),
              Column(
                children: [
                  const Text(
                    "Last Updated",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(widget.user?.updatedAt ?? "N/A"),
                ],
              ),
            ],
          ),
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
