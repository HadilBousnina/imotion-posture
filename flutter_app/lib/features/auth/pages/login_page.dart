import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // ⚠️ à ajouter en haut du fichier

import '../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

import '../widgets/auth_button.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/footer.dart';
import '../widgets/login_title.dart';
import '../widgets/remember_me.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authControllerProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          rememberMe: _rememberMe,
        );

    if (!mounted) return;

    if (success) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.status == AuthStatus.loading;

    ref.listen(authControllerProvider, (previous, next) {
      if (next.status == AuthStatus.error &&
          next.errorMessage != null &&
          mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 470,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                color: AppColors.surface,
                elevation: 12,
                shadowColor: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 36,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AuthLogo(),

                          const SizedBox(height: 14),

                          const LoginTitle(),

                          const SizedBox(height: 32),

                          AuthTextField(
                            controller: _emailController,
                            hint: "Email",
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez saisir votre email";
                              }

                              if (!value.contains('@')) {
                                return "Email invalide";
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 18),

                          AuthTextField(
                            controller: _passwordController,
                            hint: "Mot de passe",
                            icon: Icons.lock_outline,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez saisir votre mot de passe";
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          RememberMe(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            onForgotPassword: () {},
                          ),

                          const SizedBox(height: 30),

                          AuthButton(
                            text: "Se connecter",
                            isLoading: isLoading,
                            onPressed: _handleLogin,
                          ),

                          const SizedBox(height: 32),

                          const Divider(
                            color: AppColors.border,
                            thickness: 1,
                          ),

                          const SizedBox(height: 18),

                          const Footer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}