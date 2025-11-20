import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/supabase_config.dart';
import 'core/di/service_locator.dart';
import 'presentation/router/router.dart';
import 'data/data_source/local_storage/hive_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Supabase initialization
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  // Hive initialization
  await initHive();

  // Dependency Injection setup
  await setupServiceLocator();

  // Check login status
  final isLoggedIn = Supabase.instance.client.auth.currentUser != null;

  runApp(
    ProviderScope(
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(360, 800), // 피그마 디자인 기준 크기
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Note Timer',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB8860B)),
            useMaterial3: true,
            fontFamily: 'NanumGothic',
          ),
          routerConfig: createRouter(isLoggedIn),
        );
      },
    );
  }
}
