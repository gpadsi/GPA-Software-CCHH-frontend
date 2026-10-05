import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'file_saver_stub.dart'
    if (dart.library.js_interop) 'file_saver_web.dart';

/// Un archivo ya descargado del servidor, listo para entregárselo a la persona.
class DownloadedFile {
  const DownloadedFile({
    required this.name,
    required this.bytes,
    required this.mimeType,
  });

  final String name;
  final Uint8List bytes;
  final String mimeType;
}

/// Entrega un archivo a la persona (en web: lo baja por el navegador). Es una
/// interfaz para que las pruebas puedan sustituirla sin navegador.
abstract class FileSaver {
  Future<void> save(DownloadedFile file);
}

final fileSaverProvider = Provider<FileSaver>((ref) => createFileSaver());

/// Saca el nombre de archivo de un encabezado `Content-Disposition`
/// (`attachment; filename="a.xlsx"` o la forma con acentos
/// `filename*=utf-8''Requisici%C3%B3n.xlsx`). Si no viene o no se entiende,
/// regresa [fallback]: el servidor ya nombra bien el archivo, esto es solo la
/// red de seguridad.
String filenameFromContentDisposition(
  String? header, {
  required String fallback,
}) {
  if (header == null || header.isEmpty) return fallback;
  final extended = RegExp(r"filename\*\s*=\s*(?:utf-8|UTF-8)''([^;]+)")
      .firstMatch(header);
  if (extended != null) {
    try {
      final decoded = Uri.decodeComponent(extended.group(1)!.trim());
      if (decoded.isNotEmpty) return _safe(decoded);
    } on FormatException {
      // Se intenta con la forma simple.
    }
  }
  final simple = RegExp(r'filename\s*=\s*"?([^";]+)"?').firstMatch(header);
  final name = simple?.group(1)?.trim() ?? '';
  return name.isEmpty ? fallback : _safe(name);
}

// Un nombre de archivo nunca debe traer una ruta.
String _safe(String name) => name.split(RegExp(r'[\\/]')).last;
