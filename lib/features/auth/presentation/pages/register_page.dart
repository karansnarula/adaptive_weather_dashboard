import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/router/app_routes.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUp() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) return;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Passwords do not match.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (name.length > 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Name too long, please use a shorter name or remove name completely'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(AuthSignUpRequested(
      email: email,
      password: password,
      displayName: name.isNotEmpty ? name : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.space2xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppDimens.formMaxWidth),
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_mapAuthError(context, state.code)),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.cloud,
                    size: AppDimens.iconLogo,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: AppDimens.spaceLg),
                  Text(
                    'Create Account',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimens.space3xl),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Display Name (optional)',
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceLg),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceLg),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceLg),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                      ),
                    ),
                    onSubmitted: (_) => _onSignUp(),
                  ),
                  const SizedBox(height: AppDimens.space2xl),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return FilledButton(
                        onPressed: state is AuthLoading ? null : _onSignUp,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceLg),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                          ),
                        ),
                        child: state is AuthLoading
                            ? const SizedBox(
                          height: AppDimens.iconSm,
                          width: AppDimens.iconSm,
                          child: CircularProgressIndicator(
                            strokeWidth: AppDimens.strokeMd,
                            color: Colors.white,
                          ),
                        )
                            : const Text('Sign Up'),
                      );
                    },
                  ),
                  const SizedBox(height: AppDimens.spaceLg),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: const Text('Already have an account? Sign In'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _mapAuthError(BuildContext context, String code) {
    return switch (code) {
      'email-already-in-use' => 'An account already exists with this email.',
      'invalid-email' => 'Invalid email address.',
      'weak-password' => 'Password is too weak. Use at least 6 characters.',
      _ => 'An unexpected error occurred. Please try again.',
    };
  }
}