import 'package:flutter/material.dart';
import 'package:keep_me_save/authentication/authentication.dart';
import 'package:keep_me_save/secrets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SuperbaseSecret.url,
    anonKey: SuperbaseSecret.anonKey,
  );
  final auth = Authentication();
  bool isLogin = await auth.isLoginAuth();
  runApp(MyApp(isLogin: isLogin));
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  const MyApp({
    Key? key,
    required this.isLogin,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: isLogin ? '/home' : '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/home': (_) => const HomeScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
