import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmc_test/src/constants/string_constants.dart';
import 'package:mmc_test/src/network/my_db.dart';
import 'package:mmc_test/src/screens/add_update_task/cubit/task_cubit.dart';
import 'package:mmc_test/src/screens/splash/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyC55N5zjF7iCJZG8BwL5l24Rz5tunK_mWQ',
      appId: '1:522090932273:android:da5164211c8eafb46b4d10',
      messagingSenderId: '522090932273',
      projectId: 'task-todo-mmc',
      databaseURL:
          'https://task-todo-mmc-default-rtdb.asia-southeast1.firebasedatabase.app',
    ),
  );
  await MyDb.initDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<TaskCubit>(
            create: (BuildContext context) => TaskCubit(),
          )
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: StringConstants.appName,
          theme: ThemeData(useMaterial3: true),
          home: const SplashScreen(),
          builder: (context, child) {
            return Overlay(
              initialEntries: [
                if (child != null) OverlayEntry(builder: (context) => child),
              ],
            );
          },
        ));
  }
}
