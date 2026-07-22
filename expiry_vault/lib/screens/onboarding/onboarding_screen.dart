import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';
import '../../services/notification_service.dart';
import '../../theme/app_colors.dart';
import '../shell/main_shell.dart';

class _OnboardingPage {
  const _OnboardingPage({
    required this.emoji,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final String emoji;
  final Color color;
  final String title;
  final String subtitle;
}

const _pages = [
  _OnboardingPage(
    emoji: '🥬',
    color: AppColors.freshGreen,
    title: 'Your vault is empty — let\'s stock it up!',
    subtitle: 'Log everything in your fridge, pantry, medicine cabinet, and skincare shelf.',
  ),
  _OnboardingPage(
    emoji: '🥛',
    color: AppColors.vaultBlue,
    title: 'Milk is feeling a little old',
    subtitle: 'ExpiryVault watches expiry dates for you and nudges you before things go bad.',
  ),
  _OnboardingPage(
    emoji: '✅',
    color: AppColors.sunshineYellow,
    title: 'Nice, everything\'s fresh',
    subtitle: 'Get a friendly reminder — never a guilt trip — right when you need it.',
  ),
];

/// First-run walkthrough (brand-voice copy from the brief §3) that also
/// requests notification permission before entering the app shell.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await NotificationService.instance.requestPermissions();
    if (!mounted) return;
    await context.read<SettingsProvider>().completeOnboarding();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _index == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finish,
                child: const Text('Skip'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(color: page.color, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: Text(page.emoji, style: const TextStyle(fontSize: 56)),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          page.subtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _index ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _index ? AppColors.vaultBlue : AppColors.divider,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isLastPage
                      ? _finish
                      : () => _controller.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                          ),
                  child: Text(isLastPage ? 'Get started' : 'Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
