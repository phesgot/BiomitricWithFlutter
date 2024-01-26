import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

class BiometricService {
  final LocalAuthentication? auth;

  BiometricService({this.auth});

  //Verifica se o dispositivo possui suporte a biometria.
  Future<bool> isBiometricAvailable() async {
    final bool canAuthenticateWithBiometrics = await auth!.canCheckBiometrics;
    return canAuthenticateWithBiometrics || await auth!.isDeviceSupported();
  }

  //Verificando se o dispositivo possui alguma forma de biometria cadastrada.
  Future<List<BiometricType>> availableBiometrics() async{
    final List<BiometricType> availableBiometrics = await auth!.getAvailableBiometrics();
    return availableBiometrics;
  }

  //Realiza a autenticação pela biometria ou pon cadastrado no smartphone.
  Future<bool> authenticate() async {
    return await auth!.authenticate(
      localizedReason: 'Autentique-se',
        options: const AuthenticationOptions(useErrorDialogs: false),
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            biometricHint: "",
            signInTitle: 'Acesso por biometria',
            cancelButton: 'Cancelar',
          ),
          IOSAuthMessages(
            lockOut: "Teste 01",
            localizedFallbackTitle: "Teste 02",
            goToSettingsDescription: "Teste 03",
            goToSettingsButton: "Teste 04",
            cancelButton: 'Cancelar',
          ),
        ]
    );
  }
}
