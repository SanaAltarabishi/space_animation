import 'dart:ui';

class AssetPaths {
  /// Images
  static const String _images = 'assets/images';

  static const String titleBgBase = '$_images/sky6.jpg';
  //static const String titleBgReceive = '$_images/bg-light-receive.png';
  //static const String titleFgEmit = '$_images/fg-light-emit.png';
  //static const String titleFgReceive = '$_images/fg-light-receive.png';
  //static const String titleFgBase = '$_images/fg-base.png';
  //static const String titleMgEmit = '$_images/mg-light-emit.png';
  //static const String titleMgReceive = '$_images/mg-light-receive.png';
  //static const String titleMgBase = '$_images/mg-base.png';
  static const String titleStartBtn = '$_images/button-start.png';
  static const String titleStartBtnHover = '$_images/button-start-hover.png';
  //static const String titleStartArrow = '$_images/button-start-arrow.png';
  static const String titleSelectedLeft = '$_images/select-left.png';
  static const String titleSelectedRight = '$_images/select-right.png';
  static const String pulseParticle = '$_images/particle3.png';

  /// Shaders
  static const String _shaders = 'assets/shaders';
  static const String orbShader = '$_shaders/orb_shader.frag';
  static const String uiShader = '$_shaders/ui_glitch.frag';
}

/*typedef is a keyword used to define a function type alias. 
It allows you to create a custom type that represents a specific function signature.
By using typedef, 
you can give a name to a function signature and use that name to declare variables, parameters,
and return types of functions. This improves code readability and makes it easier to understand
the purpose and expected behavior of functions. */

//!typedef ?? and what it exaxtuly do (fragment program )?
typedef FragmentPrograms = ({FragmentProgram orb, FragmentProgram ui});

Future<FragmentPrograms> loadFragmentPrograms() async => (
      orb: (await _loadFragmentProgram(AssetPaths.orbShader)),
      ui: (await _loadFragmentProgram(AssetPaths.uiShader)),
    );

Future<FragmentProgram> _loadFragmentProgram(String path) async {
  return (await FragmentProgram.fromAsset(path));
}
