import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
