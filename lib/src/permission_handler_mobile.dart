import 'package:permission_handler/permission_handler.dart';

Future<bool> checkAndRequestCameraPermission() async {
  final status = await Permission.camera.status;
  if (status.isGranted) return true;
  final result = await Permission.camera.request();
  return result.isGranted;
}
