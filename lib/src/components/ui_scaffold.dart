import 'package:flutter/material.dart';

class UIScaffold extends StatefulWidget {
  final Widget widget;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool removeBackButton;

  const UIScaffold({
    super.key,
    required this.widget,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.removeBackButton = false,
  });

  @override
  State<UIScaffold> createState() => _UIScaffoldState();
}

class _UIScaffoldState extends State<UIScaffold> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      right: false,
      left: false,
      bottom: false,
      top: false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: widget.widget,
        ),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: widget.bottomNavigationBar,
        floatingActionButton: widget.floatingActionButton,
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 30),
            child: AppBar(
              leading: widget.removeBackButton? Text(''):null,
            )),
      ),
    );
  }
}
