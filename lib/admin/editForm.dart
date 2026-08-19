// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:my_app/API/api_service.dart';
import 'package:my_app/models/User.dart';
import 'package:my_app/role.dart';

class EditForm extends StatefulWidget {
  const EditForm({super.key, required this.onClickSave, this.id});

  final int? id;
  final VoidCallback onClickSave;

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final ApiService apiService = ApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late User user;
  bool isLoading = true;
  bool _isSaving = false;

  // Locally picked avatar (not yet uploaded)
  Uint8List? _pickedImageBytes;
  String? _pickedImageFilename;

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

  /// Opens the browser's native file picker and stores the bytes locally.
  void _pickAvatar() {
    final input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.click();
    input.onChange.listen((event) async {
      if (input.files == null || input.files!.isEmpty) return;
      final file = input.files!.first;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoad.first;
      final result = reader.result;
      final Uint8List bytes;
      if (result is ByteBuffer) {
        bytes = result.asUint8List();
      } else if (result is Uint8List) {
        bytes = result;
      } else {
        return;
      }
      if (!mounted) return;
      setState(() {
        _pickedImageBytes = bytes;
        _pickedImageFilename = file.name;
      });
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate passwords match when a new password is provided
    if (passwordController.text.isNotEmpty &&
        passwordController.text != confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Update user model with form values
      user.name = nameController.text;
      user.email = emailController.text;
      user.profilePhoto = _pickedImageFilename ?? user.profilePhoto;
      if (passwordController.text.isNotEmpty) {
        user.password = passwordController.text;
      }

      bool success;

      if (widget.id != null) {
        // ── Edit existing user ──
        success = await apiService.updateUser(widget.id!, user);
        if (success && _pickedImageBytes != null) {
          await apiService.updateProfilePhoto(
            widget.id!,
            _pickedImageBytes!,
            _pickedImageFilename ?? 'avatar.jpg',
          );
        }
      } else {
        // ── Create new user ──
        final createdUserId = await apiService.createUser(user);
        success = createdUserId != null;
        if (success && _pickedImageBytes != null) {
          success = await apiService.updateProfilePhoto(
            createdUserId!,
            _pickedImageBytes!,
            _pickedImageFilename ?? 'avatar.jpg',
          );
        }
      }

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.id != null
                  ? 'Usuario actualizado correctamente'
                  : 'Usuario creado correctamente',
            ),
            backgroundColor: Colors.green,
          ),
        );
        widget.onClickSave(); // notify parent (e.g. refresh list)
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al guardar. Intenta de nuevo.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _buildAvatar() {
    // Priority: locally picked > server > placeholder
    if (_pickedImageBytes != null) {
      return CircleAvatar(
        radius: 60,
        backgroundImage: MemoryImage(_pickedImageBytes!),
      );
    }
    if (widget.id != null) {
      return FutureBuilder<ImageProvider?>(
        future: apiService.getAvatar(widget.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircleAvatar(
              radius: 60,
              child: CircularProgressIndicator(),
            );
          }
          final provider =
              snapshot.data ?? const AssetImage('assets/placeholder.png');
          return CircleAvatar(radius: 60, backgroundImage: provider);
        },
      );
    }
    return const CircleAvatar(
      radius: 60,
      backgroundImage: AssetImage('assets/placeholder.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? 'Edit Profile' : 'Create Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Avatar ──────────────────────────────────────────────────
              Center(
                child: Stack(
                  children: [
                    _buildAvatar(),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          tooltip: 'Cambiar foto',
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                          onPressed: _pickAvatar,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Metadata (edit only) ─────────────────────────────────────
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
                          'ID: ${widget.id}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        Text(
                          'Created: ${user.createdAt ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Updated: ${user.updatedAt ?? 'N/A'}',
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

              // ── Name ────────────────────────────────────────────────────
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
                    ? 'Ingresa un nombre'
                    : null,
              ),

              const SizedBox(height: 16),

              // ── Email ────────────────────────────────────────────────────
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Ingresa un email'
                    : null,
              ),

              const SizedBox(height: 16),

              // ── Role ─────────────────────────────────────────────────────
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
                  if (value != null) setState(() => user.role = value);
                },
              ),

              const SizedBox(height: 16),

              // ── Approval status ─────────────────────────────────────────
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Usuario aprobado'),
                subtitle: Text(
                  user.isAproved
                      ? 'El usuario está aprobado'
                      : 'Pendiente de aprobación',
                ),
                value: user.isAproved,
                onChanged: (value) {
                  setState(() => user.isAproved = value);
                },
              ),

              const SizedBox(height: 16),

              // ── Password (optional when editing) ─────────────────────────
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: widget.id != null
                      ? 'Password (vacío = sin cambio)'
                      : 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  // Only required for new users
                  if (widget.id == null && (value == null || value.isEmpty)) {
                    return 'La contraseña es obligatoria';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ── Confirm Password ─────────────────────────────────────────
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
                validator: (value) {
                  if (widget.id == null && (value == null || value.isEmpty)) {
                    return 'Confirma la contraseña';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 28),

              // ── Save Button ──────────────────────────────────────────────
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          widget.id != null ? 'Save Changes' : 'Create Profile',
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
