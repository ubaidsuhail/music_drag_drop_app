import 'package:flutter/material.dart';
import 'package:music_application/staticclasses/staticdata.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_application/Screens/home.dart';
import '../theme.dart';

class VideoMix extends StatefulWidget {
  @override
  _VideoMixState createState() => _VideoMixState();
}

class _VideoMixState extends State<VideoMix> {

  Directory dir;
  String convertPath = "";
  FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  int rc;
  File tempFile;
  List mixedVideosList = List();
  String mixedVideoOuputPath = "";
  Directory deleteDir;
  final _flutterVideoCompress = FlutterVideoCompress();
  ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    MixTempDir();
    pr = ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: false);
    pr.style(
      message: 'Mixing Video...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child:Scaffold(
        backgroundColor:Colors.pink[100] ,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: ()
          {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => Home()));
          },
          child: Icon(Icons.arrow_back),
        ),

        title:Text("Mixing of Multiple Videos"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.85,
          color: Colors.pink[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

          Container(
          margin: EdgeInsets.only(left: 10.0,right: 10.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.3,
          child:ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: StaticData.mixVideoList.length,
              itemBuilder: (BuildContext context , int index){
                return GestureDetector(
                    onTap: ()
                    {

                    },
                    child:Column(
                      children: <Widget>[
                        Container(
                            width:MediaQuery.of(context).size.width*0.4,
                            height: MediaQuery.of(context).size.height*0.25,
                            margin: EdgeInsets.only(left: 3.0,right: 3.0,top: 4.0),
                            child: Stack(
                              children: <Widget>[
                            Image.memory(
                              StaticData.mixVideoList[index]["videoimage"],
                              height: MediaQuery.of(context).size.height*0.25,
                              width: MediaQuery.of(context).size.width*0.4,
                              fit: BoxFit.fill,
                            ),

                              Positioned(
                                left: MediaQuery.of(context).size.width*0.32,
                                child:GestureDetector(
                                  onTap: (){
                                    RemoveMixVideo(index);
                                  },
                                  child: Icon(Icons.cancel,size: 28.0),
                                )
                              )

                              ],
                            ),
                        ),
//
                      ],
                    )
                );
              }
          ),
          ),

        Container(
          width: MediaQuery.of(context).size.width*0.5,
          height: MediaQuery.of(context).size.height/15,
         child: RaisedButton(
           elevation: 0.0,
           color: Colors.lightBlue[200],
           shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(20)
           ),
            onPressed: (){
              MixVideos();
            },

            child: Text("Mix Videos"),
          )),

            ],



          ),
        ),
      ),
    ),
    onWillPop: (){
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => Home()));
    },
    );
  }




  void MixTempDir() async {
    //This will get a directory path
    var dir=await getExternalStorageDirectory();


    //Check if Directory exists
    if(await Directory(dir.path+"/tempvideos").exists())
    {
      print("Temporary Directory exists");
    }
    else
    {
      //This function creates a directory
      var createDirectory =  await Directory(dir.path+"/tempvideos").create();
      print("Newly create downloaded directory is:"+createDirectory.path);
    }

    tempFile = File('${dir.path}/tempvideos/tempfile.txt');

  }



  void MixVideos() async
  {

    //Agar ek sa ziyada videos hoto mix ho
    if(StaticData.mixVideoList.length > 1)
      {

    //This will show Alert Dialog

    await pr.show();

    //This will get the directory
    dir=await getExternalStorageDirectory();


    //This will convert .mp4 files to .ts files
    for(int i=0; i<StaticData.mixVideoList.length; i++)
      {
       convertPath = dir.path+"/tempvideos" + "/tempvideo${i}.ts";

     rc = await _flutterFFmpeg.execute("-i ${StaticData.mixVideoList[i]["videopath"]} -c copy ${convertPath}");

     print("FFmpeg process exited with rc $rc");

     if(rc == 0)
       {
         //This will write .ts videos path in file
         await tempFile.writeAsString("file '$convertPath'\n",mode: FileMode.append);
       }

       //If there is any error in conversion
      else
        {
          deleteDir = Directory(dir.path+"/tempvideos");
          deleteDir.deleteSync(recursive: true);
          break;
        }



      }




      //Agar temp videos ka folder ho to hi mixing hogi
    if(await Directory(dir.path+"/tempvideos").exists())
    {
      //Now the process of Mixing of Videos

    //This will get the list of Mixed Videos
    mixedVideosList = Directory("${dir.path}/mixvideos/").listSync();
    print("mixed videos List ${mixedVideosList} and length is: ${mixedVideosList.length}");


    //Now the path where we want to save mixed video
    mixedVideoOuputPath = dir.path+"/mixvideos/MX_Music"+"${mixedVideosList.length + 1}.mp4";


    //Now Mixed the video

    _flutterFFmpeg.execute("-f concat -safe 0 -i ${tempFile.path} -c copy ${mixedVideoOuputPath}").then((rc){

      print("Videos mixed");

      deleteDir = Directory(dir.path+"/tempvideos");
      deleteDir.deleteSync(recursive: true);

      if(rc == 0)
        {
          //edit video in drag drop list
          EditDragDropList(mixedVideoOuputPath);


        }

       else
         {
           File(mixedVideoOuputPath).deleteSync();
           Navigator.of(context, rootNavigator: true).pop();
           Fluttertoast.showToast(
               msg: "Error in Mixing Videos",
               toastLength: Toast.LENGTH_SHORT,
               gravity: ToastGravity.BOTTOM,
               timeInSecForIosWeb: 1,
               backgroundColor: Colors.blue[300],
               textColor: Colors.white,
               fontSize: 16.0
           );

           Navigator.pop(context);
           Navigator.push(context, MaterialPageRoute(
               builder: (context) => Home()));
         }





    });

    }

    else
      {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(
            msg: "Error in Mixing Videos",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue[300],
            textColor: Colors.white,
            fontSize: 16.0
        );

        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Home()));
      }


      }

     else
       {
         showDialog(
             context: context,
             builder: (context) {
               return AlertDialog(
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                 title: Text(
                   "OOPS!",
                 ),
                 content: Text("For Mixing,You should have to add atleast two videos"),
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



  }


  //This will edit the list and show path and thumbnail of current Mixed value
  void EditDragDropList(String outputPath) async
  {

    final videoImageThumbnail = await _flutterVideoCompress.getThumbnail(
      outputPath,
      quality: 80,
      position: -1,
    );

    print("Edit drag drop path${videoImageThumbnail}");

    //This will add mixed video output path and output thumbnail
    StaticData.dragDropVideoList.add({"videoimage":videoImageThumbnail,"videopath":outputPath});

    Navigator.of(context, rootNavigator: true).pop();
    Fluttertoast.showToast(
        msg: "Videos Mixed Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue[300],
        textColor: Colors.white,
        fontSize: 16.0
    );

    //Now Empty the mix video list
    StaticData.mixVideoList = [];
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Home()));

  }


  //Remove Mix Video

  void RemoveMixVideo(int videoindex)
  {

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            title: Text(
              "Alert",
            ),
            content: Text("Do you want to remove video?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  StaticData.mixVideoList.removeAt(videoindex);
                 setState(() {
                   StaticData.mixVideoList;
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


}
