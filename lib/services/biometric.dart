import 'dart:async';
import 'package:local_auth/local_auth.dart';

class Biometric {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> checkBiometrics() async => await auth.canCheckBiometrics;

  Future<List<BiometricType>> getAvailableBiometrics() async =>
      await auth.getAvailableBiometrics();

  Future<bool> authenticate() async => await auth.authenticateWithBiometrics(
      localizedReason: 'Scan your fingerprint to authenticate',
      useErrorDialogs: true,
      stickyAuth: true);
}
