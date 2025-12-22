import 'package:flutter/material.dart';

class Costuminputfield extends FormField<String> {
  Costuminputfield({
    super.key,
    required String hintText,
    required IconData iconData,
    bool isPassword = false,
    bool comboBox = false,
    List<String>? items,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
  }) : super(
          validator: validator,
          builder: (FormFieldState<String> state) {
            bool obscureText = isPassword;

            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 351,
                    height: 59,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: state.hasError
                            ? Colors.red
                            : Colors.black.withOpacity(0.28),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(iconData, size: 29),
                        const SizedBox(width: 10),

                        Expanded(
                          child: comboBox
                              ? DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: state.value,
                                    hint: Text(
                                      hintText,
                                      style: const TextStyle(
                                        color: Color(0xff838181),
                                        fontSize: 18,
                                      ),
                                    ),
                                    isExpanded: true,
                                    items: items
                                        ?.map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      state.didChange(value);
                                      if (onChanged != null && value != null) {
                                        onChanged(value);
                                      }
                                    },
                                  ),
                                )
                              : TextField(
                                  obscureText: obscureText,
                                  onChanged: (value) {
                                    state.didChange(value);
                                    if (onChanged != null) {
                                      onChanged(value);
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: hintText,
                                    hintStyle: const TextStyle(
                                      color: Color(0xff838181),
                                      fontSize: 18,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                        ),

                        if (isPassword && !comboBox)
                          StatefulBuilder(
                            builder: (context, setEyeState) {
                              return IconButton(
                                icon: Icon(
                                  obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setEyeState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),

                  /// ERROR TEXT
                  if (state.hasError)
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 12, top: 4),
                      child: Text(
                        state.errorText!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
}
