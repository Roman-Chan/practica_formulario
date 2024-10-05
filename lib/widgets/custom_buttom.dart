import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final VoidCallback onPressed;
  const CustomButtom({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text('Enviar', style: TextStyle(fontSize: 20, color: Colors.white)),
    );
  }
}
