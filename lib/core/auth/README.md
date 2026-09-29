# Sesión

`SessionController` expone la identidad y el estado de sesión con Riverpod.
`SessionService` usa Dio para login, identidad y renovación; `TokenStore`
persiste el par access/refresh mediante `flutter_secure_storage`.

Las guardas viven en `core/routing/app_router.dart`. Las features consumen
la sesión desde core, sin importarse entre sí. `SessionUser` refleja la
respuesta real de `/users/me/`, sin rol ni empleado supuestos.
