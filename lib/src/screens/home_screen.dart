import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_tracking_flutter/src/screens/create_post_screen.dart';
import 'package:moto_tracking_flutter/src/screens/feed_screen.dart';
import 'package:moto_tracking_flutter/src/screens/profile_screen.dart';
import 'package:moto_tracking_flutter/src/services/storage_service.dart';
import 'package:moto_tracking_flutter/src/widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _active = 'feed';
  bool _showCreate = false;

  final _storage = StorageService();

  void _openMoreMenu() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.group_outlined),
                title: const Text('Grupos'),
                onTap: () => Navigator.pop(context, 'grupos'),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Perfil'),
                onTap: () => Navigator.pop(context, 'perfil'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sair'),
                onTap: () => Navigator.pop(context, 'logout'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (!mounted || selected == null) return;

    if (selected == 'perfil') {
      setState(() => _active = 'perfil');
    } else if (selected == 'logout') {
      await _storage.logout();
      if (mounted) context.go('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tela "$selected" ainda não foi portada.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final nome = _storage.getString('nome') ?? 'Motociclista';

    Widget body;
    if (_showCreate) {
      body = CreatePostScreen(onBack: () => setState(() => _showCreate = false));
    } else {
      body = IndexedStack(
        index: _tabIndex(_active),
        children: [
          FeedScreen(onCreatePost: () => setState(() => _showCreate = true)),
          const _PlaceholderScreen(title: 'Avisos'),
          const _PlaceholderScreen(title: 'Chat'),
          const _PlaceholderScreen(title: 'Eventos'),
          ProfileScreen(userName: nome),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(child: body),
      bottomNavigationBar: _showCreate
          ? null
          : BottomNav(
              activeMenu: _active,
              onMenuClick: (id) {
                if (id == 'more') {
                  _openMoreMenu();
                } else {
                  setState(() => _active = id);
                }
              },
            ),
    );
  }

  int _tabIndex(String id) {
    switch (id) {
      case 'feed':
        return 0;
      case 'avisos':
        return 1;
      case 'chat':
        return 2;
      case 'eventos':
        return 3;
      case 'perfil':
        return 4;
      default:
        return 0;
    }
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          '$title (placeholder)',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
