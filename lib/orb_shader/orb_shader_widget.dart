import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sky_app/common/reactive_widget.dart';

import '../assets.dart';

import 'orb_shader_config.dart';
import 'orb_shader_painter.dart';

class OrbShaderWidget extends StatefulWidget {
  const OrbShaderWidget({
    super.key,
    required this.config,
    this.onUpdate,
    required this.mousePos,
    required this.minEnergy,
  });

  final double minEnergy;
  final OrbShaderConfig config;
  final Offset mousePos;
  final void Function(double energy)? onUpdate;

  @override
  State<OrbShaderWidget> createState() => OrbShaderWidgetState();
}

class OrbShaderWidgetState extends State<OrbShaderWidget>
    with SingleTickerProviderStateMixin {
  final _heartbeatSequence = TweenSequence(
    [
      TweenSequenceItem(tween: ConstantTween(0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOutCubic)),weight: 8),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.2).chain(CurveTween(curve: Curves.easeInOutCubic)),weight: 12),
      TweenSequenceItem( tween: Tween(begin: 0.2, end: 0.8).chain(CurveTween(curve: Curves.easeInOutCubic)), weight: 6),
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 0.0).chain(CurveTween(curve: Curves.easeInOutCubic)),weight: 10),
    ],
  );

  late final _heartbeatAnim =
      AnimationController(vsync: this, duration: 3000.ms)..repeat();

  @override
  
  Widget build(BuildContext context) => Consumer<FragmentPrograms?>(
        builder: (context, fragmentPrograms, _) {
          if (fragmentPrograms == null) return const SizedBox.expand();
          // a ListenableBuilder widget is used to rebuild the UI whenever _heartbeatAnim changes.
          return ListenableBuilder(
            listenable: _heartbeatAnim,
            builder: (_, __) {
              final heartbeatEnergy =
                  _heartbeatAnim.drive(_heartbeatSequence).value;
              return TweenAnimationBuilder(
                tween: Tween<double>(
                    begin: widget.minEnergy, end: widget.minEnergy),
                duration: 300.ms,
                curve: Curves.easeOutCubic,
                builder: (context, minEnergy, child) {
                  return ReactiveWidget(
                    builder: (context, time, size) {
                      double energyLevel = 0;
                      if (size.shortestSide != 0) {
                        // the (center) of the size and the mousePos is calculated. 
                        final d = (Offset(size.width, size.height) / 2 - widget.mousePos).distance;
                        final hitSize = size.shortestSide * .5;//نصف اقصر جانب من الحجم
                        energyLevel = 1 - min(1, (d / hitSize));
                        scheduleMicrotask(
                            () => widget.onUpdate?.call(energyLevel));
                      }
                      energyLevel += (1.3 - energyLevel) * heartbeatEnergy * 0.1;
                      energyLevel = lerpDouble(minEnergy, 1, energyLevel)!;
                      return CustomPaint(
                        size: size,
                        painter: OrbShaderPainter(
                          fragmentPrograms.orb.fragmentShader(),
                          config: widget.config,
                          time: time,
                          mousePos: widget.mousePos,
                          energy: energyLevel,
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
}
