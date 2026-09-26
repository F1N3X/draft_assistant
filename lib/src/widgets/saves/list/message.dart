import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String text;

  const Message({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(text, textAlign: TextAlign.center),
    ),
  );
}