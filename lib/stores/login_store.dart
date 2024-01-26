import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  @observable
  String email = "";

  @action
  void setEmail(String value) => email = value;

  @observable
  String password = "";

  @action
  void setPassword(String value) => password = value;

  @observable
  bool passwordVisible = true;

  @action
  void togglePasswordVisibility() => passwordVisible = !passwordVisible;

  @observable
  bool loading = false;

  @observable
  bool loggedIn = false;

  @computed
  bool get isEmailValid =>
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

  @computed
  bool get isPasswordValid => password.length >= 6;

  @computed
  Function? get loginPressed => (isEmailValid && isPasswordValid && !loading) ? login as Function : null;

  @action
  Future<void> login() async {
    loading = true;

    await Future.delayed(const Duration(seconds: 2));

    loading = false;
    loggedIn = true;
    email = "";
    password = "";
  }

  @action
  void logout() {
    loggedIn = false;
  }
}
