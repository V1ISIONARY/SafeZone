import 'package:flutter/material.dart';
import 'package:safezone/resources/schema/colors.dart';

class TextFieldWidget {
  static Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    int minLines = 1,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        minLines: minLines,
        decoration: InputDecoration(
          filled: true,
          fillColor: formFieldColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide.none,
          ),
          labelStyle: const TextStyle(
              color: labelFormFieldColor, height: 1.3, fontSize: 15),
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          contentPadding: contentPadding,
        ),
        validator: validator,
      ),
    );
  }
}
