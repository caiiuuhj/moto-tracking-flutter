import 'package:flutter/material.dart';
import 'package:moto_tracking_flutter/src/services/crypto_service.dart';

class CreatePostScreen extends StatefulWidget {
  final VoidCallback onBack;
  const CreatePostScreen({super.key, required this.onBack});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _textCtrl = TextEditingController();
  static const int maxChars = 300;

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  void _publish() {
    if (_textCtrl.text.trim().isEmpty) {
      _showInfo('Escreva algo em sua postagem para continuar.');
      return;
    }

    // Aqui entra o upload + WSPost do backend (no React isso ainda está parcial).
    // Já deixo um hash pronto para quando você plugar upload no endpoint de mídia.
    final imgHash = CryptoService.generateImageHash();

    _showInfo('Post preparado ✅\nHash de mídia (exemplo):\n$imgHash');
  }

  void _showInfo(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Criar Post'),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final count = _textCtrl.text.characters.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.onBack,
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Nova postagem'),
        actions: [
          TextButton(
            onPressed: _publish,
            child: const Text('Publicar'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _textCtrl,
              maxLines: 6,
              maxLength: maxChars,
              decoration: const InputDecoration(
                hintText: 'Escreva algo…',
                alignLabelWithHint: true,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => _showInfo('Seleção de imagem/vídeo ainda não portada (precisa image_picker).'),
                  icon: const Icon(Icons.photo_outlined),
                  label: const Text('Imagem'),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () => _showInfo('Programar horário ainda não portado.'),
                  icon: const Icon(Icons.schedule_outlined),
                  label: const Text('Agendar'),
                ),
                const Spacer(),
                Text('$count/$maxChars'),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'Dica: se você quiser, eu posso portar também o upload de imagens/vídeos '
                'e os modais (comentários/curtidas) igualzinho ao React.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
