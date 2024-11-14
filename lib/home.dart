import 'dart:io';

import 'package:flutter/material.dart';
import "package:intl/intl.dart" show DateFormat;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:badges/badges.dart' as badges; // Alias the badges package
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
    );
  }
}

// SignInPage
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Create controllers to get input from the TextFields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to validate input
  void _validateAndSignIn() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Show an error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter both email and password."),
          backgroundColor: Colors.grey[700],
        ),
      );
    } else {
      // Replace with home page after successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyStatelessApp()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Heading
            const Text(
              'Welcome Back!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            // Subheading
            const Text(
              'Sign in to your account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Email TextField with Icon
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Password TextField with Icon
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Sign In Button without primary color
            ElevatedButton(
              onPressed: _validateAndSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white30, // Neutral color
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Sign In',
                style: TextStyle(fontSize: 18, color: Colors.grey[800]),
              ),
            ),
            const SizedBox(height: 15),

            // Sign Up Link without primary color
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Colors.grey[800], // Neutral color for the link
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// SignUpPage
class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Heading
            const Text(
              'Register',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            // Subheading
            const Text(
              'Create a new account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            // Name TextField
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Phone No TextField
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone),
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Room No TextField
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.home),
                labelText: 'Room Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Email TextField
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Password TextField
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Confirm Password TextField
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Register Button without primary color
            ElevatedButton(
              onPressed: () {
                // Replace with home page after successful sign-up
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyStatelessApp()),
                );// Register logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white30, // Neutral color
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Register',
                style: TextStyle(fontSize: 18, color: Colors.grey[800]),
              ),
            ),
            const SizedBox(height: 15),

            // Sign In Link without primary color
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                        color: Colors.grey[800], // Neutral color for the link
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Home page
class MyStatelessApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyStatelessApp> {
  bool isMaleSelected = true; // Track whether male or female category is selected

  // Wash and Fold Clothes Quantities
  Map<String, int> washAndFoldClothesQuantities = {
    "Shirts": 0,
    "T-Shirts": 0,
    "Shorts": 0,
    "Pants": 0,
    "Hoodies": 0,
  };

  // Special Wash Clothes Quantities
  Map<String, int> specialWashClothesQuantities = {
    "Dresses": 0,
    "Blouses": 0,
    "Suits": 0,
    "Coats": 0,
    "Others": 0,
  };

  // Special Wash Service Variables
  Map<String, bool> specialServices = {
    "Dry Cleaning": false,
    "Stain Removal": false,
    "Delicate Fabric Care": false,
    "Ironing": false,
    "Express Service": false,
  };

  String additionalInstructions = '';

  @override
  Widget build(BuildContext buildContext) {
    var time = DateTime.now();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3, // Set the number of tabs
        child: Scaffold(
          bottomNavigationBar: Builder(
            builder: (context) => CurvedNavigationBar(
              backgroundColor: Colors.blue.shade900,
              color: Colors.white, // Color of the navigation ba
              buttonBackgroundColor: Colors.white, // Color of the middle button
              height: 60, // Height of the navigation bar
              items: <Widget>[
                badges.Badge(
                  badgeContent: Text(
                    getTotalSelectedClothes().toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  showBadge: getTotalSelectedClothes() > 0,
                  position: badges.BadgePosition.topEnd(top: -12, end: -12),
                  child: const Icon(Icons.shopping_basket_outlined,
                      size: 30, color: Colors.blue),
                ),
              ],
              onTap: (index) {
                // Navigate to Basket Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BasketPage(
                      washAndFoldClothes: washAndFoldClothesQuantities,
                      specialWashClothes: specialWashClothesQuantities,
                      specialServices: specialServices,
                      additionalInstructions: additionalInstructions,
                      getTotalSelectedClothes: getTotalSelectedClothes,
                      onClearSelections: clearAllSelections,
                    ),
                  ),
                );
              },
            ),
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
                          const Text(
                            'HI NISCHAL !',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${DateFormat('yMMMMd').format(time)}',
                            style: TextStyle(color: Colors.blue[200]),
                          ),
                        ],
                      ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.circular(70),
                ),
                padding: const EdgeInsets.all(2),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(50, 50), // Adjusted size for a smaller button
                    padding: EdgeInsets.all(8), // Optional padding adjustment
                  ),
                  child: Icon(
                    Icons.person,
                    size: 20, // Smaller icon size
                  ),
                ),
              )

              ],
                  ),
                  const SizedBox(height: 20),

                  // TabBar
                  TabBar(
                    isScrollable: true,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.blue[300],
                    indicatorColor: Colors.white,
                    tabs: [
                      const Tab(
                          text: 'Wash and Fold',
                          icon: Icon(Icons.local_laundry_service)),
                      const Tab(
                          text: 'Special Wash',
                          icon: Icon(Icons.cleaning_services)),
                      const Tab(text: 'Order History', icon: Icon(Icons.history)),
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
                          buildWashAndFoldTab(),

                          // Special Wash Tab
                          buildSpecialWashTab(),

                          // Order History Tab
                          buildOrderHistoryTab(),
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

  // Function to calculate total selected clothes across both tabs
  int getTotalSelectedClothes() {
    return washAndFoldClothesQuantities.values
        .fold(0, (sum, quantity) => sum + quantity) +
        specialWashClothesQuantities.values
            .fold(0, (sum, quantity) => sum + quantity);
  }

  // Function to clear all selections after submission
  void clearAllSelections() {
    setState(() {
      washAndFoldClothesQuantities.updateAll((key, value) => 0);
      specialWashClothesQuantities.updateAll((key, value) => 0);
      specialServices.updateAll((key, value) => false);
      additionalInstructions = '';
    });
  }

  // Function to build Wash and Fold Tab
  Widget buildWashAndFoldTab() {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            children: [
              // Display Current Total Selected Clothes
              Text(
                "Total Selected Clothes: ${getTotalSelectedClothes()} / 6",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

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
                          "Male Clothes", Icons.male, Colors.blue, isMaleSelected),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isMaleSelected = false;
                        });
                      },
                      child: buildCategoryChip("Female Clothes", Icons.female,
                          Colors.pink, !isMaleSelected),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: [
                    Text(
                      isMaleSelected ? "Male Clothes" : "Female Clothes",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    // Display different clothes based on selection
                    if (isMaleSelected) ...[
                      buildClothesInputWithImage("Shirts",
                          "https://i.pinimg.com/564x/56/77/6b/56776bff129b159a5b28a3c77f9f23e7.jpg",
                          washAndFoldClothesQuantities),
                      buildClothesInputWithImage("T-Shirts",
                          "https://i.pinimg.com/564x/56/da/38/56da38304bc14602b0c0d441b40cc2a3.jpg",
                          washAndFoldClothesQuantities),
                      buildClothesInputWithImage("Shorts",
                          "https://i.pinimg.com/564x/75/cf/fd/75cffdfca25bc3d68cd33dc81cd7e733.jpg",
                          washAndFoldClothesQuantities),
                      buildClothesInputWithImage('Pants',
                          "https://i.pinimg.com/564x/2c/dd/b1/2cddb11fa2115f14492ae356fa775317.jpg",
                          washAndFoldClothesQuantities),
                      buildClothesInputWithImage("Hoodies",
                          "https://i.pinimg.com/564x/83/45/2d/83452dfc62cbce478f1d048ff652a44a.jpg",
                          washAndFoldClothesQuantities),
                    ] else ...[
                      buildClothesInputWithImage("Shirts",
                          "https://i.pinimg.com/564x/56/77/6b/56776bff129b159a5b28a3c77f9f23e7.jpg",
                          washAndFoldClothesQuantities),
                      buildClothesInputWithImage('T-Shirts',
                          "https://i.pinimg.com/564x/56/da/38/56da38304bc14602b0c0d441b40cc2a3.jpg",
                          washAndFoldClothesQuantities),
                      buildClothesInputWithImage("Skirts",
                          "https://i.pinimg.com/736x/5b/08/74/5b08748e9a55b07e651c87f9070fb4f3.jpg",
                          washAndFoldClothesQuantities),
                      buildClothesInputWithImage("Pants",
                          "https://i.pinimg.com/564x/2c/dd/b1/2cddb11fa2115f14492ae356fa775317.jpg",
                          washAndFoldClothesQuantities),
                      buildClothesInputWithImage("Towels",
                          "https://i.pinimg.com/564x/0d/80/7e/0d807e0f03223c324b4adcd7743f4c61.jpg",
                          washAndFoldClothesQuantities),
                    ],
                    const SizedBox(height: 20),

                    // Submit Button
                    ElevatedButton(
                      onPressed: () {
                        // Add action to handle form submission
                        print("Clothes added to Wash and Fold!");
                      },
                      child: const Text("Add to Basket"),
                      style: ElevatedButton.styleFrom(
                        shadowColor:
                        Colors.blue.shade900, // Button color
                      ),
                    ),
                  ],
                ),
              ),
            ]));
  }

  // Function to build Special Wash Tab
  Widget buildSpecialWashTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Display Current Total Selected Clothes
          Text(
            "Total Selected Clothes: ${getTotalSelectedClothes()} / 6",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Special Services Selection
          const Text(
            "Select Special Services",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...specialServices.keys.map((service) {
            return CheckboxListTile(
              title: Text(service),
              value: specialServices[service],
              onChanged: (bool? value) {
                setState(() {
                  specialServices[service] = value ?? false;
                });
              },
            );
          }).toList(),
          const SizedBox(height: 20),

          // Items Selection for Special Wash
          const Text(
            "Select Items for Special Wash",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...specialWashClothesQuantities.keys.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item, style: const TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (specialWashClothesQuantities[item]! > 0) {
                              specialWashClothesQuantities[item] =
                                  specialWashClothesQuantities[item]! - 1;
                            }
                          });
                        },
                      ),
                      Text('${specialWashClothesQuantities[item]}',
                          style: const TextStyle(fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: getTotalSelectedClothes() < 6
                            ? () {
                          setState(() {
                            specialWashClothesQuantities[item] =
                                specialWashClothesQuantities[item]! + 1;
                          });
                        }
                            : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "You can only select up to 6 clothes in total.")),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 20),

          // Additional Instructions
          TextField(
            decoration: const InputDecoration(
              labelText: "Additional Instructions",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            onChanged: (value) {
              setState(() {
                additionalInstructions = value;
              });
            },
          ),
          const SizedBox(height: 20),

          // Summary Section
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order Summary",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  const Text(
                    "Selected Services:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...specialServices.entries
                      .where((entry) => entry.value)
                      .map((entry) => Text("- ${entry.key}"))
                      .toList(),
                  const SizedBox(height: 10),
                  const Text(
                    "Wash and Fold Items:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...washAndFoldClothesQuantities.entries
                      .where((entry) => entry.value > 0)
                      .map((entry) => Text("- ${entry.key}: ${entry.value}"))
                      .toList(),
                  const SizedBox(height: 10),
                  const Text(
                    "Special Wash Items:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...specialWashClothesQuantities.entries
                      .where((entry) => entry.value > 0)
                      .map((entry) => Text("- ${entry.key}: ${entry.value}"))
                      .toList(),
                  const SizedBox(height: 10),
                  const Text(
                    "Additional Instructions:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(additionalInstructions.isNotEmpty
                      ? additionalInstructions
                      : "None"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Submit Button
          Center(
            child: ElevatedButton(
              onPressed: getTotalSelectedClothes() > 0
                  ? () {
                // Validate selections
                if (specialServices.values
                    .every((selected) => !selected)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                      Text("Please select at least one service.")));
                  return;
                }

                // Handle form submission
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubmissionPage(
                      onClearSelections: clearAllSelections,
                    ),
                  ),
                );
              }
                  : null,
              child: const Text("Submit"),
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build Order History Tab (Placeholder)
  Widget buildOrderHistoryTab() {
    return const Center(
        child: Text('History Content',
            style: TextStyle(color: Colors.black)));
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
        labelStyle: const TextStyle(color: Colors.black),
      ),
    );
  }

  // Function to build the input field for each type of clothing with an image
  Widget buildClothesInputWithImage(
      String clothType, String imageUrl, Map<String, int> clothesQuantities) {
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
              const SizedBox(width: 10),
              Text(clothType, style: const TextStyle(fontSize: 16)),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (clothesQuantities[clothType]! > 0) {
                      clothesQuantities[clothType] =
                          clothesQuantities[clothType]! - 1;
                    }
                  });
                },
              ),
              Text('${clothesQuantities[clothType]}',
                  style: const TextStyle(fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: getTotalSelectedClothes() < 6
                    ? () {
                  setState(() {
                    clothesQuantities[clothType] =
                        clothesQuantities[clothType]! + 1;
                  });
                }
                    : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            "You can only select up to 6 clothes in total.")),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BasketPage extends StatelessWidget {
  final Map<String, int> washAndFoldClothes;
  final Map<String, int> specialWashClothes;
  final Map<String, bool> specialServices;
  final String additionalInstructions;
  final int Function() getTotalSelectedClothes;
  final VoidCallback onClearSelections;

  const BasketPage({
    super.key,
    required this.washAndFoldClothes,
    required this.specialWashClothes,
    required this.specialServices,
    required this.additionalInstructions,
    required this.getTotalSelectedClothes,
    required this.onClearSelections,
  });

  // Helper method to build clothes list
  Widget _buildClothesList(String title, Map<String, int> clothes) {
    List<Widget> items = clothes.entries
        .where((entry) => entry.value > 0)
        .map(
          (entry) => ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.green),
        title: Text(entry.key),
        trailing: Text('Quantity: ${entry.value}'),
      ),
    )
        .toList();

    if (items.isEmpty) {
      items.add(
        const ListTile(
          title: Text('No items selected.'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Divider(),
        ...items,
        const SizedBox(height: 10),
      ],
    );
  }

  // Helper method to build selected services list
  Widget _buildServicesList(Map<String, bool> services) {
    List<Widget> selectedServices = services.entries
        .where((entry) => entry.value)
        .map(
          (entry) => ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.green),
        title: Text(entry.key),
      ),
    )
        .toList();

    if (selectedServices.isEmpty) {
      selectedServices.add(
        const ListTile(
          title: Text('No services selected.'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selected Services',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Divider(),
        ...selectedServices,
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Basket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Total Selected Clothes
              Text(
                "Total Selected Clothes: ${getTotalSelectedClothes()} / 6",
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Wash and Fold Items
              _buildClothesList(
                  'Wash and Fold Items', washAndFoldClothes),

              // Special Wash Services
              _buildServicesList(specialServices),

              // Special Wash Items
              _buildClothesList(
                  'Special Wash Items', specialWashClothes),

              // Additional Instructions
              const Text(
                'Additional Instructions',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Text(additionalInstructions.isNotEmpty
                  ? additionalInstructions
                  : 'None'),
              const SizedBox(height: 20),

              // Pickup/Dropoff Date and Time
              const PickupTimeSelector(),
              const SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (getTotalSelectedClothes() > 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubmissionPage(
                            onClearSelections: onClearSelections,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                          Text("Your basket is empty.")));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubmissionPage extends StatefulWidget {
  final VoidCallback onClearSelections;

  const SubmissionPage({super.key, required this.onClearSelections});

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay and show the animation
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/images/Laundryani.json',
          repeat: false,
          onLoaded: (composition) {
            // Perform any additional actions if needed
            Future.delayed(composition.duration, () {
              // After animation, clear selections and go back
              widget.onClearSelections();
              Navigator.of(context).popUntil((route) => route.isFirst);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Your laundry request has been submitted!")));
            });
          },
        ),
      ),
    );
  }
}

class PickupTimeSelector extends StatefulWidget {
  const PickupTimeSelector({super.key});

  @override
  State<PickupTimeSelector> createState() => _PickupTimeSelectorState();
}

class _PickupTimeSelectorState extends State<PickupTimeSelector> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  // Function to pick date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  // Function to pick time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pickup Date:',
          style: TextStyle(fontSize: 16),
        ),
        TextButton(
          onPressed: () => _selectDate(context),
          child: Text(
            DateFormat('yMMMd').format(selectedDate),
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Pickup Time:',
          style: TextStyle(fontSize: 16),
        ),
        TextButton(
          onPressed: () => _selectTime(context),
          child: Text(
            selectedTime.format(context),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  void selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text("Profile"),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          height: 120,
          width: 120,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircleAvatar(
                backgroundImage: _imageFile == null
                    ? const AssetImage("assets/images/user.png")
                    : FileImage(File(_imageFile!.path)) as ImageProvider,
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: IconButton(
                  onPressed: selectImage,
                  icon: const Icon(Icons.add_a_photo),
                  color: Colors.blueAccent,
                  iconSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
