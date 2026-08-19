import 'package:flutter/material.dart';
import 'package:my_app/API/api_service.dart';
import 'package:my_app/admin/editForm.dart';
import 'package:my_app/models/User.dart';
import 'package:my_app/widgets/detail_window.dart';

class CustomCardWidget extends StatelessWidget {
  const CustomCardWidget({super.key, required this.user, this.onRefresh});

  final User user;

  /// Called after a successful edit or delete so the parent can refresh its list.
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(user: user)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.5),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Avatar ──────────────────────────────────────────────────
            // getAvatar() returns ImageProvider? — use directly as backgroundImage.
            FutureBuilder<ImageProvider?>(
              future: apiService.getAvatar(user.id ?? 0),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: snapshot.data,
                    child: snapshot.data == null
                        ? const Icon(Icons.person, size: 20)
                        : null,
                  ),
                );
              },
            ),

            // ── Text ─────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name ?? 'Unnamed',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email ?? '',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ── Edit ─────────────────────────────────────────────────────
            IconButton(
              tooltip: 'Editar',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditForm(
                      id: user.id,
                      onClickSave: () => onRefresh?.call(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
            ),

            // ── Delete ───────────────────────────────────────────────────
            IconButton(
              tooltip: 'Eliminar',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Eliminar usuario'),
                      content: Text(
                        '¿Eliminar a "${user.name ?? 'este usuario'}"? Esta acción no se puede deshacer.',
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(dialogContext).pop();
                            final success =
                                await apiService.deleteUser(user.id ?? 0);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(success
                                    ? 'Usuario eliminado'
                                    : 'Error al eliminar el usuario'),
                                backgroundColor:
                                    success ? Colors.green : Colors.red,
                              ),
                            );
                            if (success) onRefresh?.call();
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.red),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
