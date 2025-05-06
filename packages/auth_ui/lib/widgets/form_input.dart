import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final IconData? icon;

  const FormInput({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: Colors.teal[400]) : null,
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: Colors.teal[700],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.teal[50],
        ),
      ),
    );
  }
}
