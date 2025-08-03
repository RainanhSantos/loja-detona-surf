import 'package:flutter/material.dart';
import 'package:loja_free_style/helpers/validators.dart';
import 'package:loja_free_style/model/user.dart';
import 'package:provider/provider.dart';
import 'package:loja_free_style/model/user_manager.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final User user = User(email: '', password: '');

  @override
  Widget build(BuildContext context) {
    const mainColor = Color.fromARGB(255, 4, 4, 4);

    return Scaffold(
      key: scaffoldKey,
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
                  child: Image(image: AssetImage('assets/images/logoDetona.png')),
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
                    builder: (_, userManager, __) {
                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shrinkWrap: true,
                        children: [
                          const SizedBox(height: 24),
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person_outline),
                              hintText: 'Nome completo',
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            enabled: !userManager.loading,
                            validator: (name) {
                              if (name == null || name.isEmpty) {
                                return 'Campo obrigatório';
                              } else if (name.trim().split(' ').length <= 1) {
                                return 'Preencha seu nome completo';
                              }
                              return null;
                            },
                            onSaved: (name) => user.name = name,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email_outlined),
                              hintText: 'E-mail',
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            enabled: !userManager.loading,
                            keyboardType: TextInputType.emailAddress,
                            validator: (email) {
                              if (email == null || email.isEmpty) {
                                return 'Campo obrigatório';
                              } else if (!emailValid(email)) {
                                return 'E-mail inválido';
                              }
                              return null;
                            },
                            onSaved: (email) => user.email = email!,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
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
                            enabled: !userManager.loading,
                            obscureText: true,
                            validator: (pass) {
                              if (pass == null || pass.isEmpty) {
                                return 'Campo obrigatório';
                              } else if (pass.length < 6) {
                                return 'Senha curta';
                              }
                              return null;
                            },
                            onSaved: (pass) => user.password = pass!,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline),
                              hintText: 'Repita a senha',
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            enabled: !userManager.loading,
                            obscureText: true,
                            validator: (pass) {
                              if (pass == null || pass.isEmpty) {
                                return 'Campo obrigatório';
                              } else if (pass.length < 6) {
                                return 'Senha curta';
                              }
                              return null;
                            },
                            onSaved: (pass) => user.confirmPassword = pass,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: userManager.loading
                                  ? null
                                  : () {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();

                                        if (user.password !=
                                            user.confirmPassword) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Senhas não coincidem!'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }

                                        userManager.signUp(
                                          user: user,
                                          onSuccess: () {
                                            Navigator.of(context).pop();
                                          },
                                          onFail: (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Falha ao cadastrar: $e'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
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
                                disabledBackgroundColor:
                                    mainColor.withAlpha(100),
                              ),
                              child: userManager.loading
                                  ? const CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    )
                                  : const Text(
                                      'Criar conta',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "Montserrat",
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
                                "Já tem uma conta? ",
                                style: TextStyle(fontFamily: "Montserrat"),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/login');
                                },
                                child: const Text(
                                  "Entrar",
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
