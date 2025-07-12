import 'package:flutter/material.dart';

import 'core/shared/app_router.dart';
import 'core/di/injection_container.dart' as di;

final _appRouter = AppRouter();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _registerDependencies();
  runApp(const MyApp());
}

Future<void> _registerDependencies() async {
  await di.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      return MaterialApp.router(
        routerConfig: _appRouter.config(),
        debugShowCheckedModeBanner: false,
        title: 'Crewmeister',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF4E89FF),
            onPrimary: Colors.white,
            secondary: Color(0xFFFF6B6B),
            onSecondary: Colors.white,
            surface: Colors.white,
            onSurface: Color(0xFF333333),
            error: Color(0xFFE53935),
            onError: Colors.white,
          ),
          scaffoldBackgroundColor: const Color(0xFFF9F9FB),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      );
    } catch (e, stack) {
      debugPrint('Error during router initialization: $e\n$stack');
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('App initialization failed')),
        ),
      );
    }
  }
}
