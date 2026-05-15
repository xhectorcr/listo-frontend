<<<<<<< HEAD
# LISTO! GO
**Para qué sirve**
- **Propósito:** Permite que un cliente ingrese a una tienda, tome productos y salga sin pasar por caja. El sistema utiliza modelos de detección como YOLO para identificar en tiempo real los productos que el cliente recoge o devuelve. Cada acción se asocia a un usuario específico (mediante identificación previa) y se refleja automáticamente en su carrito virtual. Al salir, el sistema calcula el total y realiza el cobro sin intervención manual.

**Cómo usar**
- **Requisitos previos:** Tener instalado Flutter SDK y las herramientas para las plataformas objetivo (Android/iOS/Web/Windows).
- **Instalar dependencias:**

```bash
flutter pub get
```

- **Correr la app (cliente móvil):**

```bash
flutter run --target=lib/main.dart
```

- **Correr la versión web (landing público):**

```bash
flutter run -d chrome --target=lib/main_web.dart
```

- **Correr el panel/admin en web:**

```bash
flutter run -d chrome --target=lib/main_admin.dart
```

- **Construir release para Android:**

```bash
flutter build apk --release
```

**Dependencias principales**
- **SDK Dart:** >=3.11.0
- **Paquetes usados**
	- `flutter` (SDK)
	- `cupertino_icons`
	- `http`
	- `qr_flutter` (generación/lectura de códigos QR)
	- `fl_chart` (gráficas/estadísticas)
	- `shared_preferences` (almacenamiento local)
	- `camera` (acceso cámara, escaneo)
	- `web_socket_channel` (comunicación en tiempo real)
	- `permission_handler` (permisos de plataforma)

**Estructura relevante**
- `lib/main.dart` — punto de entrada para la app móvil (cliente).
- `lib/main_web.dart` — punto de entrada para la versión pública / landing.
- `lib/main_admin.dart` — punto de entrada para el panel administrativo.
- `lib/screens/` — pantallas móviles (login, registro, carrito, cámara, etc.).
- `lib/web/` — pantallas y dashboards para la web.
- `lib/services/` — servicios como autenticación y almacenamiento.
- `lib/src/` — adaptadores/implementaciones para permisos y plataformas.

=======
# listo_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
>>>>>>> hector
