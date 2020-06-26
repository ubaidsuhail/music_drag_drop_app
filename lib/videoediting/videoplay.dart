import 'package:flutter/material.dart';
import 'package:music_application/Screens/home.dart';
import 'package:video_player/video_player.dart';
import 'package:music_application/chewie_plugin/chewie_list_item.dart';
import 'dart:io';

class VideoPlay extends StatefulWidget {
  String videopath;

  VideoPlay({this.videopath});

  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  VideoPlayerController _controller;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videopath));
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child:Scaffold(
        backgroundColor: Colors.brown[200],
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

        title:Text("Video Player"),
      ),

        body: SingleChildScrollView(
          child:Container(
            color: Colors.brown[200],
          height: MediaQuery.of(context).size.height*0.85,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ChewieListItem(
                  videoPlayerController: _controller
              ),
            ],
          ),
        )),

    ),
      onWillPop: (){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Home()));
      },
    );
  }
}
