import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zego_chat_room/main.dart';
import 'package:zego_chat_room/viewmodels/auth_view_model.dart';
import 'package:zego_chat_room/views/auth_view/signup_view.dart';

class LoginView extends ConsumerWidget {
  LoginView({super.key});

  final _loginFormKey = GlobalKey<FormState>(debugLabel: 'loginFormKey');
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context, ref) {
    final authViewModel = ref.watch(authViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Form(
                key: _loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Log Into Your Account',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      keyboardAppearance: Brightness.dark,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'example@domain.com',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _password,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: '********',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text("Don't have an account?"),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: () {
                            navigatorKey.currentState?.push(MaterialPageRoute(
                              builder: (ctx) => SignUpView(),
                            ));
                          },
                          child: const Text('Sign up'),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          final isValid =
                              _loginFormKey.currentState?.validate();
                          if (isValid != true ||
                              _email.text.isEmpty ||
                              _password.text.isEmpty) {
                            return;
                          }
                          authViewModel.login(
                            email: _email.text,
                            password: _password.text,
                          );
                        },
                        child: const Text('Sign in'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
