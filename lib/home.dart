import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key}); // Removed the comment from here

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isMaleSelected = true; // Track whether male or female category is selected

  // Variables to track quantity for different types of clothes
  Map<String, int> maleClothesQuantities = {
    "Shirts": 0,
    "T-Shirts": 0,
    "Shorts": 0,
    "Pants": 0,
    "Hoodies": 0,
  };

  Map<String, int> femaleClothesQuantities = {
    "Shirts": 0,
    "T-Shirts": 0,
    "Skirts": 0,
    "Pants": 0,
    "Towels": 0,
  };

  @override
  Widget build(BuildContext buildContext) {
    var time = DateTime.now();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3, // Set the number of tabs
        child: Scaffold(
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.blue.shade900,
            color: Colors.white, // Color of the navigation bar
            buttonBackgroundColor: Colors.white, // Color of the middle button
            height: 60, // Height of the navigation bar
            items: <Widget>[
              Icon(Icons.shopping_basket_outlined, size: 30, color: Colors.blue), // Only basket icon in the middle
            ],
            onTap: (index) {
              // Handle item tap if needed
              print("Basket Icon Pressed");
            },
          ),
          backgroundColor: Colors.blue[900],
          body: Padding(
            padding: const EdgeInsets.all(25),
            child: SafeArea(
              child: Column(
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HI NISCHAL !',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${DateFormat('yMMMMd').format(time)}',
                            style: TextStyle(color: Colors.blue[200]),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: EdgeInsets.all(0),
                        child:GestureDetector(
                          onTap: () {
                            Navigator.push(buildContext,
                                MaterialPageRoute(builder: (context) => const ProfilePage(),)
                            );
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            color: Colors.red,
                          ),
                        )

                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // TabBar
                  TabBar(
                    isScrollable: true,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.blue[300],
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(
                          text: 'Wash and fold',
                          icon: Icon(Icons.local_laundry_service)),
                      Tab(
                          text: 'Special wash',
                          icon: Icon(Icons.dry_cleaning_sharp)),
                      Tab(
                          text: 'Order History', icon: Icon(Icons.history)),
                    ],
                  ),

                  // TabBarView for content
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white),
                      child: TabBarView(
                        children: [
                          // Wash and Fold Tab with types of clothes and quantity
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                // Horizontal scrollable Male and Female clothes
                                SizedBox(
                                  height: 50, // Height of the scrollable bar
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isMaleSelected = true;
                                          });
                                        },
                                        child: buildCategoryChip(
                                            "Male Clothes",
                                            Icons.male,
                                            Colors.blue,
                                            isMaleSelected),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isMaleSelected = false;
                                          });
                                        },
                                        child: buildCategoryChip(
                                            "Female Clothes",
                                            Icons.female,
                                            Colors.pink,
                                            !isMaleSelected),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),

                                Expanded(
                                  child: ListView(
                                    children: [
                                      Text(
                                        isMaleSelected
                                            ? "Male Clothes"
                                            : "Female Clothes",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 20),

                                      // Display different clothes based on selection
                                      if (isMaleSelected) ...[
                                        buildClothesInputWithImage(
                                            "Shirts",
                                            "https://i.pinimg.com/564x/56/77/6b/56776bff129b159a5b28a3c77f9f23e7.jpg",
                                            maleClothesQuantities),
                                        buildClothesInputWithImage(
                                            "T-Shirts",
                                            "https://i.pinimg.com/564x/56/da/38/56da38304bc14602b0c0d441b40cc2a3.jpg",
                                            maleClothesQuantities),
                                        buildClothesInputWithImage(
                                            "Shorts",
                                            "https://i.pinimg.com/564x/75/cf/fd/75cffdfca25bc3d68cd33dc81cd7e733.jpg",
                                            maleClothesQuantities),
                                        buildClothesInputWithImage(
                                            'Pants',
                                            "https://i.pinimg.com/564x/2c/dd/b1/2cddb11fa2115f14492ae356fa775317.jpg",
                                            maleClothesQuantities),
                                        buildClothesInputWithImage(
                                            "Hoodies",
                                            "https://i.pinimg.com/564x/83/45/2d/83452dfc62cbce478f1d048ff652a44a.jpg",
                                            maleClothesQuantities),
                                      ] else ...[
                                        buildClothesInputWithImage(
                                            "Shirts",
                                            "https://i.pinimg.com/564x/56/77/6b/56776bff129b159a5b28a3c77f9f23e7.jpg",
                                            femaleClothesQuantities),
                                        buildClothesInputWithImage(
                                            'T-Shirts',
                                            "https://i.pinimg.com/564x/56/da/38/56da38304bc14602b0c0d441b40cc2a3.jpg",
                                            femaleClothesQuantities),
                                        buildClothesInputWithImage(
                                            "Skirts",
                                            "https://i.pinimg.com/736x/5b/08/74/5b08748e9a55b07e651c87f9070fb4f3.jpg",
                                            femaleClothesQuantities),
                                        buildClothesInputWithImage(
                                            "Pants",
                                            "https://i.pinimg.com/564x/2c/dd/b1/2cddb11fa2115f14492ae356fa775317.jpg",
                                            femaleClothesQuantities),
                                        buildClothesInputWithImage(
                                            "Towels",
                                            "https://i.pinimg.com/564x/0d/80/7e/0d807e0f03223c324b4adcd7743f4c61.jpg",
                                            femaleClothesQuantities),
                                      ],
                                      SizedBox(height: 20),

                                      // Submit Button
                                      ElevatedButton(
                                        onPressed: () {
                                          // Add action to handle form submission
                                          print("Clothes added to Wash and Fold!");
                                        },
                                        child: Text("Add to Basket"),
                                        style: ElevatedButton.styleFrom(
                                          shadowColor:
                                          Colors.blue.shade900, // Button color
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Special Wash Tab
                          Center(
                              child: Text('Services Content',
                                  style: TextStyle(color: Colors.black))),

                          // Order History Tab
                          Center(
                              child: Text('History Content',
                                  style: TextStyle(color: Colors.black))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to build each category as a Chip for male and female clothes
  Widget buildCategoryChip(
      String category, IconData icon, Color color, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Chip(
        label: Text(category),
        avatar: Icon(icon, color: color),
        backgroundColor: isSelected ? Colors.blue[100] : Colors.grey[200],
        labelStyle: TextStyle(color: Colors.black),
      ),
    );
  }

  // Function to build the input field for each type of clothing with an image
  // Function to build the input field for each type of clothing with an image
  Widget buildClothesInputWithImage(String clothType, String imageUrl, Map<String, int> clothesQuantities) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.network(
                imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10),
              Text(clothType, style: TextStyle(fontSize: 16)),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (clothesQuantities[clothType]! > 0) {
                      clothesQuantities[clothType] = clothesQuantities[clothType]! - 1;
                    }
                  });
                },
              ),
              Text('${clothesQuantities[clothType]}', style: TextStyle(fontSize: 16)),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    if (clothesQuantities[clothType]! < 6) { // Limit to a maximum of 6
                      clothesQuantities[clothType] = clothesQuantities[clothType]! + 1;
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'),
      ),
      body: Text('lakal'),
    );
  }
}

