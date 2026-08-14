import 'package:flutter/material.dart';
import 'package:my_app/API/api_service.dart';
import 'package:my_app/models/User.dart';
import 'package:my_app/role.dart';

class EditForm extends StatefulWidget {
  const EditForm({super.key, required this.onClickSave, this.id});

  final int? id;
  final Function onClickSave;

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final ApiService apiService = ApiService();
  late User user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    if (widget.id != null) {
      user = (await apiService.getUserById(widget.id!)) ?? User();
    } else {
      user = User();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    TextEditingController nameController = TextEditingController(
      text: user.name,
    );
    TextEditingController emailController = TextEditingController(
      text: user.email,
    );
    TextEditingController confirmController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Form(
      child: Column(
        children: [
          if (widget.id != null)
            FutureBuilder<ImageProvider?>(
              future: apiService.getAvatar(widget.id!),
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
          ElevatedButton(onPressed: () {}, child: const Text("Change Avatar")),
          const SizedBox(height: 15),
          if (widget.id != null) ...[
            Text("id: ${widget.id}"),
            Text("Created at: ${user.createdAt}"),
            Text("Updated at: ${user.updatedAt}"),
            Text("Deleted at: ${user.deletedAt}"),
            Text("Edit Profile"),
          ] else ...[
            Text("Create Profile"),
          ],
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          DropdownButtonFormField(
            initialValue: user.role,
            items: [
              DropdownMenuItem(value: Role.ADMIN, child: Text('Admin')),
              DropdownMenuItem(value: Role.USER, child: Text('User')),
            ],
            onChanged: (value) {
              setState(() {
                user.role = value!;
              });
            },
          ),
          TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: confirmController,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: widget.onClickSave(),
            child: Text(widget.id != null ? "Save" : "Create"),
          ),
        ],
      ),
    );
  }
}
