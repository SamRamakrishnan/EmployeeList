import 'package:flutter/material.dart';

import 'features/albums/presentation/views/albums_view.dart';
import 'features/posts/presentation/views/posts_view.dart';
import 'features/users/presentation/views/users_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jsonplaceholder example',
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  static const Set<_Nav> _navItems = {
    _Nav(label: '', iconData: Icons.groups, view: UsersView()),
    _Nav(label: '', iconData: Icons.newspaper_rounded, view: PostsView()),
    _Nav(label: '', iconData: Icons.collections, view: AlbumsView()),
  };

  /// Selected index.
  int _currentIndex = 0;

  /// PageController for navigation items PageView.
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      appBar: AppBar(
        title: Text(_navItems.elementAt(_currentIndex).label),
      ),
      body: Row(
        children: [
          if (isLargeScreen)
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: _onNavIndexChange,
              labelType: NavigationRailLabelType.all,
              destinations: _navItems
                  .map(
                    (e) => NavigationRailDestination(
                      label: Text(e.label),
                      icon: Icon(e.iconData),
                    ),
                  )
                  .toList(),
            ),
          Expanded(
            // Using PageView to avoid creating all widgets at the start.
            // And preserving state on each page by using the AutomaticKeepAliveClientMixin.
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _navItems.map((e) => e.view).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isLargeScreen
          ? null
          : BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onNavIndexChange,
              items: _navItems
                  .map((e) => BottomNavigationBarItem(
                        label: e.label,
                        icon: Icon(e.iconData),
                      ))
                  .toList(),
            ),
    );
  }

  void _onNavIndexChange(int i) {
    setState(() {
      _currentIndex = i;
      _pageController.jumpToPage(i);
    });
  }
}

class _Nav {
  const _Nav({
    required this.label,
    required this.iconData,
    required this.view,
  });

  final String label;
  final IconData iconData;
  final Widget view;
}
