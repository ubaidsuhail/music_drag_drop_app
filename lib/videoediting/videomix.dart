import 'package:flutter/material.dart';
import 'package:music_application/staticclasses/staticdata.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    MixTempDir();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mixing of Multiple Videos"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.85,
          color: Colors.white,
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
                            margin: EdgeInsets.only(left: 3.0,right: 3.0,top: 4.0),
                            child:Image.memory(
                              StaticData.mixVideoList[index]["videoimage"],
                              height: MediaQuery.of(context).size.height*0.25,
                              width: MediaQuery.of(context).size.width*0.4,
                              fit: BoxFit.fill,
                            )
                        ),
//
                      ],
                    )
                );
              }
          ),
          ),


          RaisedButton(
            onPressed: (){
              MixVideos();
            },

            child: Text("Mix Videos"),
          ),

            ],



          ),
        ),
      ),
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
   // print("Mix videos");

    //This will get the directory
    dir=await getExternalStorageDirectory();


    //This will convert .mp4 files to .ts files
    for(int i=0; i<StaticData.mixVideoList.length; i++)
      {
       convertPath = dir.path+"/tempvideos" + "/tempvideo${i}.ts";

     rc = await _flutterFFmpeg.execute("-i ${StaticData.mixVideoList[i]["videopath"]} -c copy ${convertPath}");

     print("FFmpeg process exited with rc $rc");

     //This will write .ts videos path in file
     await tempFile.writeAsString("file '$convertPath'\n",mode: FileMode.append);

      }



      //Now the process of Mixing of Videos

    //This will get the list of Mixed Videos
    mixedVideosList = Directory("${dir.path}/mixvideos/").listSync();
    print("mixed videos List ${mixedVideosList} and length is: ${mixedVideosList.length}");


    //Now the path where we want to save mixed video
    mixedVideoOuputPath = dir.path+"/mixvideos/MX_Music"+"${mixedVideosList.length + 1}.mp4";


    //Now Mixed the video

    _flutterFFmpeg.execute("-f concat -safe 0 -i ${tempFile.path} ${mixedVideoOuputPath}").then((rc){
      print("FFmpeg process exited with rc $rc");
      print("Videos mixed");

      deleteDir = Directory(dir.path+"/tempvideos");
      deleteDir.deleteSync(recursive: true);





    });





  }

}
