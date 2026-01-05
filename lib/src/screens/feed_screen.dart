import 'package:flutter/material.dart';
import 'package:moto_tracking_flutter/src/services/api_service.dart';
import 'package:moto_tracking_flutter/src/services/storage_service.dart';
import 'package:moto_tracking_flutter/src/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  final VoidCallback onCreatePost;
  const FeedScreen({super.key, required this.onCreatePost});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _api = ApiService();
  final _storage = StorageService();

  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _posts = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await _api.get<Map<String, dynamic>>(
        'feed',
        'v1.00',
        'conteudo',
        query: const {
          'is_perfil': '0',
          'paginacao': '0',
          'id_postagem': '0',
        },
        parseDados: (d) => (d as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{},
      );

      final dados = res.dados;
      final posts = (dados['posts'] as List?)?.cast<dynamic>() ?? const [];
      setState(() {
        _posts = posts.map((e) => (e as Map).cast<String, dynamic>()).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Não foi possível carregar o feed.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final nome = _storage.getString('nome') ?? 'João Silva';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: Row(
            children: [
              Text('Olá, $nome', style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              IconButton(
                onPressed: widget.onCreatePost,
                icon: const Icon(Icons.add_circle_outline),
                tooltip: 'Novo post',
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _load,
            child: _loading
                ? const _FeedSkeleton()
                : (_error != null)
                    ? ListView(
                        children: [
                          const SizedBox(height: 80),
                          Center(child: Text(_error!)),
                          const SizedBox(height: 12),
                          Center(
                            child: FilledButton(
                              onPressed: _load,
                              child: const Text('Tentar novamente'),
                            ),
                          ),
                        ],
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                        itemCount: _posts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final p = _posts[i];
                          final authorName = (p['autor_nome'] ?? 'Motociclista').toString();
                          final content = (p['descricao'] ?? '').toString();
                          final img = (p['img_post'] ?? '').toString();
                          final imgUrl = img.isNotEmpty
                              ? 'https://mototracking.com.br/app/services/v1.01/image?dir=posts&hash=$img'
                              : null;

                          return PostCard(
                            authorName: authorName,
                            content: content,
                            imageUrl: imgUrl,
                            likes: (p['qtd_reacoes'] as num?)?.toInt() ?? 0,
                            comments: (p['qtd_comentarios'] as num?)?.toInt() ?? 0,
                          );
                        },
                      ),
          ),
        ),
      ],
    );
  }
}

class _FeedSkeleton extends StatelessWidget {
  const _FeedSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Container(
        height: 160,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}
