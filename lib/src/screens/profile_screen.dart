import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_tracking_flutter/src/services/storage_service.dart';
import 'package:moto_tracking_flutter/src/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  const ProfileScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();
    final idIsu = storage.getString('id-isu');
    final avatarUrl = (idIsu != null && idIsu.isNotEmpty)
        ? 'https://mototracking.com.br/app/services/v1.01/image?dir=users&hash=$idIsu'
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: AppTheme.primary.withOpacity(0.12),
                  child: avatarUrl == null
                      ? Text(
                          userName.isNotEmpty ? userName.characters.first.toUpperCase() : 'M',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                        )
                      : ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: avatarUrl,
                            width: 68,
                            height: 68,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => const Icon(Icons.person_outline, size: 34),
                          ),
                        ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userName, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text('id-isu: ${idIsu ?? '-'}', style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Editar perfil'),
              subtitle: const Text('Modal de edição do React ainda não portado'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Editar perfil: em breve (port completo).')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.block_outlined),
              title: const Text('Usuários bloqueados'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bloqueados: em breve.')),
                );
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: () async {
                  await storage.logout();
                  if (context.mounted) context.go('/login');
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sair'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
