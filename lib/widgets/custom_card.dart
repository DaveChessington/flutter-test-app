import 'package:flutter/material.dart';

class CustomCardWidget extends StatelessWidget {
  const CustomCardWidget({
    super.key,
    required this.entity, //used to receive any of the defined models
    required this.actions,
    required this.onTap,
    required this.onNuevaVenta,
    required this.title,
    required this.subtitle,
    required this.avatar,
  });
  final Object entity;
  final List<(Icon, VoidCallback, String?)> actions;
  final VoidCallback onTap;
  final VoidCallback onNuevaVenta;
  final String title;
  final String subtitle;
  final Widget avatar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.5),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const SizedBox(width: 12),

            // Nombre y dirección
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Botón +
            GestureDetector(
              onTap: onNuevaVenta,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF3DE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Color(0xFF27500A),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
