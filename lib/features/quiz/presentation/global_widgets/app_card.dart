import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({required this.title, required this.onTap, super.key});

  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      surfaceTintColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      child: ListTile(
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        onTap: onTap,
      ),
    );
  }
}
