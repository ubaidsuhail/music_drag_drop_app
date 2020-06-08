import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShareWidget extends StatelessWidget {
  String imagePath;
  String text;
  Color color;
  double iconHeight;
  ShareWidget({this.imagePath, this.text, this.color, this.iconHeight});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 5,
          right: MediaQuery.of(context).size.width / 5,
        ),
        child: MaterialButton(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Padding(
            padding: EdgeInsets.only(right: 45.0, left: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image(
                  image: AssetImage(imagePath),
                  height: iconHeight,
                ),
                Text(
                  text,
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                  ),
                )
              ],
            ),
          ),
          onPressed: () {},
        ));
  }
}
