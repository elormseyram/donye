import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/sr_app_bar.dart';
import '../../../../core/widgets/sr_button.dart';
import '../../../../core/widgets/sr_scaffold.dart';
import '../../../../core/widgets/sr_snackbar.dart';
import '../../../../core/widgets/sr_text_field.dart';
import '../../../../core/widgets/dornye_logo.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_form_card.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _bikeSerialCtrl = TextEditingController();
  final _bikeModelCtrl = TextEditingController();
  final _bikeRegistrationCtrl = TextEditingController();
  final _batteryCapacityCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _bikeSerialCtrl.dispose();
    _bikeModelCtrl.dispose();
    _bikeRegistrationCtrl.dispose();
    _batteryCapacityCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = await ref.read(authControllerProvider.notifier).signup(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          fullName: _nameCtrl.text.trim(),
          phoneNumber: _phoneCtrl.text.trim(),
          bikeSerialNumber: _bikeSerialCtrl.text.trim(),
          bikeModel: _bikeModelCtrl.text.trim(),
          bikeRegistrationNumber: _bikeRegistrationCtrl.text.trim(),
          batteryCapacityKwh: double.parse(_batteryCapacityCtrl.text.trim()),
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
      appBar: const SrAppBar(title: 'Create Account', showBorder: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            children: [
              AuthFormCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your details',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SrTextField(
                        controller: _nameCtrl,
                        label: 'Full name',
                        hint: 'Jane Doe',
                        textInputAction: TextInputAction.next,
                        validator: AppValidators.fullName,
                        prefixIcon: const Icon(Icons.person_outline,
                            size: 20, color: AppColors.onSurfaceSecondary),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SrTextField(
                        controller: _phoneCtrl,
                        label: 'Phone number',
                        hint: '+233 XX XXX XXXX',
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        validator: AppValidators.phone,
                        prefixIcon: const Icon(Icons.phone_outlined,
                            size: 20, color: AppColors.onSurfaceSecondary),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SrTextField(
                        controller: _emailCtrl,
                        label: 'Email address',
                        hint: 'you@example.com',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: AppValidators.email,
                        prefixIcon: const Icon(Icons.mail_outline,
                            size: 20, color: AppColors.onSurfaceSecondary),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SrTextField(
                        controller: _bikeSerialCtrl,
                        label: 'Bike serial number',
                        hint: 'SN-123456',
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) => AppValidators.required(
                          value,
                          field: 'Bike serial number',
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(12),
                          child: DornyeLogo(size: 20),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SrTextField(
                        controller: _bikeModelCtrl,
                        label: 'Bike model',
                        hint: 'Dornye E-Bike',
                        textInputAction: TextInputAction.next,
                        validator: (value) => AppValidators.required(
                          value,
                          field: 'Bike model',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SrTextField(
                        controller: _bikeRegistrationCtrl,
                        label: 'Registration number',
                        hint: 'GR-1234-26',
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) => AppValidators.required(
                          value,
                          field: 'Registration number',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SrTextField(
                        controller: _batteryCapacityCtrl,
                        label: 'Battery capacity (kWh)',
                        hint: '2.5',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          final capacity = double.tryParse(value?.trim() ?? '');
                          if (capacity == null || capacity <= 0) {
                            return 'Enter a valid battery capacity';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SrPasswordField(
                        controller: _passwordCtrl,
                        label: 'Password',
                        textInputAction: TextInputAction.next,
                        validator: AppValidators.password,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SrPasswordField(
                        controller: _confirmCtrl,
                        label: 'Confirm password',
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        validator: (v) => AppValidators.confirmPassword(
                          v,
                          _passwordCtrl.text,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      SrPrimaryButton(
                        label: 'Create Account',
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
                    'Already have an account? ',
                    style: TextStyle(color: AppColors.onSurfaceSecondary),
                  ),
                  SrGhostButton(
                    label: 'Sign In',
                    onPressed: () => context.goNamed(RouteNames.login),
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
