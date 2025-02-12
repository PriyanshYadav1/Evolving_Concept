import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threadswap/Dashboard/Home_Page.dart';
import 'package:threadswap/Dashboard/MediaPlayer.dart';
import 'package:threadswap/Globals.dart' as globals;

class Dashboard_Screen extends StatefulWidget {
  const Dashboard_Screen({super.key});

  @override
  _Dashboard_ScreenState createState() => _Dashboard_ScreenState();
}

class _Dashboard_ScreenState extends State<Dashboard_Screen> {
  int _selectedIndex = 0; // Track the selected tab index

  late String Username;
  late String UserEmail;

  // List of pages corresponding to each tab
  static List<Widget> _pages = <Widget>[
    Home_Page(),
    MediaPlayerPage(),
    const Center(child: Text("Post Page")),
    const Center(child: Text("Search Page")),
    const Center(child: Text("Profile Page")),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // Future<void> loadUser() async {
  //   String fethcedUsername = await getUsername();
  //   String fetchedUserEmail = await getUserEmail();
  //   setState(() {
  //     Username = fethcedUsername;
  //     print('Fetched UserName before Globals $Username');
  //     globals.Username = Username;
  //     UserEmail = fetchedUserEmail;
  //     print('Fetched UserEmail before Globals $UserEmail');
  //     globals.UserEmail = UserEmail;
  //   });
  // }

  // Function to handle tab changes
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected tab index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex], // Display the page based on selected tab
      bottomNavigationBar: CrystalNavigationBar(
        selectedItemColor: Colors.red,
        borderRadius: 15,
        currentIndex: _selectedIndex,
        // Set current index to _selectedIndex
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black.withOpacity(0.1),
        onTap: _onItemTapped,
        // Use _onItemTapped to handle tab change
        items: [
          /// Home
          CrystalNavigationBarItem(
            icon: IconlyBold.home,
            unselectedIcon: IconlyLight.home,
            selectedColor: Colors.white,
          ),

          /// Favourite
          CrystalNavigationBarItem(
            icon: IconlyBold.heart,
            unselectedIcon: IconlyLight.heart,
            selectedColor: Colors.red,
          ),

          // /// Add
          // CrystalNavigationBarItem(
          //   icon: IconlyBold.plus,
          //   unselectedIcon: IconlyLight.plus,
          //   selectedColor: Colors.green,
          // ),

          /// Search
          CrystalNavigationBarItem(
              icon: IconlyBold.search,
              unselectedIcon: IconlyLight.search,
              selectedColor: Colors.blue),

          /// Profile
          CrystalNavigationBarItem(
            icon: IconlyBold.user2,
            unselectedIcon: IconlyLight.user3,
            selectedColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  // Future<String> getUsername() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? username = await prefs.getString("username");
  //   if (username != null) print('Received from Shared Prefrence $username');
  //   return username ?? "Developer";
  // }
  //
  // Future<String> getUserEmail() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? useremail = await prefs.getString("useremail");
  //   if (useremail != null) print('Received from Shared Prefrence $useremail');
  //   return useremail ?? "admin@mail.com";
  // }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Home Page",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Search Page",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Profile Page",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
