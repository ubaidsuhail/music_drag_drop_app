import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class MusicTextFormField extends StatefulWidget {
  final TextInputType keyboardType;
  final TextEditingController controller;
  final AssetImage icon;
  final String hintText;
  final Function validatorFunction;

  final bool isPassField;
  bool isPasswordVisible;

  MusicTextFormField(
      {this.controller,
      this.icon,
      this.hintText,
      this.validatorFunction,
      this.keyboardType,
      @required this.isPassField,
      this.isPasswordVisible});
  @override
  _MusicTextFormFieldState createState() => _MusicTextFormFieldState();
}

class _MusicTextFormFieldState extends State<MusicTextFormField> {
  bool passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassField ? !(widget.isPasswordVisible) : false,
      cursorColor: theme.primaryColor,
      controller: widget.controller,
      validator: widget.validatorFunction,
      decoration: InputDecoration(
        errorStyle: GoogleFonts.roboto(color: theme.accentColor),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        hintText: widget.hintText,
        hintStyle: GoogleFonts.roboto(
          fontSize: 13,
          color: theme.primaryColor,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
            bottomLeft: Radius.circular(50.0),
            topLeft: Radius.circular(50.0),
          ),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
            bottomLeft: Radius.circular(50.0),
            topLeft: Radius.circular(50.0),
          ),
        ),
        suffixIcon: widget.isPassField
            ? IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color:
                      widget.isPasswordVisible ? Colors.black87 : Colors.grey,
                ),
                onPressed: widget.isPassField
                    ? () {
                        setState(() {
                          widget.isPasswordVisible = !widget.isPasswordVisible;
                        });
                      }
                    : () {})
            : null,
      ),
    );
  }
}
