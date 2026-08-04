import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:my_app/API/api_service.dart';
import 'package:my_app/models/User.dart';
import 'package:my_app/widgets/detail_window.dart';

class CustomCardWidget extends StatelessWidget {
  const CustomCardWidget({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();
    // Fetch avatar image (base64 string) and convert to a widget.
    final Future<Widget> avatarFuture = apiService.getAvatar(user.id ?? 0).then((data) {
      if (data == null) {
        return const Icon(Icons.person, size: 36);
      }
      try {
        final Uint8List bytes = base64Decode(data as String);
        return Image.memory(bytes, width: 36, height: 36, fit: BoxFit.cover);
      } catch (_) {
        // If not base64 or decoding fails, fallback to a placeholder icon.
        return const Icon(Icons.person, size: 36);
      }
    });

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(user: user)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.5),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar widget built from a future.
            FutureBuilder<Widget>(
              future: avatarFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Icon(Icons.error, size: 36);
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: snapshot.data!,
                );
              },
            ),
            // Text content (title & subtitle).
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name ?? 'Unnamed',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
            IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
