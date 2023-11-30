import 'package:believer/controller/my_app.dart';
import 'package:flutter/material.dart';

class EditText extends StatefulWidget {
  const EditText(
      {super.key,
      required this.function,
      required this.controller,
      required this.validator,
      required this.hint,
      this.secure = false,
      this.number = false,
      required this.title});
  final String title;
  final bool number;
  final String hint;
  final Function function;
  final bool secure;
  final String? Function(String?)? validator;
  final TextEditingController controller;

  @override
  State<EditText> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  bool showPass = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Text(
            widget.title,
          ),
        ),
        TextFormField(
            keyboardType: widget.number ? TextInputType.number : null,
            obscureText: !showPass && widget.secure,
            cursorColor: primaryColor,
            onFieldSubmitted: (value) => widget.function(),
            decoration: InputDecoration(
                hintText: widget.hint,
                suffixIcon: widget.secure
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            showPass = !showPass;
                          });
                        },
                        icon: Icon(
                          showPass ? Icons.visibility : Icons.visibility_off,
                          color: primaryColor,
                        ))
                    : null,
                fillColor: Colors.grey.shade300,
                filled: true,
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15)),
            controller: widget.controller,
            validator: widget.validator),
      ],
    );
  }
}
