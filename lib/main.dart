import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kafe_app/providers/field_provider.dart';
import 'package:kafe_app/providers/player_provider.dart';
import 'package:kafe_app/providers/stock_provider.dart';
import 'package:kafe_app/providers/user_provider.dart';
import 'package:kafe_app/router/router.dart';
import 'package:kafe_app/theme.dart';
import 'package:kafe_app/widgets/internals/contest_checker.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => FieldProvider()),
        ChangeNotifierProvider(create: (_) => StockProvider())
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
      title: "Kafe",
      theme: kafeTheme,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Stack(
        children: [
          child!,
          const ContestChecker(), 
      ],
  ),
    );
  }
}
