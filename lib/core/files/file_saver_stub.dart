import 'file_saver.dart';

/// Fuera del navegador (pruebas, otras plataformas) todavía no se baja nada:
/// la app se entrega como web. Falla con un mensaje claro en vez de callar.
FileSaver createFileSaver() => const _UnsupportedFileSaver();

class _UnsupportedFileSaver implements FileSaver {
  const _UnsupportedFileSaver();

  @override
  Future<void> save(DownloadedFile file) async => throw UnsupportedError(
    'La descarga de archivos solo está disponible en la versión web.',
  );
}
