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
    const mainColor = Color.fromARGB(255, 4, 4, 4);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: const BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
              ),
            ),
            child: const Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Image(image: AssetImage('assets/images/logoDetona.png'),),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: formKey,
                  child: Consumer<UserManager>(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Lógica de "Esqueci minha senha" pode ir aqui
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[700],
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'Esqueceu a Senha ?',
                          style: TextStyle(
                            fontFamily: "Montserrat",
                          ),
                        ),
                      ),
                    ),
                    builder: (_, userManager, child) {
                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shrinkWrap: true,
                        children: [
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: emailController,
                            enabled: !userManager.loading,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email_outlined),
                              hintText: 'Email',
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
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
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline),
                              hintText: 'Senha',
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            obscureText: true,
                            autocorrect: false,
                            validator: (pass) {
                              if (pass!.isEmpty || pass.length < 6) {
                                return 'Senha inválida';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          child!,
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: userManager.loading
                                  ? null
                                  : () {
                                      if (formKey.currentState!.validate()) {
                                        userManager.signIn(
                                          user: User(
                                            email: emailController.text,
                                            password: passController.text,
                                          ),
                                          onFail: (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content:
                                                    Text('Falha ao entrar: $e'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          },
                                          onSuccess: () {
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.zero,
                                elevation: 5,
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Montserrat",
                                ),
                                backgroundColor: mainColor,
                                foregroundColor: Colors.white,
                              ),
                              child: userManager.loading
                                  ? const CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    )
                                  : const Text(
                                      'Entrar',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Não tem uma conta ? ",
                                style: TextStyle(fontFamily: "Montserrat"),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/signup');
                                },
                                child: const Text(
                                  "Cadastre-se",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 240, 7, 7),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
