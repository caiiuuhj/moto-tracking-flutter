import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_tracking_flutter/src/services/api_service.dart';
import 'package:moto_tracking_flutter/src/services/crypto_service.dart';
import 'package:moto_tracking_flutter/src/services/storage_service.dart';
import 'package:moto_tracking_flutter/src/widgets/logo_mark.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _showPass = false;
  bool _loading = false;

  final _api = ApiService();
  final _storage = StorageService();

  bool get _formValid => _emailCtrl.text.trim().isNotEmpty && _passCtrl.text.isNotEmpty;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formValid || _loading) return;
    setState(() => _loading = true);

    try {
      final loginHash = CryptoService.sha256Hex(_emailCtrl.text.trim());
      final passHash = CryptoService.sha256Hex(_passCtrl.text);

      final res = await _api.post<Map<String, dynamic>>(
        'usuario',
        'v1.00',
        'login',
        body: {'login': loginHash, 'senha': passHash},
        parseDados: (d) => (d as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{},
      );

      if (!mounted) return;

      if (res.cod == 100) {
        final id = (res.dados['id'] ?? '').toString();
        final nome = (res.dados['nome'] ?? '').toString();

        if (id.isNotEmpty) await _storage.setString('id-isu', id);
        if (nome.isNotEmpty) await _storage.setString('nome', nome);

        if (mounted) context.go('/');
      } else {
        _showError(res.msg.isEmpty ? 'Login inválido' : res.msg);
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Não foi possível entrar. Verifique sua internet e tente novamente.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ops!'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LogoMark(),
                  const SizedBox(height: 18),
                  Text('Login', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passCtrl,
                    obscureText: !_showPass,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _showPass = !_showPass),
                        icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility),
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _login(),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: _loading ? null : () => _showError('Fluxo de recuperação não portado ainda (mesma API do web).'),
                      child: const Text('Esqueceu sua senha?'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: (_formValid && !_loading) ? _login : null,
                      child: _loading
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Entrar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
