import 'package:campusconnect/providers/user_provider.dart';
import 'package:campusconnect/responsive/mobile_screen_layout.dart';
import 'package:campusconnect/responsive/responsive_layout_screen.dart';
import 'package:campusconnect/responsive/web_screen_layout.dart';
import 'package:campusconnect/screens/login_screen.dart';
import 'package:campusconnect/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBB94Ng0QyKuzMWB-PXaJSOWQkM2sVpfZ8",
        appId: "1:1044058346384:android:92cb79843df4bc8e465915",
        messagingSenderId: "1044058346384",
        projectId: "campusconnect-7c358",
        storageBucket: "campusconnect-7c358.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  webSecreenLayout: WebScreenlayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}