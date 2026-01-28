import 'package:arise_and_shine/screens/live_tv/live_tv.dart';
import 'package:arise_and_shine/screens/sermons/sermons_screen.dart';
import 'package:arise_and_shine/screens/media/media_list.dart';
import 'package:arise_and_shine/screens/profile/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arise_and_shine/components/bottom_nav_bar_item.dart';
import 'package:arise_and_shine/components/page_transition_switcher_wrapper.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/controllers/auth_controller.dart';
import 'package:arise_and_shine/controllers/home_controller.dart';
import 'package:arise_and_shine/controllers/ministry_controller.dart';
import 'package:arise_and_shine/controllers/profile_controller.dart';
import 'package:arise_and_shine/controllers/sermons_controller.dart';
import 'package:arise_and_shine/screens/home/home.dart';
import 'package:arise_and_shine/widgets/exit_dialog.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<EntryPoint> {
  static List<Widget> screens = [
    const HomeScreen(),
    const MediaListScreen(),
    const SermonsScreen(
      isAppBarVisible: false,
    ),
    const TVScreen()
  ];

  int newIndex = 0;

  @override
  void initState() {
    Get.put(ProfileController());
    Get.put(SermonsController());
    Get.put(AuthController());
    Get.put(HomeController());
    Get.put(MinistryController());

    super.initState();
  }

  List<BottomNavBarItem> getBottomNavBarItems() {
    return [
      BottomNavBarItem(
        "home".tr,
        const Icon(Icons.home),
      ),
      BottomNavBarItem(
        "media".tr,
        const Icon(Icons.photo_library),
      ),
      BottomNavBarItem(
        "sermons".tr,
        const Icon(Icons.mic),
      ),
      BottomNavBarItem(
        "Live TV".tr,
        const Icon(Icons.live_tv),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    var profileController = Get.find<ProfileController>();
    var homeController = Get.find<HomeController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!homeController.isFullScreenMode.value) {
          if (newIndex != 0) {
            setState(() {});
            newIndex = 0;
          } else {
            // Show exit confirmation dialog
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return exitDialog(context);
              },
            );
          }
        }
      },
      child: Obx(
        () => Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.transparent,
          endDrawer: const AppDrawer(),
          appBar: newIndex == 3
              ? null
              : AppBar(
                  leading: const SizedBox(),
                  actions: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: whiteColor,
                        value: Get.locale?.languageCode ?? 'en',
                        style: const TextStyle(fontSize: 13),
                        icon: Icon(
                          Icons.language,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'en',
                            child: "Eng".text.color(primaryColor).make(),
                          ),
                          DropdownMenuItem(
                            value: 'sw',
                            child: "Swa".text.color(primaryColor).make(),
                          ),
                          // Add more languages here
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(
                              () {
                                profileController.changeLanguage(value).then(
                                  (value) {
                                    if (value == true) {
                                      profileController.fetchUserDetails().then(
                                        (value) {
                                          if (value != false) {
                                            profileController.getUserDetails();
                                          }
                                        },
                                      );
                                    }
                                  },
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.menu,
                      ),
                      onPressed: () {
                        scaffoldKey.currentState?.openEndDrawer();
                      },
                    ),
                  ],
                  leadingWidth: 0,
                  title: Image.asset("assets/images/appbarlogo.png",
                      height: 30, fit: BoxFit.fitHeight),
                ),
          body: Center(
            child: Scaffold(
              bottomNavigationBar: homeController.isFullScreenMode.value
                  ? null
                  : BottomNavigationBar(
                      currentIndex: newIndex,
                      type: BottomNavigationBarType.fixed,
                      unselectedItemColor: homeController.isDarkMode.value
                          ? const Color.fromRGBO(255, 255, 255, 0.8)
                          : const Color.fromRGBO(0, 0, 0, 0.8),
                      onTap: (index) {
                        setState(() {
                          newIndex = index;
                        });
                      },
                      items: getBottomNavBarItems()
                          .map(
                            (item) => BottomNavigationBarItem(
                              icon: item.icon,
                              label: item.title,
                            ),
                          )
                          .toList(),
                    ),
              body: PageTransitionSwitcherWrapper(
                child: screens[newIndex],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
