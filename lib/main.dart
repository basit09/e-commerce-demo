import 'package:e_commerce_task/infrastructure/provider/provider_registration.dart';
import 'package:e_commerce_task/ui/home_screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ui/login_screen/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyAm90sotO2XU-ZB24KGkxUgA2zbYF3-YQs',
          appId: '1:130988735620:android:f9bf5ad6774c7ef54d96d1',
          messagingSenderId: '130988735620',
          projectId: 'e-commerce-f02f7'));
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    ref.read(authProvider).isUserLoggedIn();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final authProviderWatch = ref.watch(authProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: authProviderWatch.isLoggedIn
          ? const HomeScreen()
          : const LoginScreen(),
    );
  }
}
