import 'dart:ui';

import 'package:extra_alignments/extra_alignments.dart';
import 'package:flutter/material.dart';
import 'package:focusable_control_builder/focusable_control_builder.dart';
import 'package:gap/gap.dart';

import '../assets.dart';
import '../styles.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../common/shader_effect.dart';
import '../common/ui_scaler.dart';
import '../common/ticking_builder.dart';  

class TitleScreenUi extends StatelessWidget {
  TitleScreenUi({
    super.key,
    required this.difficulty,
    required this.onDifficultyPressed,
    required this.onDifficultyFocused,
        required this.onStartPressed, 
  });

  final int difficulty;
  final void Function(int difficulty) onDifficultyPressed;
  final void Function(int? difficulty) onDifficultyFocused;
    final VoidCallback onStartPressed; 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 40,
        horizontal: 50,
      ),
      child: Stack(
        children: [

          BottomLeft(
            child: UiScaler(
              alignment: Alignment.bottomLeft,
              child: _DifficultyBtns(
                  difficulty: difficulty,
                  onDifficultyPressed: onDifficultyPressed,
                  onDifficultyFocused: onDifficultyFocused),
            ),
          ),
          // BottomRight(
          //   child: UiScaler(
          //     child: Padding(
          //       padding: EdgeInsets.only(bottom: 20, right: 40),
          //       child: _startBtn(onPressed: onStartPressed),
          //     ),
          //     alignment: Alignment.bottomRight,
          //   ),
          // ),
        ],
      ),
    );
  }
}



class _DifficultyBtns extends StatelessWidget {
  const _DifficultyBtns({
    required this.difficulty,
    required this.onDifficultyPressed,
    required this.onDifficultyFocused,
  });

  final int difficulty;
  final void Function(int difficulty) onDifficultyPressed;
  final void Function(int? difficulty) onDifficultyFocused;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DifficultyBtn(
          label: 'BLUE',
          selected: difficulty == 0,
          onPressed: () => onDifficultyPressed(0),
          onHover: (over) => onDifficultyFocused(over ? 0 : null),
        )
            .animate()
            .fadeIn(delay: 1.3.seconds, duration: .35.seconds)
            .slide(begin: const Offset(0, .2)),
        _DifficultyBtn(
          label: 'PURPLE',
          selected: difficulty == 1,
          onPressed: () => onDifficultyPressed(1),
          onHover: (over) => onDifficultyFocused(over ? 1 : null),
        )
            .animate()
            .fadeIn(delay: 1.3.seconds, duration: .35.seconds)
            .slide(begin: const Offset(0, .2)),
        _DifficultyBtn(
          label: 'Ocean Blue',
          selected: difficulty == 2,
          onPressed: () => onDifficultyPressed(2),
          onHover: (over) => onDifficultyFocused(over ? 2 : null),
        )
            .animate()
            .fadeIn(delay: 1.3.seconds, duration: .35.seconds)
            .slide(begin: const Offset(0, .2)),
        const Gap(20),
      ],
    );
  }
}
class _DifficultyBtn extends StatelessWidget {
  const _DifficultyBtn({
    required this.selected,
    required this.onPressed,
    required this.onHover,
    required this.label,
  });
  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final void Function(bool hasFocus) onHover;

  @override
  Widget build(BuildContext context) {
    return FocusableControlBuilder(
      onPressed: onPressed,
      onHoverChanged: (_, state) => onHover.call(state.isHovered),
      builder: (_, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 250,
            height: 60,
            child: Stack(
              children: [
            AnimatedOpacity(
            opacity: (!selected && (state.isHovered || state.isFocused))
                      ? 1
                      : 0,
                  duration: .3.seconds,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D1FF).withOpacity(.1),
                      border: Border.all(color: Colors.white, width: 5),
                    ),
                  ),
                ),
                if (state.isHovered || state.isFocused) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D1FF).withOpacity(.1),
                    ),
                  ),
                ],
                if (selected) ...[
                  CenterLeft(
                    child: Image.asset(AssetPaths.titleSelectedLeft),
                  ),
                  CenterRight(
                    child: Image.asset(AssetPaths.titleSelectedRight),
                  ),
                ],

    
                Center(
                  child: Text(label.toUpperCase(), style: TextStyles.btn),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

