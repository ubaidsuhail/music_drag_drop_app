import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:nice_button/nice_button.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_application/Screens/home.dart';
import 'package:music_application/chewie_plugin/chewie_list_item.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class DownloadTikTokVideos extends StatelessWidget {
  VideoPlayerController _controller;
  var dir;
  List directoryDownloadedFilesList = List();
  ProgressDialog pr;
  String tikTokDescription , tikTokNickName , tikTokVideoUrl ;
  String downloadFilePath = "";
  final FlutterFFmpeg _flutterFFmpegRemoveAudio = new FlutterFFmpeg();


  DownloadTikTokVideos(String description, String nickname , String videourl, BuildContext context) {

    tikTokDescription = description;
    tikTokNickName = nickname;
    tikTokVideoUrl = videourl;

    _controller = VideoPlayerController.network(tikTokVideoUrl);

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
            'Tiktok',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(0xFF, 0x69, 0xC9, 0xD0),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
          color: Colors.grey[100],
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height*0.5,
                  child:ChewieListItem(
                      videoPlayerController: _controller
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  children: <Widget>[
                    SizedBox(width: 10.0),
                    Icon(
                      Icons.account_circle,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      tikTokNickName,
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
                   tikTokDescription == "" ? 'Description: Tik Tok Video' : 'Description: ${tikTokDescription}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),


                Container(
                    padding: EdgeInsets.only(top:20.0,bottom: 5.0),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: NiceButton(
                      radius: 25,
                      elevation: 0.0,
                      text: "Download",
                      icon: Icons.file_download,
                      gradientColors: [Color(0xffff5252), Color(0xffef9a9a)],

                      onPressed: () {
                        DownloadTikTokVideo(context);
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


  void DownloadTikTokVideo(BuildContext context) async
  {

    //This will pause the video
    _controller.pause();

    //This will show Alert Dialog
    await pr.show();

    //This will get the directory
    dir=await getExternalStorageDirectory();

    //This will get the list of downloaded files
    directoryDownloadedFilesList = Directory("${dir.path}/musicappdj/").listSync();
    print("Downloaded files list ${directoryDownloadedFilesList} and length is: ${directoryDownloadedFilesList.length}");

    downloadFilePath = dir.path+"/musicappdj"+"/Vi${directoryDownloadedFilesList.length + 1}" + "tik_tok_video" + ".mp4";


    //By using ffmpeg download video without audio for tiktok or remove audio from video for tiktok

    _flutterFFmpegRemoveAudio.execute("-i ${tikTokVideoUrl} -c copy -an ${downloadFilePath}").then((rc){
      print("FFmpeg process exited with rc $rc");
      if(rc == 0)
      {
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
      }

      else
      {
        Navigator.of(context, rootNavigator: true).pop();

        Fluttertoast.showToast(
            msg: "Error in Downloading",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue[300],
            textColor: Colors.white,
            fontSize: 16.0
        );
      }


    });


  }



}