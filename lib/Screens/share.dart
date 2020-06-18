import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:music_application/widgets/sharewidget.dart';
import 'package:share_extend/share_extend.dart';
import '../theme.dart';

class Share extends StatefulWidget {
  @override
  _ShareState createState() => _ShareState();
}

class _ShareState extends State<Share> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 35,
          ),
          color: theme.primaryColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
              child: Stack(children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height - 100,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: AssetImage("assets/background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/logo.png",
                        height: 100,
                      ),
                      Spacer(),
                      Align(
                        child: Image.asset(
                          "assets/video.png",
                          height: 200,
                          width: 300,
                        ),
                        alignment: Alignment.center,
                      ),
                      RaisedButton(
                        child: Text(
                          "Share",
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        onPressed: () async {
//                          File f = await ImagePicker.pickVideo(
//                              source: ImageSource.gallery);
//                          if (f != null) {
//                            ShareExtend.share(f.path, "video");
//                          }
                        },
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                    ])
              ]),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height - 20,
              )),
        ),
      ),
    );
  }
}
