import 'package:flutter/material.dart';
import 'package:task_project/presentation/tabs/cached_screen/cached_screen.dart';
import 'package:task_project/presentation/tabs/home_screen/home_screen.dart';

class TabBox extends StatefulWidget {
  const TabBox({Key? key}) : super(key: key);

  @override
  State<TabBox> createState() => _TabBoxState();
}

class _TabBoxState extends State<TabBox> {
  List screens = const [
    HomeScreen(),
    CachedScreen(),
  ];
  int selectedIndex = 0;
  IconData icon = Icons.home_outlined;
  IconData icon1 = Icons.favorite_border;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[selectedIndex],
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(5),
          decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(26), bottom: Radius.circular(10))),
          child: BottomNavigationBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            currentIndex: selectedIndex,
            onTap: (index) {
              selectedIndex = index;
              icon1 = selectedIndex == 1?  Icons.favorite:Icons.favorite_border;
              icon = selectedIndex == 0?  Icons.home:Icons.home_outlined;
              setState(() {});
            },
            type: BottomNavigationBarType.values.first,
            selectedFontSize: 18,
            selectedIconTheme: const IconThemeData(color: Colors.red),
            selectedItemColor: Colors.white,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedFontSize: 18,
            unselectedIconTheme:  IconThemeData(color: Colors.red.withOpacity(0.5)),
            unselectedItemColor: Colors.white.withOpacity(0.5),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            items:  [
              BottomNavigationBarItem(
                  icon: Icon(icon),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(icon1), label: "Favourites"),
            ],
          ),
        ));
  }
}
