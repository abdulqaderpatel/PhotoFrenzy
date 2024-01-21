import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:photofrenzy/global/theme_mode.dart';
import 'package:photofrenzy/main_pages/add_post.dart';
import 'package:photofrenzy/main_pages/community.dart';
import 'package:photofrenzy/main_pages/profile.dart';
import 'package:photofrenzy/main_pages/search.dart';

import 'home.dart';

class UserNavigationBar extends StatefulWidget {
  const UserNavigationBar({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<UserNavigationBar> {


  final controller = PersistentTabController(initialIndex: 0);

  // Create a list of pages or tabs
  List<Widget> _buildScreen() {
    return [
      const HomeScreen(),
      const SearchScreen(),
      const AddPostScreen(),
      const Community(),
      ProfileScreen(
        id: FirebaseAuth.instance.currentUser!.uid,
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItem() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.home,
          color: isDark(context) == true ? Colors.white : Colors.black,
        ),
        inactiveIcon: const Icon(
          Icons.home_outlined,
          color: Colors.grey,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.search,
          color: isDark(context) == true ? Colors.white : Colors.black,
        ),
        inactiveIcon: const Icon(
          Icons.search_outlined,
          color: Colors.grey,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.add,
          color: isDark(context) == true ? Colors.white : Colors.black,
        ),
        inactiveIcon: const Icon(
          Icons.add_outlined,
          color: Colors.grey,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.groups,
          color: isDark(context) == true ? Colors.white : Colors.black,
        ),
        inactiveIcon: const Icon(
          Icons.groups_outlined,
          color: Colors.grey,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.person_2,
          color: isDark(context) == true ? Colors.white : Colors.black,
        ),
        inactiveIcon: const Icon(
          Icons.person_2_outlined,
          color: Colors.grey,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PersistentTabView(
        context,
        screens: _buildScreen(),
        items: _navBarItem(),
        backgroundColor:
            isDark(context) == true ? const Color(0xff141C27) : Colors.white,
        decoration: NavBarDecoration(borderRadius: BorderRadius.circular(1)),
        navBarStyle: NavBarStyle.style3,
        controller: controller,
      ),
    );
  }
}
