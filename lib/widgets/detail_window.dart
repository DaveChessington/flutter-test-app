import 'package:flutter/material.dart';
import 'package:my_app/models/User.dart';

class DetailScreen extends StatelessWidget {
  final User user;

  const DetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detalles',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              user.name ?? "",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  user.email ?? "",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black.withOpacity(0.08),
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _infoFila(Icons.person, 'Nombre', user.name ?? ""),
                  _infoFila(Icons.email, 'Correo', user.email ?? ""),
                  _infoFilaBadge(user.isAproved),
                  _infoFila(Icons.person_pin, 'Rol', user.role.name),
                  _infoFila(
                    Icons.calendar_today,
                    'Fecha de creación',
                    user.createdAt ?? "",
                  ),
                  _infoFila(
                    Icons.update,
                    'Fecha de actualización',
                    user.updatedAt ?? "",
                  ),
                  _infoFila(
                    Icons.delete,
                    'Fecha de eliminación',
                    user.deletedAt ?? "",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoFila(IconData icono, String label, String valor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.06), width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icono, size: 16, color: Colors.grey.shade500),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
          Text(
            valor,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _infoFilaBadge(bool activo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 16,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 8),
              Text(
                'Estatus',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: activo ? const Color(0xFFEAF3DE) : const Color(0xFFFAEEDA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              activo ? 'Activo' : 'Inactivo',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: activo
                    ? const Color(0xFF27500A)
                    : const Color(0xFF633806),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
