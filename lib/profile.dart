// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Avatar state
  ImageProvider? _serverAvatar;
  bool _avatarLoaded = false;
  Uint8List? _pickedImageBytes;
  String? _pickedImageFilename;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user?.name ?? '';
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    if (widget.user?.id != null) {
      final avatar = await ApiService().getAvatar(widget.user!.id!);
      if (mounted) {
        setState(() {
          _serverAvatar = avatar;
          _avatarLoaded = true;
        });
      }
    } else {
      if (mounted) setState(() => _avatarLoaded = true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  /// Opens the browser's native file picker.
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

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passController.text.isNotEmpty &&
        _passController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final apiService = ApiService();

    try {
      final userId = widget.user?.id;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se puede actualizar: ID no disponible'),
          ),
        );
        return;
      }

      final updatedUser = User(
        id: userId,
        name: _nameController.text,
        email: widget.user?.email,
        role: widget.user?.role ?? Role.USER,
        password: _passController.text.isNotEmpty
            ? _passController.text
            : widget.user?.password,
      );

      final success = await apiService.updateUser(userId, updatedUser);

      if (success && _pickedImageBytes != null) {
        await apiService.updateProfilePhoto(
          userId,
          _pickedImageBytes!,
          _pickedImageFilename ?? 'avatar.jpg',
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Perfil actualizado correctamente'
                : 'Error al actualizar perfil',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) {
        // Clear password fields after successful update
        _passController.clear();
        _confirmController.clear();
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _buildAvatar() {
    // Priority: locally picked bytes > server image > placeholder
    ImageProvider? imageProvider;
    if (_pickedImageBytes != null) {
      imageProvider = MemoryImage(_pickedImageBytes!);
    } else {
      imageProvider = _serverAvatar;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: imageProvider,
          child: imageProvider == null
              ? const Icon(Icons.person, size: 50)
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Theme.of(context).primaryColor,
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: 'Cambiar foto',
              icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
              onPressed: _pickAvatar,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // ── Avatar ────────────────────────────────────────────────────
            if (!_avatarLoaded)
              const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              )
            else
              _buildAvatar(),

            const SizedBox(height: 15),

            const Text(
              'ACCOUNT',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Text(
              'Profile Info',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            // ── Name (editable) ───────────────────────────────────────────
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
                hintText: 'Enter Name',
              ),
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Ingresa un nombre' : null,
            ),

            const SizedBox(height: 15),

            // ── Read-only info ────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rol',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(widget.user?.role.name ?? Role.USER.name),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.user?.email ?? 'No email provided',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Member Since',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.user?.createdAt ?? 'N/A',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Last Updated',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.user?.updatedAt ?? 'N/A',
                      style: const TextStyle(fontSize: 13),
                    ),
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
            const SizedBox(height: 10),

            // ── Change password (optional) ────────────────────────────────
            TextFormField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password (vacío = sin cambio)',
                hintText: 'Nueva contraseña',
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm Password',
                hintText: 'Confirmar contraseña',
              ),
            ),

            const SizedBox(height: 25),

            // ── Save button ───────────────────────────────────────────────
            ElevatedButton(
              onPressed: _isSaving ? null : _updateProfile,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
