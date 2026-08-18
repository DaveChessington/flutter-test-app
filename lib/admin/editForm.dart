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

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController confirmController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    confirmController = TextEditingController();
    passwordController = TextEditingController();
    _loadUser();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    confirmController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    if (widget.id != null) {
      user = (await apiService.getUserById(widget.id!)) ?? User();
    } else {
      user = User();
    }

    nameController.text = user.name ?? '';
    emailController.text = user.email ?? '';

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? "Edit Profile" : "Create Profile"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar Section
              Center(
                child: Stack(
                  children: [
                    if (widget.id != null)
                      FutureBuilder<ImageProvider?>(
                        future: apiService.getAvatar(widget.id!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircleAvatar(
                              radius: 60,
                              child: CircularProgressIndicator(),
                            );
                          }
                          final imageProvider =
                              snapshot.data ??
                              const AssetImage("assets/placeholder.png");
                          return CircleAvatar(
                            radius: 60,
                            backgroundImage: imageProvider,
                          );
                        },
                      )
                    else
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage("assets/placeholder.png"),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Metadata Info (Read-Only Badges)
              if (widget.id != null) ...[
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ID: ${widget.id}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        Text(
                          "Created: ${user.createdAt ?? 'N/A'}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Updated: ${user.updatedAt ?? 'N/A'}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Form Inputs
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter some text'
                    : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter some text'
                    : null,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<Role>(
                value: user.role,
                decoration: InputDecoration(
                  labelText: 'Role',
                  prefixIcon: const Icon(Icons.security),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: Role.ADMIN, child: Text('Admin')),
                  DropdownMenuItem(value: Role.USER, child: Text('User')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      user.role = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter some text'
                    : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: confirmController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter some text'
                    : null,
              ),

              const SizedBox(height: 28),

              // Action Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => widget.onClickSave(),
                  child: Text(
                    widget.id != null ? "Save Changes" : "Create Profile",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
