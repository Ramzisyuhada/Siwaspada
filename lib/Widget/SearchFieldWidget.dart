import 'package:flutter/material.dart';

class Searchfieldwidget extends FormField<String> {
  Searchfieldwidget({
    super.key,
    String? initialValue,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    String hintText = 'Cari...',
  }) : super(
          initialValue: initialValue,
          validator: validator,
          builder: (FormFieldState<String> field) {
            return SizedBox(
              width: double.infinity, // ⬅️ FULL WIDTH (TENGAH HORIZONTAL)
              child: TextField(
                onChanged: (value) {
                  field.didChange(value);
                  if (onChanged != null) {
                    onChanged(value);
                  }
                },
                decoration: InputDecoration(
                  hintText: hintText,
                  prefixIcon: const Icon(Icons.search),

                  // BACKGROUND
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),

                  // BORDER NORMAL
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.black, // warna normal
                      width: 1,
                    ),
                  ),

                  // BORDER SAAT FOCUS
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color(0xff1AA4BC), // warna aktif
                      width: 2,
                    ),
                  ),

                  // BORDER ERROR
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.5,
                    ),
                  ),

                  // BORDER ERROR + FOCUS
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 2,
                    ),
                  ),

                  errorText: field.errorText,
                ),
              ),
            );
          },
        );
}
