import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_application/Screens/share.dart';
import 'package:music_application/widgets/slidinguppanel.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../theme.dart';
import './login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Color caughtColor = Colors.grey;
  PanelController controller = PanelController();
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Container(
            child: Image.asset(
              "assets/logout.png",
              color: Colors.black,
            ),
            padding: EdgeInsets.all(7),
          ),
          onTap: () {
            logOut();
          },
        ),
        title: Row(children: <Widget>[
          Spacer(),
          Image.asset(
            "assets/logo.png",
            height: 60,
          ),
          Spacer(),
          InkWell(
            child: Image.asset(
              "assets/checkmark.png",
              color: theme.primaryColor,
              height: 40,
              width: 40,
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Share()));
            },
          )
        ]),
      ),
      body: Stack(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height - 150,
          color: theme.primaryColor,
        ),
        // Center(
        //   child: Padding(
        //     padding: const EdgeInsets.only(bottom: 200),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: <Widget>[
        //         Column(
        //           children: <Widget>[
        //             Image(
        //               image: AssetImage("assets/video_Icon.png"),
        //               color: Colors.white,
        //               height: 200,
        //               width: 200,
        //             ),
        //             AutoSizeText(
        //               "Drop Video Here",
        //               style: GoogleFonts.roboto(
        //                 fontSize: 30,
        //                 fontWeight: FontWeight.w500,
        //                 color: theme.accentColor,
        //               ),
        //             ),
        //           ],
        //         ),
        //         Column(
        //           children: <Widget>[
        //             Image(
        //               image: AssetImage("assets/audio_Icon.png"),
        //               height: 200,
        //               width: 200,
        //               color: Colors.white,
        //             ),
        //             AutoSizeText(
        //               "Drop Audio Here",
        //               style: GoogleFonts.roboto(
        //                 fontSize: 30,
        //                 fontWeight: FontWeight.w500,
        //                 color: theme.accentColor,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Align(
            alignment: Alignment.center,
            child: DragTarget(
              onAccept: (Color color) {
                // caughtColor = color;
              },
              builder: (
                BuildContext context,
                List<dynamic> accepted,
                List<dynamic> rejected,
              ) {
                return Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                    // color: accepted.isEmpty ? caughtColor : theme.primaryColor

                  ),
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage("assets/audio_Icon.png"),
                        height: 100,
                        width: MediaQuery.of(context).size.width / 2,
                        color: Colors.white,
                      ),
                      AutoSizeText(
                        "Drop Audio Here",
                        style: GoogleFonts.roboto(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: theme.accentColor,
                        ),
                      ),
                    ],
                  ),
                );
                // return Container(
                //   width: 200.0,
                //   height: 200.0,
                //   decoration: BoxDecoration(
                //     color: accepted.isEmpty ? caughtColor : Colors.grey.shade200,
                //   ),
                //   child: Center(
                //     child: Text("Drag Here!"),
                //   ),
                // );
              },
            ),
          ),
        ),

        DragTarget(
          onAccept: (Color color) {
            // caughtColor = color;
          },
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                // color: accepted.isEmpty ? caughtColor : theme.accentColor,
              ),
              child: Column(
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/video_Icon.png"),
                    color: Colors.white,
                    height: 100,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                  AutoSizeText(
                    "Drop Video Here",
                    style: GoogleFonts.roboto(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: theme.accentColor,
                    ),
                  ),
                ],
              ),
            );
            // return Container(
            //   width: 200.0,
            //   height: 200.0,
            //   decoration: BoxDecoration(
            //     color: accepted.isEmpty ? caughtColor : Colors.grey.shade200,
            //   ),
            //   child: Center(
            //     child: Text("Drag Here!"),
            //   ),
            // );
          },
        ),
        SlidingUpPanel(
          controller: controller,
          border: Border.all(color: theme.primaryColor),
          panel: Padding(
            child: SlidingUpPanelTabs(
              controller: controller,
            ),
            padding: EdgeInsets.only(top: 90),
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                40.0,
              ),
              topRight: Radius.circular(
                40.0,
              )),
          backdropEnabled: true,
          collapsed: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(
                  Icons.arrow_upward,
                  size: 35,
                ),
                AutoSizeText(
                  "Drag Me To Browse",
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                  ),
                )
              ]),
        ),
      ]),
    );
  }

  Future<void> logOut() async {
    try {
      _googleSignIn.signOut();
      await _auth.signOut().then((_) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      });
    } catch (e) {
      print("error logging out");
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error",
        desc: e.message,
        buttons: [
          DialogButton(
            child: Text("DISMISS",
                style: Theme.of(context).textTheme.title.copyWith(
                      color: Colors.white,
                    )),
            color: theme.accentColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ).show();
    }
  }
}