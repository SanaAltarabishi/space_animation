import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sky_app/assets.dart';
import 'package:sky_app/title_screen.dart';
import 'package:window_size/window_size.dart';

void main() {
  if(!kIsWeb && (Platform.isWindows||Platform.isLinux||Platform.isMacOS)){
    WidgetsFlutterBinding.ensureInitialized();
    setWindowMinSize(const Size(800,500));
  }
  Animate.restartOnHotReload =true;
  runApp(
    FutureProvider<FragmentPrograms?>(create:(context) => loadFragmentPrograms(), initialData:null,
   child: const SkyApp()));
}
class SkyApp extends StatelessWidget {
  const SkyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
themeMode: ThemeMode.dark,
darkTheme: ThemeData(brightness: Brightness.dark,),
home:TitleScreen() ,
    );
  }
}