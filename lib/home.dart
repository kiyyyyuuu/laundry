import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart" show DateFormat;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:badges/badges.dart' as badges; // Alias the badges package
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _validateAndSignIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter both email and password."),
          backgroundColor: Colors.grey[700],
        ),
      );
    } else {
      try {
        // Sign in with Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        if (userCredential.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyStatelessApp()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message = "Sign-in failed. Please try again.";
        if (e.code == 'user-not-found') {
          message = "No user found with this email.";
        } else if (e.code == 'wrong-password') {
          message = "Incorrect password.";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.redAccent,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("An error occurred. Please try again later."),
            backgroundColor: Colors.grey[700],
          ),
        );
      }
    }
  }

  void _signInAsAdmin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminPage()), // Ensure AdminPage is defined
    );
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
            const Text(
              'Welcome Back!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'Sign in to your account',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 20),
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
            ElevatedButton(
              onPressed: _validateAndSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 15),
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
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _signInAsAdmin,
              child: Center(
                child: Text(
                  'Sign in as Admin',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to handle admin login
  Future<void> _loginAsAdmin() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter both username and password."),
          backgroundColor: Colors.grey[700],
        ),
      );
      return;
    }

    try {
      // Fetch admin credentials from Firestore
      DocumentSnapshot adminDoc = await FirebaseFirestore.instance
          .collection('admins')
          .doc('admin1') // Replace with your actual admin document ID
          .get();

      if (adminDoc.exists) {
        String storedUsername = adminDoc.get('username');
        String storedPassword = adminDoc.get('password');

        // Validate the username and password
        if (username == storedUsername && password == storedPassword) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Admin()), // Replace with your admin dashboard widget
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Invalid username or password."),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Admin credentials not found."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: ${e.toString()}"),
          backgroundColor: Colors.grey[700],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome Back!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginAsAdmin,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Login as Admin',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Admin Page that we navigate to



class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Batches"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Number of buttons per row
            crossAxisSpacing: 10, // Horizontal space between buttons
            mainAxisSpacing: 10, // Vertical space between buttons
            childAspectRatio: 1.5, // Aspect ratio for button size
          ),
          itemCount: 23, // Total number of batches
          itemBuilder: (context, index) {
            return ElevatedButton(
              onPressed: () {
                // Navigate to the BatchDetailPage with the current batch number
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BatchDetailPage(batchNumber: index + 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Batch ${index + 1}",
                style: const TextStyle(fontSize: 16),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BatchDetailPage extends StatelessWidget {
  final int batchNumber;

  const BatchDetailPage({super.key, required this.batchNumber});

  // Mock function to generate up to 30 user infos for each batch
  List<Map<String, String>> generateUserInfo(int batchNumber) {
    List<Map<String, String>> userInfo = [];
    for (int i = 1; i <= 30; i++) {
      userInfo.add({
        "name": "User $i of Batch $batchNumber",
        "email": "user$i.batch$batchNumber@example.com",
      });
    }
    return userInfo;
  }

  @override
  Widget build(BuildContext context) {
    // Generate up to 30 users for the given batch
    final List<Map<String, String>> userInfo = generateUserInfo(batchNumber);

    return Scaffold(
      appBar: AppBar(
        title: Text("Batch $batchNumber Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: userInfo.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(userInfo[index]["name"] ?? ""),
              subtitle: Text(userInfo[index]["email"] ?? ""),
              leading: const Icon(Icons.person),
            );
          },
        ),
      ),
    );
  }
}






class SignUpPage extends StatelessWidget {
  // Controllers for the text fields
  final TextEditingController NameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController RoomNumberController = TextEditingController();
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Function to handle the sign-up process
  Future<void> _registerUser(BuildContext context) async {
    String name = NameController.text.trim();
    String phone = phoneNumberController.text.trim();
    String room = RoomNumberController.text.trim();
    String email = EmailController.text.trim();
    String password = PasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Check if any field is empty
    if (name.isEmpty || phone.isEmpty || room.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all the fields'),
      ));
      return;
    }

    // Check if the passwords match
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Passwords do not match'),
      ));
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'name': name,
        'phone': phone,
        'room': room,
        'email': email,
        'uid': user?.uid,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyStatelessApp()), // Replace with your home page
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sign-up failed: $e'),
      ));
    }
  }

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
            const Text(
              'Register',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Create a new account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: NameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                labelText: 'Name',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone),
                labelText: 'Phone Number',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: RoomNumberController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.home),
                labelText: 'Room Number',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: 'T2-810', // Example inside the box
                hintStyle: TextStyle(color: Colors.grey), // Faded text
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),


            TextField(
              controller: EmailController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                labelText: 'Email',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: '@woxsen.edu.in',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: PasswordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                labelText: 'Password',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                labelText: 'Confirm Password',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => _registerUser(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white30,
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
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
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
    "Shorts": 0,
    "Pants": 0,
    "Blankets": 0,

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
                      buildClothesInputWithImage("Shorts",
                          "https://i.pinimg.com/564x/75/cf/fd/75cffdfca25bc3d68cd33dc81cd7e733.jpg",
                          washAndFoldClothesQuantities),
                      buildClothesInputWithImage('Pants',
                          "https://i.pinimg.com/564x/2c/dd/b1/2cddb11fa2115f14492ae356fa775317.jpg",
                          washAndFoldClothesQuantities),
                      buildClothesInputWithImage("Blankets",
                          "https://i.pinimg.com/564x/0d/80/7e/0d807e0f03223c324b4adcd7743f4c61.jpg",
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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roomNumberController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  // Method to select image from gallery
  void selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  // Method to fetch user data from Firestore
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          print("User data: ${userDoc.data()}");

          var userData = userDoc.data() as Map<String, dynamic>;

          // Populate text fields with user data
          setState(() {
            _nameController.text = userData['name'] ?? '';
            _emailController.text = userData['email'] ?? '';
            _roomNumberController.text = userData['room'] ?? '';
            _phoneNumberController.text = userData['phone'] ?? '';
          });
        } else {
          print("User document does not exist.");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  // Method to log out the user
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()), // Navigate to sign-in page
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();  // Fetch user data when the page is initialized
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20), // Space between AppBar and profile image
              Center(
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
              const SizedBox(height: 20), // Space between profile image and text fields

              // Name TextField
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 15), // Gap between text fields

              // Email TextField
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 15), // Gap between text fields

              // Room Number TextField
              TextField(
                controller: _roomNumberController,
                decoration: InputDecoration(
                  labelText: 'Room Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 15), // Gap between text fields

              // Phone Number TextField
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 30), // Gap before logout button

              // Logout Button
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70, // Set button color to red for logout
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
