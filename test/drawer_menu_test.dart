import 'package:flutter/material.dart';
import 'package:flutter_drawer_menu/drawer_menu.dart';
import 'package:flutter_test/flutter_test.dart';

const _menuKey = ValueKey("menu_container");
const _bodyKey = ValueKey("body_container");

void main() {
  testWidgets(
    'Testing the transition from phone mode to tablet mode and back.',
    (tester) async {
      // Init screen
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(300, 600);

      await tester.pumpWidget(const TestApp(),);

      // Set tablet screen size and wait
      tester.view.physicalSize = const Size(700, 600);
      await tester.pump(const Duration(seconds: 1));

      // Check menu width (default 300 in tablet mode)
      var menuWidth = tester.getRect(find.byKey(_menuKey)).width;
      expect(300, equals(menuWidth));

      // Set phone screen size and wait
      tester.view.physicalSize = const Size(300, 600);
      await tester.pump(const Duration(seconds: 1));

      // Check body width (== screen width)
      final bodyWidth = tester.getRect(find.byKey(_bodyKey)).width;
      expect(300, equals(bodyWidth));

      // These two avoid the exception 'A Timer is still pending even after the
      // widget tree was disposed.'
      await tester.pumpWidget(const Placeholder());
      await tester.pump(const Duration(seconds: 1));
    }
  );



  testWidgets(
    "Testing open|close menu states.",
    (tester) async {
      // Init screen
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(300, 600);

      await tester.pumpWidget(const TestApp(),);
      await tester.pump(const Duration(seconds: 1));

      final DrawerMenuState drawerMenuState = tester.state(find.byType(DrawerMenu));

      // check initial state
      expect(drawerMenuState.isOpen, equals(false));

      // swipe to right
      await tester.flingFrom(const Offset(100, 100), const Offset(100, 0), 100);
      await tester.pump(const Duration(seconds: 1));
      expect(drawerMenuState.isOpen, equals(true));

      // swipe to left
      await tester.flingFrom(const Offset(100, 100), const Offset(-100, 0), 100);
      await tester.pump(const Duration(seconds: 1));
      expect(drawerMenuState.isOpen, equals(false));

      // These two avoid the exception 'A Timer is still pending even after the
      // widget tree was disposed.'
      await tester.pumpWidget(const Placeholder());
      await tester.pump(const Duration(seconds: 1));
    }
  );
}

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var drawer = DrawerMenu(
      menu: Container(
        key: _menuKey
      ),
      body: Container(
        key: _bodyKey
      ),
    );
    return MaterialApp(
      home: drawer,
    );
  }
}


