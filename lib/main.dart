import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habifa_v2/blocs/pomodoro_bloc/pomodoro_bloc.dart';
import 'package:flutter_habifa_v2/blocs/tobuy_bloc/tobuy_bloc.dart';
import 'package:flutter_habifa_v2/repository/tobuy_repo.dart';
import 'package:flutter_habifa_v2/ui/pomodoro/pomodoro_main.dart';
import 'package:flutter_habifa_v2/ui/tobuy/tobuy_main.dart';
import 'package:flutter_habifa_v2/utils/pomodoro_ticker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) => Future.value());
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager.registerOneOffTask('1', 'pomodoro');

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('az');
    return BlocProvider(
      create: (context) => PomodoroBloc(ticker: Ticker()),
      child: BlocProvider(
        create: (context) => TobuyBloc(tobuyRepository: TobuyRepository()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Habifa",
          home: MyCurveBottomNavigationBar(),
          theme: ThemeData(primaryColor: Color(0xffF95A5A)),
        ),
      ),
    );
  }
}

class MyCurveBottomNavigationBar extends StatefulWidget {
  @override
  _MyCurveBottomNavigationBarState createState() =>
      _MyCurveBottomNavigationBarState();
}

class _MyCurveBottomNavigationBarState
    extends State<MyCurveBottomNavigationBar> {
  @override
  // ignore: override_on_non_overriding_member
  var _currentIndex = 0;
  final List<Widget> _pages = [
    PomodoroMain(),
    ToBuyMainScreen(),
  ];

  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[_currentIndex],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        height: screenHeight / 17,
        items: [
          TabItem(icon: Icons.timer),
          TabItem(icon: Icons.done_all),
        ],
        initialActiveIndex: _currentIndex,
        onTap: _onTappedBar,
      ),
    );
  }

  void _onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 1) {
        BlocProvider.of<TobuyBloc>(context).add(TobuyLoadedEvent());
      } else {}
    });
  }
}
