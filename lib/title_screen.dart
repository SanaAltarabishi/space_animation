import 'package:flutter/material.dart';
import 'package:sky_app/particule_overlay.dart';

import '../assets.dart';
import '../styles.dart';
import 'title_screen_ui.dart';
import '../orb_shader/orb_shader_widget.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/services.dart';
import '../orb_shader/orb_shader_config.dart';
import '../orb_shader/orb_shader_widget.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen>
    with SingleTickerProviderStateMixin {
  final _orbkey = GlobalKey<OrbShaderWidgetState>();
  // 0-1, receive lighting strength
  final _minReceiveLightAmt = .35;
  final _maxReceiveLightAmt = .7;

  // 0-1, emit lighting strength
  final _minEmitLightAmt = .5;
  final _maxEmitLightAmt = 1;

  var _mousePos = Offset.zero;

  Color get _emitColor =>
      AppColors.emitColors[_difficultyOverride ?? _difficulty];

  Color get _orbColor =>
      AppColors.orbColors[_difficultyOverride ?? _difficulty];
  int _difficulty = 0;
  int? _difficultyOverride;

  double _orbEnergy = 0;
  double _minOrbEnergy = 0;

  double get _finalReceiveLightAmt {
    final light =
        lerpDouble(_maxReceiveLightAmt, _maxReceiveLightAmt, _orbEnergy) ?? 0;
    return light + _pulseEffect.value * .05 * _orbEnergy;
  }

  double get _finalEmitLightAmt {
    return lerpDouble(_minEmitLightAmt, _maxEmitLightAmt, _orbEnergy) ?? 0;
  }

  late final _pulseEffect = AnimationController(
      vsync: this,
      duration: _getRndPulseDuration(),
      lowerBound: -1,
      upperBound: 1);

  Duration _getRndPulseDuration() => 100.ms + 200.ms * Random().nextDouble();

  double _getMinEnergyForDifficulty(int difficulty) => switch (difficulty) {
        1 => 0.3,
        2 => 0.6,
        _ => 0,
      };

  @override
  void initState() {
    super.initState();
    _pulseEffect.forward();
    _pulseEffect.addListener(_handlePulseEffectUpdate);
  }

  void _handlePulseEffectUpdate() {
    if (_pulseEffect.status == AnimationStatus.completed) {
      _pulseEffect.reverse();
      _pulseEffect.duration = _getRndPulseDuration();
    } else if (_pulseEffect.status == AnimationStatus.dismissed) {
      _pulseEffect.duration = _getRndPulseDuration();
      _pulseEffect.forward();
    }
  }

  void _handleDifficultyPressed(int value) {
    setState(() => _difficulty = value);
    _bumpMinEnergy();
  }

  Future<void> _bumpMinEnergy([double amount = 0.1]) async {
    setState(() {
      _minOrbEnergy = _getMinEnergyForDifficulty(_difficulty);
    });
    await Future<void>.delayed(.2.seconds);
    setState(() {
      _minOrbEnergy = _getMinEnergyForDifficulty(_difficulty);
    });
  }

  void _handStartPressed() => _bumpMinEnergy(0.3);

  void _handleDifficultyFocused(int? value) {
    setState(() {
      _difficultyOverride = value;
      if (value == null) {
        _minOrbEnergy = _getMinEnergyForDifficulty(_difficulty);
      } else {
        _minOrbEnergy = _getMinEnergyForDifficulty(value);
      }
    });
  }

  void _handleMouseMove(PointerHoverEvent e) {
    setState(() {
      _mousePos = e.localPosition;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: MouseRegion(
          onHover: _handleMouseMove,
          child: _AnimatedColors(
              orbColor: _orbColor,
              emitColor: _emitColor,
              builder: (_, orbColor, emitColor) {
                return Stack(
                  children: [
                    // Image.asset(AssetPaths.titleBgBase,fit: BoxFit.fill,),
                    _LitImage(
                      color: _orbColor,
                      imgSrc: AssetPaths.titleBgBase,
                      lightAmt: _finalReceiveLightAmt,
                      pulseEffect: _pulseEffect,
                    ),

                    Positioned.fill(
                      child: Stack(
                        children: [
                          //orb
                          OrbShaderWidget(
                            key: _orbkey,
                            mousePos: _mousePos,
                            minEnergy: _minOrbEnergy,
                            config: OrbShaderConfig(
                              ambientLightColor: orbColor,
                              materialColor: orbColor,
                              lightColor: orbColor,
                            ),
                            onUpdate: (energy) => setState(
                              () {
                                _orbEnergy = energy;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    Positioned.fill(
                        child: IgnorePointer(
                      child:
                          ParticleOverlay(color: orbColor, energy: _orbEnergy),
                    )),

                    Positioned.fill(
                      child: TitleScreenUi(
                        difficulty: _difficulty,
                        onDifficultyFocused: _handleDifficultyFocused,
                        onDifficultyPressed: _handleDifficultyPressed,
                        onStartPressed: _handStartPressed,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 1.seconds, delay: .3.seconds);
              }),
        ),
      ),
    );
  }
}

class _LitImage extends StatelessWidget {
  const _LitImage({
    required this.color,
    required this.imgSrc,
    required this.lightAmt,
    required this.pulseEffect,
  });
  final Color color;
  final String imgSrc;
  final double lightAmt;
  //double represents the light amount.
  final AnimationController pulseEffect;
  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(color);
    return ListenableBuilder(
        listenable: pulseEffect,
        builder: (context, child) {
          return Image.asset(
            imgSrc,
            color: hsl.withLightness(hsl.lightness * lightAmt).toColor(),
            colorBlendMode: BlendMode.modulate,
            //which specifies how the color of the image should be blended with the background color.
          );
        });
  }
}

//!review again ...
class _AnimatedColors extends StatelessWidget {
  const _AnimatedColors({
    required this.emitColor,
    required this.orbColor,
    required this.builder,
  });

  final Color emitColor;
  final Color orbColor;

  final Widget Function(BuildContext context, Color orbColor, Color emitColor)
      builder;

  @override
  Widget build(BuildContext context) {
    final duration = .5.seconds;
    return TweenAnimationBuilder(
      tween: ColorTween(begin: emitColor, end: emitColor),
      duration: duration,
      builder: (_, emitColor, __) {
        return TweenAnimationBuilder(
          tween: ColorTween(begin: orbColor, end: orbColor),
          duration: duration,
          builder: (context, orbColor, __) {
            return builder(context, orbColor!, emitColor!);
          },
        );
      },
    );
  }
}
