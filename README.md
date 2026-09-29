# Capital Humano · Grupo GPA

Frontend Flutter en `C:\Users\pabli\Documents\capital humano front`.
Alcance actual: fase 0 existente + implementación de fase 1 de
`docs/FLUTTER_FRONTEND_PLAN.md` del repositorio backend. No incluye fase 2.

## Ejecutar en web

Entorno verificado: Flutter 3.47.5 stable, Dart 3.13.4.
El backend debe estar disponible en `http://localhost:8000`.

```powershell
flutter pub get
dart run build_runner build
flutter run -d chrome --web-port 5173 --dart-define=API_BASE_URL=http://localhost:8000/api/v1
```

Iniciar sesión con una cuenta de prueba existente del backend. No hay usuarios
ni contraseñas incorporados al frontend. La aplicación solicita la identidad a
`users/me/`; no supone ni muestra un rol que el backend no devuelve.

Mantener el mismo origen y puerto permite recuperar el almacenamiento del
navegador al recargar. En web, `flutter_secure_storage` requiere HTTPS o
localhost; la sesión se guarda en ese navegador y origen. Al desplegar, el
servidor web debe servir `index.html` para rutas como `/dashboard`.

## Fase 1

- Login en español con validación, foco animado, contraseña visible/oculta,
  carga y errores legibles.
- Tokens en `flutter_secure_storage`, cabecera Bearer, renovación compartida
  ante solicitudes 401 simultáneas y un solo reintento por solicitud.
- Se conserva el refresh rotado que realmente devuelve el backend. Una
  renovación fallida cierra la sesión; un 403 no la cierra.
- Restauración de identidad al iniciar, rutas protegidas y cierre de sesión.
- Dashboard con `count` de Personas, Empleados, Posiciones y Empresas,
  consultando cada recurso con `page_size=1`, con carga y reintento por tarjeta.
- Logo GPA proporcionado por el usuario, sin modificaciones, centralizado en
  `lib/core/design_system/` y usado en lugar del monograma CH.

El modelo de usuario utiliza UUID en texto: así está definido en el código y
esquema reales del backend, aunque el ejemplo del plan mencione un entero.
No se modificó el backend.

## Verificación

```powershell
flutter analyze
flutter test
flutter build web
```

Resultado del 25 de septiembre de 2026: análisis sin incidencias, 22/22 tests
correctos y compilación web release generada en `build/web`. El build emitió una
advertencia de fuente CupertinoIcons; no hay referencias a esa fuente en `lib/`
ni en los tests, y no impidió compilar.

Las 22 pruebas automatizadas cubren las 9 regresiones de fase 0, login y
redirecciones, logout, conteos paginados, persistencia/restauración del servicio,
refresh concurrente y rotado, refresh inválido, límite de reintentos, respuesta
403 y logout durante una renovación. Los tests de red usan respuestas simuladas;
no son una verificación de credenciales reales. Login y layout se prueban en
320/640/1024/1440 px con texto 1.5x, además de la navegación de las 19 secciones.

Pendiente para cerrar la aceptación de fase 1: login con una cuenta Admin real,
conteos reales visibles, logout y recarga de `/dashboard` conservando sesión en
Chrome. Se solicitaron credenciales; no se crearon cuentas ni se cambiaron
contraseñas. La revisión visual automática quedó detenida porque la herramienta
no pudo verificar la URL de Chrome. No se avanzó a la siguiente fase.
