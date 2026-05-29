import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

/// Branded splash shown for ~1.5s on app launch. Plays a one-shot sound
/// from `assets/sounds/splash.mp3` (silently no-ops if the file is
/// missing or the platform blocks autoplay — looking at you, web), runs
/// a fade-in + elastic-scale animation on the logo, then navigates to
/// `/weather` or `/login` based on the [AuthBloc] state.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  /// Total time the splash holds before navigating. The native splash
  /// already covered cold-start so this is purely the branded moment.
  static const Duration _splashHoldDuration = Duration(milliseconds: 2500);

  /// Animation duration — finishes ~700ms before navigation, leaving the
  /// logo at rest briefly so users register the brand.
  static const Duration _animationDuration = Duration(milliseconds: 800);

  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _scale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
    _playSound();

    // Independent timer from the animation — even if audio fails or the
    // animation glitches, we still leave the splash on schedule.
    Future.delayed(_splashHoldDuration, _navigateOut);
  }

  Future<void> _playSound() async {
    // Sound is non-critical UX. Web autoplay restrictions, missing asset,
    // unavailable audio device — all are silently tolerated.
    try {
      _audioPlayer = AudioPlayer();
      await _audioPlayer!.play(AssetSource('sounds/splash.mp3'));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[SplashPage] splash sound skipped: $e');
      }
    }
  }

  void _navigateOut() {
    if (!mounted) return;
    final authState = context.read<AuthBloc>().state;
    final destination = authState is Authenticated ? '/weather' : '/login';
    context.go(destination);
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.primary,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Opacity(
              opacity: _fade.value,
              child: Transform.scale(
                scale: _scale.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud,
                      size: AppDimens.iconLogo * 1.5,
                      color: scheme.onPrimary,
                    ),
                    const SizedBox(height: AppDimens.spaceLg),
                    Text(
                      context.l10n.appTitle,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            color: scheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
