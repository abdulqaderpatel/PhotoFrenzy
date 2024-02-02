import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
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

  final List<Widget> userPages = [
    const HomeScreen(),
    const SearchScreen(),
    const AddPostScreen(),
    const Community(),
    ProfileScreen(
      id: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];

  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            backgroundColor: isDark(context) == true
                ? const Color(0xff141C27)
                : Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.white,
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: currentIndex == 0
                    ? Icon(
                        Icons.home,
                        color: isDark(context) == true
                            ? Colors.white
                            : Colors.black,
                      )
                    : const Icon(
                        Icons.home_outlined,
                        color: Colors.grey,
                      ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: currentIndex == 1
                    ? Icon(
                        Icons.search,
                        color: isDark(context) == true
                            ? Colors.white
                            : Colors.black,
                      )
                    : const Icon(
                        Icons.search_outlined,
                        color: Colors.grey,
                      ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: currentIndex == 2
                    ? Icon(
                        Icons.add,
                        color: isDark(context) == true
                            ? Colors.white
                            : Colors.black,
                      )
                    : const Icon(
                        Icons.add_outlined,
                        color: Colors.grey,
                      ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: currentIndex == 3
                    ? Icon(
                        Icons.groups,
                        color: isDark(context) == true
                            ? Colors.white
                            : Colors.black,
                      )
                    : const Icon(
                        Icons.groups_outlined,
                        color: Colors.grey,
                      ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: currentIndex == 4
                    ? Icon(
                        Icons.person_2,
                        color: isDark(context) == true
                            ? Colors.white
                            : Colors.black,
                      )
                    : const Icon(
                        Icons.person_2_outlined,
                        color: Colors.grey,
                      ),
                label: '',
              ),
            ],
          ),
          body: userPages[currentIndex]),
    );
  }
}
