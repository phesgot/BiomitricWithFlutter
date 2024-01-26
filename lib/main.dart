import 'package:biometria/screens/login_screen.dart';
import 'package:biometria/service/biometric_service.dart';
import 'package:biometria/stores/login_store.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoginStore>(create: (_) => LoginStore()),
        Provider<BiometricService>(create: (context) => BiometricService(auth: LocalAuthentication())),
      ],
      child: MaterialApp(
        title: "MobX",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
