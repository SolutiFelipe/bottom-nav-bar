import 'package:flutter/material.dart';
import 'package:nav_bottom_bar/indexed_page.dart';

import 'app_flow.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Map<int, Color> color = {
    50: Color.fromRGBO(245, 248, 249, .1),
    100: Color.fromRGBO(245, 248, 249, .2),
    200: Color.fromRGBO(245, 248, 249, .3),
    300: Color.fromRGBO(245, 248, 249, .4),
    400: Color.fromRGBO(245, 248, 249, .5),
    500: Color.fromRGBO(245, 248, 249, .6),
    600: Color.fromRGBO(245, 248, 249, .7),
    700: Color.fromRGBO(245, 248, 249, .8),
    800: Color.fromRGBO(245, 248, 249, .9),
    900: Color.fromRGBO(245, 248, 249, 1),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFF5F8F9, color),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> homeScreenScaffoldKey = GlobalKey<ScaffoldState>();
  int _currentBarIndex = 0;

  // AppFlow is just a class I created for holding information
  // about our app's flows.
  final List<AppFlow> appFlows = [
    AppFlow(
      title: 'Início',
      iconData: Icons.home,
      mainColor: Color(0xFFF6F6F6),
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
    AppFlow(
      title: 'Contas',
      iconData: Icons.list_alt,
      mainColor: Color(0xFFF6F6F6),
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
    AppFlow(
      title: 'Identidade',
      iconData: Icons.person,
      mainColor: Color(0xFFF6F6F6),
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
    AppFlow(
      title: 'Ajuda',
      iconData: Icons.help,
      mainColor: Color(0xFFF6F6F6),
      navigatorKey: GlobalKey<NavigatorState>(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentFlow = appFlows[_currentBarIndex];
    // We're preventing the root navigator from popping and closing the app
    // when the back button is pressed and the inner navigator can handle it.
    // That occurs when the inner has more than one page on its stack.
    // You can comment the onWillPop callback and watch "the bug".
    return WillPopScope(
      onWillPop: () async => await _exitApp(currentFlow),
      child: Scaffold(
        key: homeScreenScaffoldKey,
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.canPop(context);
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => IndexedPage(
                  index: 1,
                  backgroundColor: Colors.white,
                  containingFlowTitle: 'New',
                  isTabPage: false,
                ),
                fullscreenDialog: true,
                maintainState: false,
              ),
            );
          },
          child: Icon(Icons.post_add),
        ),
        drawer: Drawer(
          child: Center(child: Text('Epic Drawer!')),
        ),
        body: IndexedStack(
          index: _currentBarIndex,
          children: appFlows
              .map(
                _buildIndexedPageFlow,
              )
              .toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Colors.black45,
          selectedItemColor: Colors.greenAccent,
          currentIndex: _currentBarIndex,
          items: appFlows
              .map(
                (flow) => BottomNavigationBarItem(
                  label: flow.title,
                  icon: Icon(flow.iconData),
                ),
              )
              .toList(),
          onTap: (newIndex) => setState(
            () {
              if (_currentBarIndex != newIndex) {
                _currentBarIndex = newIndex;
              }
              currentFlow.navigatorKey.currentState
                  .popUntil((route) => route.isFirst);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildIndexedPageFlow(AppFlow flow) {
    return Navigator(
      key: flow.navigatorKey,
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: settings,
        builder: (context) => IndexedPage(
          index: 1,
          backgroundColor: flow.mainColor,
          containingFlowTitle: flow.title,
          parentScaffoldKey: homeScreenScaffoldKey,
          isTabPage: true,
        ),
      ),
    );
  }

  Future<bool> _exitApp(AppFlow currentFlow) async {
    bool cannotPop = !currentFlow.navigatorKey.currentState.canPop();
    if (cannotPop) {
      return await showDialog<bool>(
        context: currentFlow.navigatorKey.currentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text('Sair do app ?'),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SimpleDialogOption(
                    onPressed: _accept,
                    child: Text(
                      'Sim',
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: _reject,
                    child: Text('Não'),
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    return cannotPop;
  }

  void _reject() {
    Navigator.pop(context, false);
  }

  void _accept() {
    if (homeScreenScaffoldKey.currentState.isDrawerOpen) {
      Navigator.pop(context);
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context, true);
    }
  }
}
