// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Capital Humano';

  @override
  String get comingSoonTitle => 'Sin información registrada';

  @override
  String get comingSoonMessage =>
      'Todavía no se ha capturado información en esta sección.';

  @override
  String get workspaceTitle => 'Recursos Humanos de Grupo GPA';

  @override
  String get workspaceSubtitle =>
      'Consulta expedientes, estructura organizacional, puestos y contratos del personal.';

  @override
  String get loginTitle => 'Portal de Capital Humano';

  @override
  String get loginSubtitle => 'Ingresa tu usuario y contraseña para continuar.';

  @override
  String get usernameLabel => 'Usuario';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get usernameRequired => 'Escribe tu usuario.';

  @override
  String get passwordRequired => 'Escribe tu contraseña.';

  @override
  String get showPassword => 'Mostrar contraseña';

  @override
  String get hidePassword => 'Ocultar contraseña';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get loginHelp =>
      'Si necesitas acceso, contacta al equipo de Capital Humano.';
}
