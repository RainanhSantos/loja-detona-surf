import 'package:flutter/material.dart';
import 'package:loja_free_style/helpers/validators.dart';
import 'package:loja_free_style/model/user.dart';
import 'package:loja_free_style/model/user_manager.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // Lógica de "Esqueci minha senha" pode ir aqui
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        'Esqueci minha senha',
                      ),
                    ),
                  ),
              builder: (_, userManager, child) {
                return ListView(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                children: [
                  TextFormField(
                    controller: emailController,
                    enabled: !userManager.loading,
                    decoration: const InputDecoration(hintText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (email) {
                      if (!emailValid(email!)) {
                        return 'E-mail inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passController,
                    enabled: !userManager.loading,
                    decoration: const InputDecoration(hintText: 'Senha'),
                    obscureText: true,
                    autocorrect: false,
                    validator: (pass) {
                      if (pass!.isEmpty || pass.length < 6) {
                        return 'Senha inválida';
                      }
                      return null;
                    },
                  ),
                  child!,
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: userManager.loading ? null : () {
                        if (formKey.currentState!.validate()) {
                          userManager.signIn(
                                user: User(
                                  email: emailController.text,
                                  password: passController.text,
                                ),
                                onFail: (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Falha ao entrar: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                },
                                onSuccess: () {
                                  // TODO: FECHAR TELA DE LOGIN
                                },
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Theme.of(context).primaryColor
                                .withAlpha(100),
                        textStyle: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      child: userManager.loading ?
                      const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),) :
                       const Text('Entrar'),
                    ),
                  ),
                ],
              );
              }
            ),
          ),
        ),
      ),
    );
  }
}
