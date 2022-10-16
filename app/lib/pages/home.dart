import 'package:app/pages/home/profile.dart';
import 'package:app/pages/home/search.dart';
import 'package:app/theme.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _pages = [const SearchPage(), const ProfilePage()];

  Widget _navigationBar() => Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Theme.of(context).dividerColor, width: 1))),
        child: const TabBar(tabs: [
          SizedBox(height: 50, child: Icon(Icons.search)),
          SizedBox(height: 50, child: Icon(Icons.person)),
        ]),
      );

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: _pages.length,
      child: Scaffold(
          body: TabBarView(children: _pages),
          bottomNavigationBar: _navigationBar()));
}
