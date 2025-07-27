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
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Criar conta', style: TextStyle(fontFamily: "Montserrat", color: Colors.white),),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,

            child: Consumer<UserManager>(
              builder:(_, userManager, __){
                return ListView(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              children: [
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Nome completo'),
                  enabled: !userManager.loading,
                  validator: (name){
                    if(name == null || name.isEmpty){
                      return 'Campo obrigatório';
                    } else if (name.trim().split(' ').length <= 1){
                      return 'Preencha seu nome completo';
                    }
                    return null;
                  },
                  onSaved: (name) => user.name = name,
                ),
                const SizedBox(height: 16,),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'E-mail'),
                  enabled: !userManager.loading,
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Campo obrigatório';
                    } else if (!emailValid(email)) {
                      return 'E-mail inválido';
                    }
                    return null; // importante para indicar que está válido
                  },
                  onSaved: (email) => user.email = email!,
                ),
                const SizedBox(height: 16,),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Senha'),
                  enabled: !userManager.loading,
                  obscureText: true,
                  validator: (pass){
                    if(pass == null || pass.isEmpty){
                      return 'Campo obrigatório';
                    } else if(pass.length < 6){
                      return 'Senha curta';
                    }
                    return null;
                  },
                  onSaved: (pass) => user.password = pass!,
                ),
                const SizedBox(height: 16,),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Repita a senha'),
                  enabled: !userManager.loading,
                  obscureText: true,
                  validator: (pass){
                    if(pass == null || pass.isEmpty){
                      return 'Campo obrigatório';
                    } else if(pass.length < 6){
                      return 'Senha curta';
                    }
                    return null;
                  },
                  onSaved: (pass) => user.confirmPassword = pass,
                ),
                const SizedBox(height: 16,),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: userManager.loading ? null : (){
                      if(formKey.currentState!.validate()){
                        formKey.currentState!.save();

                        if(user.password != user.confirmPassword){
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Senhas não coincidem!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                          return;
                        }

                        userManager.signUp(
                          user: user,
                          onSuccess: (){
                            debugPrint('sucesso');
                            Navigator.of(context).pop();
                          },
                          onFail: (e){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Falha ao cadastrar: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
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
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    )
                    : const Text(
                      'Criar conta',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ),
                )
              ],
            );
              },
            ),
          ),
        ),
      ),
    );
  }
}