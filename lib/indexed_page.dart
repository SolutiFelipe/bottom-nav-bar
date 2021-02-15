import 'package:flutter/material.dart';

class IndexedPage extends StatelessWidget {
  const IndexedPage({
    @required this.index,
    @required this.backgroundColor,
    @required this.containingFlowTitle,
    @required this.isTabPage,
    this.parentScaffoldKey,
    Key key,
  })  : assert(index != null),
        assert(backgroundColor != null),
        super(key: key);

  final int index;
  final Color backgroundColor;
  final String containingFlowTitle;
  final bool isTabPage;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  @override
  Widget build(BuildContext context) {
    var pageTitle = 'Page $index';
    if (containingFlowTitle != null) {
      pageTitle += ' of $containingFlowTitle Flow';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitle,
          maxLines: 1,
        ),
        leading: isTabPage
            ? _buildMenuDrawer()
            : null,
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Horizontally pushes a new screen.
            RaisedButton(
              color: Colors.greenAccent,
              onPressed: () {
                _pushSubPage(context);
              },
              child: const Text('NEXT PAGE (SubPage)'),
            ),

            // Vertically pushes a new screen / Starts a new flow.
            // In a real world scenario, this could be an authentication flow
            // where the user can choose to sign in or sign up.
            RaisedButton(
              color: Colors.greenAccent,
              onPressed: () {
                _pushRootPage(context);
              },
              child: const Text('NEXT FLOW (Root Page)'),
            ),

            RaisedButton(
              color: Colors.greenAccent,
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('FINISH FLOW'),
            ),
          ],
        ),
      ),
    );
  }

  void _pushSubPage(BuildContext context) {
    // If it's not subpage navigation,
    // we should use the rootNavigator.
    Navigator.of(context, rootNavigator: false).push(
      MaterialPageRoute(
        builder: (context) => IndexedPage(
          // If it's a new flow, the displayed index should be 1 again.
          index: index + 1,
          // If it's a new flow, we'll randomize its color.
          backgroundColor: backgroundColor,
          // If it's stating a new flow let's just call it 'New.'
          containingFlowTitle: containingFlowTitle,
          isTabPage: false,
        ),
        fullscreenDialog: false,
      ),
    );
  }

  void _pushRootPage(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => IndexedPage(
          index: 1,
          backgroundColor: Colors.white,
          containingFlowTitle: 'New',
          isTabPage: false,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  Widget _buildMenuDrawer() {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        parentScaffoldKey.currentState.openDrawer();
      },
      tooltip: 'Abrir menu',
    );
  }
}
