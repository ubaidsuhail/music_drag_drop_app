import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:music_application/youtube_api/youtube_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as ye;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:nice_button/nice_button.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_application/Screens/home.dart';

class DownloadYoutubeVideos extends StatelessWidget {
  String videoId;
  YoutubePlayerController _controller;
  YT_API _yi_api;
  var dir;
  List directoryDownloadedFilesList = List();
  var manifest;
  var videoWithoutAudio;
  Stream<List<int>> bytes;
  String downloadFilePath = "";
  File writeFile;
  int sum=0;
  ProgressDialog pr;

  DownloadYoutubeVideos(YT_API api, BuildContext context) {
    //onTap(api, context);
    _yi_api = api;
    _controller = YoutubePlayerController(
      initialVideoId: api.id,
    );

    pr = ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(
      message: 'Downloading file...',
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
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Home()));
        }),
        title: Text(
          'Youtube',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent[700],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              YoutubePlayer(
                controller: _controller,
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _yi_api.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Divider(
                height: 5.0,
                color: Colors.grey,
              ),
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  SizedBox(width: 10.0),
                  Icon(
                    Icons.account_circle,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    _yi_api.channelTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Divider(
                height: 5.0,
                color: Colors.grey,
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Description: ${_yi_api.description}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),


              Container(
                padding: EdgeInsets.only(top:20.0),
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                  child: NiceButton(
                    radius: 25,
                    elevation: 0.0,
                    text: "Download",
                    icon: Icons.file_download,
                    gradientColors: [Color(0xffff5252), Color(0xffef9a9a)],

                    onPressed: () {
                      DownloadYoutubeVideo(context);
                    },
                  )
              ),


            ],
          ),
        ),
      ),
    ),
    onWillPop: (){
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home()));
    },
    );
  }


  void DownloadYoutubeVideo(BuildContext context) async
  {
    //This will pause the video
    _controller.pause();

    //This will show Alert Dialog
    await pr.show();

//    showDialog(
//        context: context,
//        builder: (context) {
//          return Center(
//              child:Container(
//                margin: EdgeInsets.only(left: 50.0),
//                child:Text("Downloading ...",style: TextStyle(color: Colors.black,fontSize: 28.0,decoration: TextDecoration.none),),
//              ));
//        });


    var youtubeVideo = ye.YoutubeExplode();

    //This will get the directory
    dir=await getExternalStorageDirectory();


    //This will get the list of downloaded files
    directoryDownloadedFilesList = Directory("${dir.path}/musicappdj/").listSync();
    print("Downloaded files list ${directoryDownloadedFilesList} and length is: ${directoryDownloadedFilesList.length}");

    //This will get the manifest stream for audio,video,muxed
   manifest= await youtubeVideo.videos.streamsClient.getManifest(_yi_api.id);

    //This will get the list of video without audio
    videoWithoutAudio = manifest.videoOnly;
    print("video without audio ${videoWithoutAudio.toList()}");

    //This will convert manifest stream to streams
    bytes =  youtubeVideo.videos.streamsClient.get(videoWithoutAudio.toList()[0]);

    //Path where to download file
    downloadFilePath=dir.path+"/musicappdj"+"/Vi${directoryDownloadedFilesList.length + 1}" + _yi_api.title + ".mp4";


   // Assign path to write file object in which file is written
    writeFile = File(downloadFilePath);

    bytes.asBroadcastStream().listen((List<int> event) {
      writeFile.writeAsBytesSync(event,mode:FileMode.append);
      sum=sum+event.length;
      print("sum is: "+sum.toString());
    },
        onDone : (){
          print("Downloading Complete");
          Navigator.of(context, rootNavigator: true).pop();
          Fluttertoast.showToast(
              msg: "Downloading Complete",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blue[300],
              textColor: Colors.white,
              fontSize: 16.0
          );
          //Navigator.pop(context);
        }
    );

  }



}