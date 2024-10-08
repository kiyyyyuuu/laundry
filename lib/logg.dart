import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var time = DateTime.now();
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blue[900],
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: SafeArea(
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HI NISCHAL !',
                        style: TextStyle(color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(' ${DateFormat('yMMMMd').format(time)}',style: TextStyle(color: Colors.blue[200]),)
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.account_circle_rounded,
                      color: Colors.white,
                      size: 30,),
                  )


                ],
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}