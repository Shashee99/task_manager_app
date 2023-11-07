import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ui/theme.dart';
class PasswordInput extends StatefulWidget {
  final String title;
  final TextEditingController? controller;
  final String hint;
  final Widget? widget; // Use `final` instead of `late`
  bool isPasswordVisible = false;

  PasswordInput({
    required this.title,
    this.controller,
    required this.hint,
    this.widget,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  @override
  Widget build(BuildContext context) {
    Widget? additionalWidget = widget.widget; // Use `widget` instead of `this.widget`

    return Container(
      margin: EdgeInsets.only(top: 3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: titleTextStle,
          ),
          Container(
            padding: EdgeInsets.only(left: 14.0),
            height: 52,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.0,
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    obscureText: !widget.isPasswordVisible,
                    autofocus: false,
                    cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
                    // readOnly: widget.widget is Container ? false : true,
                    controller: widget.controller,
                    style: subTitleTextStle,
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: subTitleTextStle,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.backgroundColor!,
                          width: 0,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.backgroundColor!,
                          width: 0,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.isPasswordVisible = !widget.isPasswordVisible;
                          });
                        },
                        child: Icon(
                          widget.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                if (additionalWidget != null) additionalWidget,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
