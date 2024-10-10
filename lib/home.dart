// main.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:badges/badges.dart' as badges; // Alias the badges package
import 'package:lottie/lottie.dart'; // For animations

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
              color: Colors.white, // Color of the navigation bar
              buttonBackgroundColor: Colors.white, // Color of the middle button
              height: 60, // Height of the navigation bar
              items: <Widget>[
                badges.Badge(
                  badgeContent: Text(
                    getTotalSelectedClothes().toString(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  showBadge: getTotalSelectedClothes() > 0,
                  position: badges.BadgePosition.topEnd(top: -12, end: -12),
                  child: Icon(Icons.shopping_basket_outlined,
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
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  buildContext,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const ProfilePage()));
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              color: Colors.red,
                            ),
                          )),
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
                          text: 'Wash and Fold',
                          icon: Icon(Icons.local_laundry_service)),
                      Tab(
                          text: 'Special Wash',
                          icon: Icon(Icons.cleaning_services)),
                      Tab(text: 'Order History', icon: Icon(Icons.history)),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

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
              SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: [
                    Text(
                      isMaleSelected ? "Male Clothes" : "Female Clothes",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),

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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),

          // Special Services Selection
          Text(
            "Select Special Services",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
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
          SizedBox(height: 20),

          // Items Selection for Special Wash
          Text(
            "Select Items for Special Wash",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ...specialWashClothesQuantities.keys.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item, style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
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
                          style: TextStyle(fontSize: 16)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: getTotalSelectedClothes() < 6
                            ? () {
                          setState(() {
                            specialWashClothesQuantities[item] =
                                specialWashClothesQuantities[item]! + 1;
                          });
                        }
                            : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
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
          SizedBox(height: 20),

          // Additional Instructions
          TextField(
            decoration: InputDecoration(
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
          SizedBox(height: 20),

          // Summary Section
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Summary",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  Text(
                    "Selected Services:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...specialServices.entries
                      .where((entry) => entry.value)
                      .map((entry) => Text("- ${entry.key}"))
                      .toList(),
                  SizedBox(height: 10),
                  Text(
                    "Wash and Fold Items:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...washAndFoldClothesQuantities.entries
                      .where((entry) => entry.value > 0)
                      .map((entry) => Text("- ${entry.key}: ${entry.value}"))
                      .toList(),
                  SizedBox(height: 10),
                  Text(
                    "Special Wash Items:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...specialWashClothesQuantities.entries
                      .where((entry) => entry.value > 0)
                      .map((entry) => Text("- ${entry.key}: ${entry.value}"))
                      .toList(),
                  SizedBox(height: 10),
                  Text(
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
          SizedBox(height: 20),

          // Submit Button
          Center(
            child: ElevatedButton(
              onPressed: getTotalSelectedClothes() > 0
                  ? () {
                // Validate selections
                if (specialServices.values
                    .every((selected) => !selected)) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
              child: Text("Submit"),
              style: ElevatedButton.styleFrom(
                padding:
                EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build Order History Tab (Placeholder)
  Widget buildOrderHistoryTab() {
    return Center(
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
        labelStyle: TextStyle(color: Colors.black),
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
                      clothesQuantities[clothType] =
                          clothesQuantities[clothType]! - 1;
                    }
                  });
                },
              ),
              Text('${clothesQuantities[clothType]}',
                  style: TextStyle(fontSize: 16)),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: getTotalSelectedClothes() < 6
                    ? () {
                  setState(() {
                    clothesQuantities[clothType] =
                        clothesQuantities[clothType]! + 1;
                  });
                }
                    : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
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
    Key? key,
    required this.washAndFoldClothes,
    required this.specialWashClothes,
    required this.specialServices,
    required this.additionalInstructions,
    required this.getTotalSelectedClothes,
    required this.onClearSelections,
  }) : super(key: key);

  // Helper method to build clothes list
  Widget _buildClothesList(String title, Map<String, int> clothes) {
    List<Widget> items = clothes.entries
        .where((entry) => entry.value > 0)
        .map(
          (entry) => ListTile(
        leading: Icon(Icons.check_circle, color: Colors.green),
        title: Text(entry.key),
        trailing: Text('Quantity: ${entry.value}'),
      ),
    )
        .toList();

    if (items.isEmpty) {
      items.add(
        ListTile(
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
          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Divider(),
        ...items,
        SizedBox(height: 10),
      ],
    );
  }

  // Helper method to build selected services list
  Widget _buildServicesList(Map<String, bool> services) {
    List<Widget> selectedServices = services.entries
        .where((entry) => entry.value)
        .map(
          (entry) => ListTile(
        leading: Icon(Icons.check_circle, color: Colors.green),
        title: Text(entry.key),
      ),
    )
        .toList();

    if (selectedServices.isEmpty) {
      selectedServices.add(
        ListTile(
          title: Text('No services selected.'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected Services',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Divider(),
        ...selectedServices,
        SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Basket'),
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
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Wash and Fold Items
              _buildClothesList(
                  'Wash and Fold Items', washAndFoldClothes),

              // Special Wash Services
              _buildServicesList(specialServices),

              // Special Wash Items
              _buildClothesList(
                  'Special Wash Items', specialWashClothes),

              // Additional Instructions
              Text(
                'Additional Instructions',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(),
              Text(additionalInstructions.isNotEmpty
                  ? additionalInstructions
                  : 'None'),
              SizedBox(height: 20),

              // Pickup/Dropoff Date and Time
              PickupTimeSelector(),
              SizedBox(height: 20),

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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                          Text("Your basket is empty.")));
                    }
                  },
                  child: Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    padding:
                    EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
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

class SubmissionPage extends StatefulWidget {
  final VoidCallback onClearSelections;

  const SubmissionPage({Key? key, required this.onClearSelections})
      : super(key: key);

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay and show the animation
    Future.delayed(Duration(milliseconds: 500), () {
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
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Your laundry request has been submitted!")));
            });
          },
        ),
      ),
    );
  }
}

class PickupTimeSelector extends StatefulWidget {
  const PickupTimeSelector({Key? key}) : super(key: key);

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
      lastDate: DateTime.now().add(Duration(days: 365)),
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
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pickup Date:',
          style: TextStyle(fontSize: 16),
        ),
        TextButton(
          onPressed: () => _selectDate(context),
          child: Text(
            DateFormat('yMMMd').format(selectedDate),
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Pickup Time:',
          style: TextStyle(fontSize: 16),
        ),
        TextButton(
          onPressed: () => _selectTime(context),
          child: Text(
            selectedTime.format(context),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Navigator.pop(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'),
      ),
      body: Text('lakal'),
    );
  }
}









