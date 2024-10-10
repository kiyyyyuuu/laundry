import 'package:flutter/material.dart';

class BasketPage extends StatefulWidget {
  final Map<String, int> washAndFoldClothes;
  final Map<String, int> specialWashClothes;
  final Map<String, bool> specialServices;
  final String additionalInstructions;
  final int Function() getTotalSelectedClothes;

  const BasketPage({
    Key? key,
    required this.washAndFoldClothes,
    required this.specialWashClothes,
    required this.specialServices,
    required this.additionalInstructions,
    required this.getTotalSelectedClothes,
  }) : super(key: key);

  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isSubmitting = false;

  // Function to pick date
  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(Duration(days: 30)),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  // Function to pick time
  Future<void> _pickTime() async {
    final TimeOfDay? time =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  // Function to handle submission
  void _submitOrder() async {
    if (widget.getTotalSelectedClothes() == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Your basket is empty.")),
      );
      return;
    }

    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select pickup/dropoff time.")),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    // Simulate a network request delay
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      isSubmitting = false;
    });

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text("Your laundry request has been submitted!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pop(context); // Go back to the main page
            },
            child: Text("OK"),
          ),
        ],
      ),
    );

    // Optionally, you can reset the selections here
    // Reset logic would need to be implemented in the main page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Basket"),
      ),
      body: isSubmitting
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Laundry Animation Placeholder
            // You can replace this with a Lottie animation or any other animation
            Icon(Icons.local_laundry_service, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text("Submitting your request...", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Clothes
            Text(
              "Selected Clothes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            // Wash and Fold Items
            if (widget.washAndFoldClothes.values.any((q) => q > 0))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Wash and Fold:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...widget.washAndFoldClothes.entries
                      .where((entry) => entry.value > 0)
                      .map((entry) => Text("- ${entry.key}: ${entry.value}"))
                      .toList(),
                ],
              ),
            SizedBox(height: 10),
            // Special Wash Items
            if (widget.specialWashClothes.values.any((q) => q > 0))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Special Wash:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...widget.specialWashClothes.entries
                      .where((entry) => entry.value > 0)
                      .map((entry) => Text("- ${entry.key}: ${entry.value}"))
                      .toList(),
                ],
              ),
            SizedBox(height: 10),
            // Selected Services
            if (widget.specialServices.values.any((s) => s))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selected Services:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...widget.specialServices.entries
                      .where((entry) => entry.value)
                      .map((entry) => Text("- ${entry.key}"))
                      .toList(),
                ],
              ),
            SizedBox(height: 10),
            // Additional Instructions
            if (widget.additionalInstructions.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Additional Instructions:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.additionalInstructions),
                ],
              ),
            SizedBox(height: 20),
            // Pickup/Dropoff Time Selection
            Text(
              "Select Pickup/Dropoff Time",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickDate,
                  icon: Icon(Icons.calendar_today),
                  label: Text(selectedDate == null
                      ? "Select Date"
                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                ),
                SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _pickTime,
                  icon: Icon(Icons.access_time),
                  label: Text(selectedTime == null
                      ? "Select Time"
                      : selectedTime!.format(context)),
                ),
              ],
            ),
            SizedBox(height: 30),
            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: _submitOrder,
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
    );
  }
}
