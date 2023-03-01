import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weigh_mock/utils/sp.dart';
import 'package:window_manager/window_manager.dart';

import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Sp.init();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // 必须加上这一行。
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      title: "模拟地磅",
      size: Size(650, 457),
      maximumSize: Size(650, 457),
      center: true,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setBackgroundColor(Colors.transparent);
      await windowManager.setAsFrameless();
      await windowManager.show();
      await windowManager.focus();
    });
  }
  runApp(const MyApp());
}

final botToastBuilder = BotToastInit(); //1.调用BotToastInit

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '模拟地磅',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        child = botToastBuilder(context, child);
        return child;
      },
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(fontFamily: "HarmonyOS_Sans_SC_Regular", useMaterial3: true, primarySwatch: Colors.blue, colorScheme: const ColorScheme.light(primary: Colors.blue)),
      home: const HomePage(),
    );
  }
}
