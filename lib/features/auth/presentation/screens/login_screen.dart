import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routes/route_names.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/sr_button.dart';
import '../../../../core/widgets/sr_scaffold.dart';
import '../../../../core/widgets/sr_snackbar.dart';
import '../../../../core/widgets/sr_text_field.dart';
import '../../../../core/widgets/dornye_logo.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_form_card.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = await ref.read(authControllerProvider.notifier).login(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
    if (!mounted) return;
    if (success) {
      context.goNamed(RouteNames.dashboard);
    } else {
      final error = ref.read(authControllerProvider).errorMessage;
      if (error != null) SrSnackbar.error(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authControllerProvider.select((s) => s.isLoading),
    );

    return SrScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxxl),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: DornyeLogo(size: 28),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  const Text(
                    'SheRides',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxxl),
              const Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Sign in to manage your rides and bike',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.onSurfaceSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              AuthFormCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SrTextField(
                        controller: _emailCtrl,
                        label: 'Email address',
                        hint: 'you@example.com',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_passwordFocus),
                        validator: AppValidators.email,
                        prefixIcon: const Icon(
                          Icons.mail_outline,
                          size: 20,
                          color: AppColors.onSurfaceSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SrPasswordField(
                        controller: _passwordCtrl,
                        label: 'Password',
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        validator: AppValidators.password,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SrGhostButton(
                          label: 'Forgot password?',
                          onPressed: () =>
                              context.pushNamed(RouteNames.forgotPassword),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SrPrimaryButton(
                        label: 'Sign In',
                        onPressed: _submit,
                        isLoading: isLoading,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'New to SheRides? ',
                    style: TextStyle(color: AppColors.onSurfaceSecondary),
                  ),
                  SrGhostButton(
                    label: 'Create Account',
                    onPressed: () => context.pushNamed(RouteNames.signup),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
