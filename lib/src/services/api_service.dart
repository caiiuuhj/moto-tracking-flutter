import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:moto_tracking_flutter/src/services/storage_service.dart';

class WSResponse<T> {
  final int cod;
  final String msg;
  final T dados;

  WSResponse({required this.cod, required this.msg, required this.dados});

  factory WSResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) parseDados) {
    return WSResponse(
      cod: (json['cod'] as num?)?.toInt() ?? -1,
      msg: (json['msg'] as String?) ?? '',
      dados: parseDados(json['dados']),
    );
  }
}

class ApiService {
  static const String baseUrl = 'https://mototracking.com.br/app';
  static const bool devMode = false;

  final StorageService _storage = StorageService();

  Uri _buildUri(String tipo, String versao, String modulo, [Map<String, String>? query]) {
    final url = '$baseUrl/$tipo/$versao/$modulo';
    return Uri.parse(url).replace(queryParameters: query);
  }

  Map<String, String> _headers() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    final idIsu = _storage.getString('id-isu');
    if (idIsu != null && idIsu.isNotEmpty) {
      headers['id-isu'] = idIsu;
    }
    return headers;
  }

  Future<WSResponse<T>> get<T>(
    String tipo,
    String versao,
    String modulo, {
    Map<String, String>? query,
    required T Function(dynamic) parseDados,
  }) async {
    if (devMode) {
      return WSResponse(cod: 0, msg: '[DEV] ok', dados: parseDados(null));
    }
    final res = await http.get(_buildUri(tipo, versao, modulo, query), headers: _headers())
      .timeout(const Duration(seconds: 30));
    return _parse<T>(res, parseDados);
  }

  Future<WSResponse<T>> post<T>(
    String tipo,
    String versao,
    String modulo, {
    Object? body,
    required T Function(dynamic) parseDados,
  }) async {
    if (devMode) {
      return WSResponse(cod: 0, msg: '[DEV] ok', dados: parseDados(null));
    }
    final res = await http.post(
      _buildUri(tipo, versao, modulo),
      headers: _headers(),
      body: jsonEncode(body ?? {}),
    ).timeout(const Duration(seconds: 30));
    return _parse<T>(res, parseDados);
  }

  Future<WSResponse<T>> _parse<T>(http.Response res, T Function(dynamic) parseDados) async {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Erro HTTP ${res.statusCode}: ${res.reasonPhrase}');
    }
    final decoded = jsonDecode(utf8.decode(res.bodyBytes));
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Resposta inválida do servidor');
    }
    if (kDebugMode) {
      // ignore: avoid_print
      print('✅ [API] ${res.request?.method} ${res.request?.url} -> ${res.statusCode}');
    }
    return WSResponse.fromJson(decoded, parseDados);
  }
}
