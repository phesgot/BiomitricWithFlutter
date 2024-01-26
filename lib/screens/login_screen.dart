import 'package:biometria/service/biometric_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import '../stores/login_store.dart';
import '../widgets/custom_icon_button.dart';
import '../widgets/custom_text_field.dart';
import 'list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ValueNotifier<bool> isLocalAuthFailed = ValueNotifier(false);
  late LoginStore loginStore;
  late ReactionDisposer disposer;

  //INICIA APLICAÇÃO VERICANDO A DISPONIBILIDADE DE BIOMETRIA
  @override
  void initState() {
    super.initState();
    checkLocalAuth();
  }

  checkLocalAuth() async {
    final auth = context.read<BiometricService>();

    //VERIFICA SE O DISPOSITIVO POSSUI SUPORTE A BIOMETRIA
    final isLocalAuthAvailable = await auth.isBiometricAvailable();
    final availableBiometrics = await auth.availableBiometrics();

    setState(() {
      isLocalAuthFailed.value = false;
    });

    print("ACEITO BIOMETRIA: ${isLocalAuthAvailable == true ? "SIM" : "NÃO"}");

    //SE POSSUIR BIOMETRIA CADASTRADA ELE TENTA AUTENTICAR O USUARIO
    if (availableBiometrics.isNotEmpty) {

      print("BIOMETRIAS CADASTRADAS: $availableBiometrics");

      //AUTENTICANDO
        final authenticated = await auth.authenticate();

        //SE HOUVER ALGUM ERRO NA AUTENTICAÇÃO
        if (!authenticated) {
          isLocalAuthFailed.value = true;
        } else {
          //SE NÃO HOUVER ERRO - REDIRECIONA PARA PAGINA INICIAL DA APLICACAO
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const ListScreen()),
          );
        }
    } else {
      print('SEM BIOMETRIA CADASTRADA');
    }
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    loginStore = Provider.of<LoginStore>(context);

    //Reaction só é acionada quando houver troca de valor
    disposer = reaction((_) => loginStore.loggedIn, //Monitoramento
        (loggedIn) {
      //Reação
      if (loggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ListScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(32),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.ac_unit,
                      size: 250,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Observer(builder: (_) {
                          return CustomTextField(
                            hint: 'E-mail',
                            prefix: const Icon(Icons.account_circle),
                            textInputType: TextInputType.emailAddress,
                            onChanged: loginStore.setEmail,
                            enabled: !loginStore.loading,
                          );
                        }),
                        const SizedBox(
                          height: 16,
                        ),
                        Observer(builder: (_) {
                          return CustomTextField(
                            hint: 'Senha',
                            prefix: const Icon(Icons.lock),
                            obscure: loginStore.passwordVisible,
                            onChanged: loginStore.setPassword,
                            enabled: !loginStore.loading,
                            suffix: CustomIconButton(
                              radius: 32,
                              iconData: loginStore.passwordVisible ? Icons.visibility : Icons.visibility_off,
                              onTap: loginStore.togglePasswordVisibility,
                            ),
                          );
                        }),
                        const SizedBox(
                          height: 16,
                        ),
                        Observer(builder: (_) {
                          return SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: loginStore.loginPressed as void Function()?,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                disabledBackgroundColor: Theme.of(context).primaryColor.withAlpha(100),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              child: Container(
                                margin: const EdgeInsets.only(left: 20, right: 20),
                                child: loginStore.loading
                                    ? const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(Colors.white),
                                      )
                                    : const Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        }),
                        IconButton(
                            onPressed: checkLocalAuth,
                            icon: const Icon(Icons.fingerprint_outlined))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    disposer();
    super.dispose();
  }
}
