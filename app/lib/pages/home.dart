import 'package:app/pages/home/profile.dart';
import 'package:app/pages/home/search.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _pages = [const SearchPage(), const ProfilePage()];
  int _index = 1;

  @override
  Widget build(BuildContext context) => Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() => _index = value),
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
        ],
      ),
      body: _pages[_index]);
}
