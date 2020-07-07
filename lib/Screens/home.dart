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
import 'package:music_application/staticclasses/staticdata.dart';
import 'package:music_application/videoediting/videotrim.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'dart:io';
import 'package:music_application/videoediting/videoplay.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:music_application/videoediting/videosync.dart';
import 'package:music_application/Screens/savevideos.dart';
import 'package:music_application/videoediting/videomix.dart';


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
            child: Icon(Icons.music_video,size: 50,),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SaveVideos()));
            },
          )
        ]),
      ),
      body: Stack(
          children: <Widget>[
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

        // ******** For Audio ******** //
        Padding(
          padding: const EdgeInsets.only(top: 95),
          child: Align(
            alignment: Alignment.center,
            child:Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 3,
                  child: Column(
                    children: <Widget>[

                      AutoSizeText(
                        "Drop Audio Here",
                        style: GoogleFonts.roboto(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: theme.accentColor,
                        ),
                      ),

                      GestureDetector(

                        onTap: (){
                          GetAudio();
                        },

                      child:
                      StaticData.audioFilePath == "" ?
                      Image(
                        image: AssetImage("assets/audio_icon.png"),
                        height: 100,
                        width: MediaQuery.of(context).size.width / 2,
                        color: Colors.white,
                      )
                          :
                        Container(
                          margin: EdgeInsets.only(left: 10.0,right:10.0),
                          height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.purple[200],),
                                borderRadius: BorderRadius.all(Radius.circular(14)),
                                color:Colors.brown,
                            ),
                         child:Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: <Widget>[
                             Text("Audio File",style: TextStyle(fontSize: 30.0),),
                             Padding(
                               //width: MediaQuery.of(context).size.width*0.1,

                               padding: EdgeInsets.only(left: 50.0),
                             child:GestureDetector(
                               onTap:(){
                                 RemoveAudio();
                               },
                             child:Icon(Icons.cancel,color: Colors.red,size: 35.0,)
                             ),
                             )
                           ],
                         )
                        )
                      )

                    ],
                  ),
                )
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

            ),
          ),

    // ******** For Video ******** //
       Container(
         margin: EdgeInsets.only(top: 10.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              //color:Colors.blue,
//              decoration: BoxDecoration(
//                // color: accepted.isEmpty ? caughtColor : theme.accentColor,
//              ),
              child: Column(
                children: <Widget>[
                  AutoSizeText(
                    "Drop Video Here",
                    style: GoogleFonts.roboto(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: theme.accentColor,
                    ),
                  ),


//                  Image(
//                    image: AssetImage("assets/video_icon.png"),
//                    color: Colors.white,
//                    height: 100,
//                    width: MediaQuery.of(context).size.width / 2,
//                  )

                   Expanded(
                   child:DragTarget(

                     onAccept: (Map<String,dynamic> videoData) {

                       StaticData.dragDropVideoList.add(videoData);
                       print("Drag Drop List ${ StaticData.dragDropVideoList}");

                      // print("Video image:${videoData["videoimage"]}");
                       //print("Video path:${videoData["videopath"]}");
                       print("Data accept");
                     },

                    builder: (
                    BuildContext context,
                    List<dynamic> accepted,
                    List<dynamic> rejected,
                    ) {
                      return Container(
                        margin: EdgeInsets.only(left: 10.0,right: 10.0,top: 5.0),
                        width: MediaQuery.of(context).size.width,
                        color: accepted.isEmpty ? theme.primaryColor : Colors.indigo[200],
                        child:StaticData.dragDropVideoList.length !=0 ?
                              //Agar dragdrop wali list ma data ha to kaam hoga
                        ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: StaticData.dragDropVideoList.length,
                              itemBuilder: (BuildContext context , int index){
                                return GestureDetector(
                                  onTap: ()
                                  {
                                  print("Tap Video Path is:${StaticData.dragDropVideoList[index]["videopath"]}");

                                  //TrimVideo(StaticData.dragDropVideoList[index]["videopath"],index);
                                    VideoAlert(StaticData.dragDropVideoList[index]["videopath"],index,StaticData.dragDropVideoList[index]["videoimage"]);
                                  },
                                    child:Column(
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(left: 3.0,right: 3.0,top: 4.0),
                                            child:Image.memory(
                                              StaticData.dragDropVideoList[index]["videoimage"],
                                              height: 130.0,
                                              width: 130.0,
                                              fit: BoxFit.fill,
                                            )
                                        ),
//
                                      ],
                                    )
                                );
                              }
                              )
                              :
                              Column(
                                children: <Widget>[
                                Image(
                                  image: AssetImage("assets/video_icon.png"),
                                  color: Colors.white,
                                  height: 130,
                                  width: MediaQuery.of(context).size.width / 2,
                                ),
                              ],),



                      );
                    }
                   ),
                   ),




                ],
              ),

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
       ),

        SlidingUpPanel(
          controller: controller,
          border: Border.all(color: theme.primaryColor),
          maxHeight: MediaQuery.of(context).size.height * 0.5,
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
          //backdropEnabled: true,
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


  void VideoAlert(String videoPath,int index,List videoImage)
  {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.45,bottom:MediaQuery.of(context).size.height*0.43,left: 6.0,right: 6.0),
              child:Container(
                width: double.maxFinite,
                color: Colors.grey[400],
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[

                          //For Play Video
                        Container(
                          padding: EdgeInsets.only(top:2.0),
                          margin: EdgeInsets.only(left: 15.0),
                          child:GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                                PlayVideo(videoPath);
                            },
                        child:SingleChildScrollView(
                        child:Column(
                            children: <Widget>[
                              Icon(Icons.play_arrow,size: 30.0,),
                              Text("Play",style: TextStyle(fontSize: 12.0,decoration: TextDecoration.none,color: Colors.black),),


                            ],
                            )
                            )
                          )
                        ),

                        //For Trim Video
                        Container(
                            padding: EdgeInsets.only(top:2.0),
                            margin: EdgeInsets.only(left: 25.0),
                            child:GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                  TrimVideo(videoPath,index);
                                },
                                child:SingleChildScrollView(
                                    child:Column(
                                      children: <Widget>[
                                        Icon(Icons.blur_off,size: 30.0,),
                                        Text("Trim",style: TextStyle(fontSize: 12.0,decoration: TextDecoration.none,color: Colors.black),),


                                      ],
                                    )
                                )
                            )
                        ),


                      //For Sync Video and Audio
                        Container(
                            padding: EdgeInsets.only(top:2.0),
                            margin: EdgeInsets.only(left: 25.0),
                            child:GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                  SyncVideo(videoPath);
                                },
                                child:SingleChildScrollView(
                                    child:Column(
                                      children: <Widget>[
                                        Icon(Icons.sync,size: 30.0,),
                                        Text("Sync",style: TextStyle(fontSize: 12.0,decoration: TextDecoration.none,color: Colors.black),),


                                      ],
                                    )
                                )
                            )
                        ),


                        //For Mix Video
                        Container(
                            padding: EdgeInsets.only(top:2.0),
                            margin: EdgeInsets.only(left: 25.0),
                            child:GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                  //SyncVideo(videoPath);
                                  MixVideo(videoPath,videoImage);
                                },
                                child:SingleChildScrollView(
                                    child:Column(
                                      children: <Widget>[
                                        Icon(Icons.cast,size: 30.0,),
                                        Text("Mix",style: TextStyle(fontSize: 12.0,decoration: TextDecoration.none,color: Colors.black),),


                                      ],
                                    )
                                )
                            )
                        ),






                  ],
                ),
              )
          );
        }
    );
  }




  //This method sent to video trim dart file
  void TrimVideo(String videoPath,int videoIndex) async
  {
    final Trimmer _trimmerObject = Trimmer();

    await _trimmerObject.loadVideo(videoFile: File(videoPath));

    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(
            builder: (context) => VideoTrim(trimmer:_trimmerObject , videopath:videoPath , videoindex:videoIndex)));


  }

  //This method send to Play Video dart file
  void PlayVideo(String videoPath)
  {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => VideoPlay(videopath:videoPath,shareoption:0)));
  }


  //This method will get audio with the help of file picker

  void GetAudio() async
  {
    try {
      StaticData.audioFilePath = await FilePicker.getFilePath(
          type: FileType.custom,allowedExtensions: ['mp3','aac']);

      print("Audio path ${StaticData.audioFilePath}");

      if(StaticData.audioFilePath == null)
        {
          StaticData.audioFilePath = "";
        }

      setState(() {
        StaticData.audioFilePath;
      });

    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  //This will remove the audio path
  void RemoveAudio()
  {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            title: Text(
              "Alert",
            ),
            content: Text("Do you want to remove Audio..."),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {

                  setState(() {
                    StaticData.audioFilePath = "";
                  });
                  Navigator.pop(context);
                  },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }


  //This will goes to Sync Audio Video File

  void SyncVideo(String videoPath)
  {
    if(StaticData.audioFilePath == "")
      {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                title: Text(
                  "OOPS!",
                ),
                content: Text("Please add an audio"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                ],
              );
            });
      }

      else
        {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => VideoSync(videopath:videoPath,audiopath:StaticData.audioFilePath)));
        }
  }


   void MixVideo(String videoPath , List videoImage)
   {
     StaticData.mixVideoList.add({"videopath":videoPath,"videoimage":videoImage});
     Navigator.push(context, MaterialPageRoute(
         builder: (context) => VideoMix()));

   }


}
