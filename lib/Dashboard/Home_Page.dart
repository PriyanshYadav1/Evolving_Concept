import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threadswap/Globals.dart' as globals;
import 'package:threadswap/Login_Page/login_screen.dart';
import 'package:threadswap/Services/googleAuthService.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  HomePage_State createState() => HomePage_State();
}

class HomePage_State extends State<Home_Page> {

  late String Username;
  late String UserEmail;

  String truncateString(String str) {
    // Split the string into words
    List<String> words = str.split(' ');

    // Check if the first word is longer than 10 characters
    if (words.isNotEmpty && words[0].length > 10) {
      return words[0].substring(0, 10) + "...";
    }

    // Return the first word if it's not longer than 10 characters
    return words.isNotEmpty ? words[0] : '';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUser();
    User? user = FirebaseAuth.instance.currentUser;
  }

  Future<void> loadUser() async {
    String fethcedUsername = await getUsername();
    String fetchedUserEmail = await getUserEmail();
    setState(() {
      Username = fethcedUsername;
      print('Fetched UserName before Globals $Username');
      globals.Username = Username;
      UserEmail = fetchedUserEmail;
      print('Fetched UserEmail before Globals $UserEmail');
      globals.UserEmail = UserEmail;
    });
  }

  Future<String> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = await prefs.getString("username");
    if (username != null) print('Received from Shared Prefrence $username');
    return username ?? "Developer";
  }

  Future<String> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? useremail = await prefs.getString("useremail");
    if (useremail != null) print('Received from Shared Prefrence $useremail');
    return useremail ?? "admin@mail.com";
  }


  void logout(BuildContext context) async {
    GoogleAuthService log = new GoogleAuthService();
    var status = await log.signOut();
    if (status['status'] == 'success') {

      // Navigate to Login screen after logout
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login_Screen()),
            (route) => false,
      );
    } else {
      var snackBar = SnackBar(
        content: Text('Logout failed, try again'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }


  @override
  Widget build(BuildContext context) {
    // Sample data for the grid cards (you can change it to any data structure)
    List<String> cardTitles = [
      "Customers",
      "Products",
      "Revenue",
      "Statistics"
    ];
    List<String> cardImages = [
      "assets/images/Customer.png",
      "assets/images/package.png",
      "assets/images/money.png",
      "assets/images/profit.png"
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Color.fromRGBO(26, 24, 48, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  // color: Colors.purpleAccent,
                  borderRadius: BorderRadius.only(
                    bottomLeft:
                    Radius.circular(60), // Set the radius for bottom-left
                  ),
                  image: DecorationImage(
                      image: AssetImage("assets/images/home2.png"),
                      fit: BoxFit.cover),
                ),
                height: MediaQuery
                    .of(context)
                    .size
                    .height *
                    0.36, // Adjust size as needed
                width: double.infinity, // Adjust size as needed
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.06,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Hello ${truncateString(Username)} !",
                            style: TextStyle(
                                fontFamily: 'helvetica',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,0,10,0),
                            child: Image.asset(
                              "assets/images/user.png",
                              fit: BoxFit.cover,
                              height: 50,
                              width: 50,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Today's Sales",
                        style: TextStyle(
                            fontFamily: 'helvetica',
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "\$",
                            style: TextStyle(
                                fontFamily: 'helvetica',
                                fontSize: 33,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "1260.40  ",
                            style: TextStyle(
                                fontFamily: 'helvetica',
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          IconButton(
                              onPressed: () {
                                logout(context);
                              },
                              icon: Image.asset(
                                'assets/images/logout.png',
                                fit: BoxFit.cover,
                                height: 50,
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              // Add the GridView.builder below the header
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(19.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      // Number of columns in the grid
                      crossAxisSpacing: 17,
                      // Horizontal space between grid items (adjusted)
                      mainAxisSpacing: 17,
                      // Vertical space between grid items (adjusted)
                      childAspectRatio:
                      1, // Aspect ratio of each item (height / width)
                    ),
                    itemCount: cardTitles.length, // Number of items to display
                    itemBuilder: (context, index) {
                      return Card(
                        color: Color.fromRGBO(44, 41, 74, 1),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image(
                                image: AssetImage(cardImages[index]),
                                height: 50,
                              ),
                              Text(
                                cardTitles[index],
                                // Display the title for each card
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'helvetica',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}