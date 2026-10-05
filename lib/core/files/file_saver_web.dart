import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'file_saver.dart';

FileSaver createFileSaver() => const _WebFileSaver();

/// Baja el archivo con un enlace temporal a un Blob: es la forma de
/// descargar algo que se pidió con el token de sesión (un enlace directo al
/// servidor no llevaría el encabezado de autorización).
class _WebFileSaver implements FileSaver {
  const _WebFileSaver();

  @override
  Future<void> save(DownloadedFile file) async {
    final blob = web.Blob(
      [file.bytes.toJS].toJS,
      web.BlobPropertyBag(type: file.mimeType),
    );
    final url = web.URL.createObjectURL(blob);
    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..download = file.name
      ..style.display = 'none';
    web.document.body!.append(anchor);
    anchor.click();
    anchor.remove();
    web.URL.revokeObjectURL(url);
  }
}
