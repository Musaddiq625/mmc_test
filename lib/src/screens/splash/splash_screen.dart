import 'package:flutter/material.dart';
import 'package:mmc_test/src/components/ui_scaffold.dart';
import 'package:mmc_test/src/constants/sizedbox_constants.dart';
import 'package:mmc_test/src/constants/string_constants.dart';
import 'package:mmc_test/src/screens/add_update_task/add_update_task_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1500)).then(
      (value) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
        widget: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          StringConstants.appName,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBoxConstants.twentyH(),
        const CircularProgressIndicator()
      ],
    )));
  }
}
