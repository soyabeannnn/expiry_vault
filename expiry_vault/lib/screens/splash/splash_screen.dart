import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';
import '../onboarding/onboarding_screen.dart';
import '../shell/main_shell.dart';

/// First screen shown on launch. Briefly shows the ExpiryVault mark, then
/// routes to Onboarding (first run) or straight into the app shell.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigateNext());
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    final hasOnboarded = context.read<SettingsProvider>().hasOnboarded;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => hasOnboarded ? const MainShell() : const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.vaultBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.lock_rounded, size: 44, color: AppColors.vaultBlue),
            ),
            const SizedBox(height: 20),
            const Text(
              'ExpiryVault',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: AppColors.cream,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Never let your fridge surprise you again',
              style: TextStyle(fontSize: 13, color: AppColors.cream.withValues(alpha: 0.85)),
            ),
          ],
        ),
      ),
    );
  }
}
