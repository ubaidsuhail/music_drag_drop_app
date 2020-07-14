import 'package:flutter/material.dart';
import 'package:music_application/Screens/home.dart';
import 'package:video_player/video_player.dart';
import 'package:music_application/chewie_plugin/chewie_list_item.dart';
import 'dart:io';
import 'package:share/share.dart';
import 'package:share_extend/share_extend.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as pt;
import 'dart:io';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';



class VideoPlay extends StatefulWidget {
  String videopath;
  int shareoption = 0;

  VideoPlay({this.videopath,this.shareoption});

  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  VideoPlayerController _controller;
  List<int> filterColor = [0xFFFAEBD7,0xFF00FFFF,0xFF7FFFD4,0xFFFFE4C4,0xFF8A2BE2,0xFF5F9EA0,0xFFD2691E,0xFF00FFFF,0xFFA9A9A9,0xFFBDB76B,0xFF696969,0xFFF0FFF0,0xFFBC8F8F,0xFFD8BFD8,0xFFFF4500,0xFFFFA500];
  List<String> filterColorName = ["AntiqueWhite","Aqua","Aquamarine","Bisque","BlueViolet","CadetBlue","Chocolate","Cyan","DarkGray","DarkKhaki","DimGray","HoneyDew","RosyBrown","Thistle","OrangeRed","Orange"];
  List<int> applyFilterColor = [0xFAEBD7,0x00FFFF,0x7FFFD4,0xFFE4C4,0x8A2BE2,0x5F9EA0,0xD2691E,0x00FFFF,0xA9A9A9,0xBDB76B,0x696969,0xF0FFF0,0xBC8F8F,0xD8BFD8,0xFF4500,0xFFA500];

  List applyColor= [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

 int applyVideoColor = 0;
 int videoWidth = 0;
 int videoHeight = 0;
 Map<dynamic,dynamic> videoPathInfo;

  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  final FlutterFFprobe _flutterFFprob = new FlutterFFprobe();

  String applyVideoColorCommand;
  String videoOuputPath = "";

  Directory dir;
  List directorySavedFilesList = [];

  ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videopath));

    pr = ProgressDialog(context,type: ProgressDialogType.Normal);
    pr.style(
      message: 'Filter Apply...',
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
        backgroundColor:  widget.shareoption == 1 ? Colors.white :Colors.brown[200],
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

        title:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Video Player"),
            widget.shareoption == 1 ?
            GestureDetector(
              onTap: (){
                ShareVideo();
              },

              child: Text("Share"),
            )
                :
            Text(""),
          ],
        ),

      ),

        body: SingleChildScrollView(
          child: widget.shareoption == 1 ?
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height*0.85,
            child:Column(
              children: <Widget>[

                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height *0.5,
                child:ChewieListItem(
                    videoPlayerController: _controller
                )),

                SizedBox(
                  height: 30.0,
                ),
                Container(
                  //margin: EdgeInsets.only(right: 10.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height *0.28,
                    //color:Colors.pink,

                  child: Column(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width*0.6,
                          height: MediaQuery.of(context).size.height*0.06,
                          margin: EdgeInsets.only(bottom: 15.0),

                          child:RaisedButton(
                            color: Colors.lightBlue[200],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),

                            onPressed: (){
                              ApplyFilter();
                            },
                            child:Text("Apply Filter"),

                          )
                      ),


                      Container(
                        margin: EdgeInsets.only(left: 3.0,right: 3.0),
                        height:MediaQuery.of(context).size.height *0.18,
                        width: MediaQuery.of(context).size.width,
                        //color:Colors.green,

                          child:ListView.builder(
                            scrollDirection: Axis.horizontal,
                              itemCount: filterColorName.length,
                              itemBuilder: (BuildContext context , int index){
                                return GestureDetector(
                                 onTap: (){
                                  applyVideoColor = applyFilterColor[index];

                                  print("Filter colors:${Color(applyVideoColor)}");

                                  applyColor= [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

                                  setState(() {
                                    applyColor[index] = 1;
                                  });


                                 },
                                 child:Column(
                                  children: <Widget>[
                                     Container(
                                       decoration: BoxDecoration(
                                         border: Border(
                                           top: BorderSide(width: applyColor[index] == 1 ? 3.0 : 2.0, color: applyColor[index] == 1 ? Colors.red : Colors.black26),
                                           left: BorderSide(width: applyColor[index] == 1 ? 3.0 : 2.0, color: applyColor[index] == 1 ? Colors.red : Colors.black26),
                                           right:BorderSide(width: applyColor[index] == 1 ? 3.0 : 2.0, color: applyColor[index] == 1 ? Colors.red : Colors.black26),
                                         ),
                                         color: Color(filterColor[index]),
                                       ),
                                       margin: EdgeInsets.only(left: 2.0,right: 2.0),
                                       height:MediaQuery.of(context).size.height *0.13,
                                       width: MediaQuery.of(context).size.width *0.25,

                                     ),

                                    Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            //top: BorderSide(width: applyColor[index] == 1 ? 3.0 : 2.0, color: Colors.transparent),
                                            left: BorderSide(width: applyColor[index] == 1 ? 3.0 : 2.0, color: applyColor[index] == 1 ? Colors.red : Colors.black26),
                                            right:BorderSide(width: applyColor[index] == 1 ? 3.0 : 2.0, color: applyColor[index] == 1 ? Colors.red : Colors.black26),
                                            bottom:BorderSide(width: applyColor[index] == 1 ? 3.0 : 2.0, color: applyColor[index] == 1 ? Colors.red : Colors.black26),
                                          ),
                                          color: Colors.black,
                                        ),

                                        margin: EdgeInsets.only(left: 2.0,right: 2.0),
                                      height:MediaQuery.of(context).size.height *0.04,
                                      width: MediaQuery.of(context).size.width *0.25,
                                      child:Text(filterColorName[index],style: TextStyle(color: Colors.white,fontSize: 12.0),textAlign: TextAlign.center,)
                                    ),
                                  ],
                                ));
                              }

                          )

                      )



                    ],
                  ),


                ),
              ],
            ),
          )


              :
          Container(
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
        )
        ),

    ),
      onWillPop: (){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Home()));
      },
    );
  }


  void ShareVideo()
  {
    _controller.pause();
    print("Share Video");

    final RenderBox box = context.findRenderObject();
    //It shre text,videos
//    Share.share(widget.videopath,
//        subject: "why",
//        sharePositionOrigin:
//        box.localToGlobal(Offset.zero) &
//        box.size);

    //It share videos
   ShareExtend.share(widget.videopath, "Music App");
  }


  void ApplyFilter() async
  {

    if(applyVideoColor != 0)
      {

        //This will pass the video
        _controller.pause();

        //This will show Alert Dialog
        await pr.show();


        //Get information of Video path
        videoPathInfo = await _flutterFFprob.getMediaInformation(widget.videopath);

        print("Video information is:${videoPathInfo}");


        //Width of video
        int width = videoPathInfo["streams"][0]["width"];
        print("width is:${width}");

        //Height of video
        int height = videoPathInfo["streams"][0]["height"];
        print("height is:${height}");


        //Now convert int Color to color Object

        applyVideoColorCommand = Color(applyVideoColor).toString().substring(6,8)+Color(applyVideoColor).toString().substring(10,16);
        print("Color Command:"+applyVideoColorCommand);


        //This will get the directory
        dir=await getExternalStorageDirectory();

        //This will get the list of downloaded files
        directorySavedFilesList = Directory("${dir.path}/savefinalvideos/").listSync();
        print("Downloaded files list ${directorySavedFilesList} and length is: ${directorySavedFilesList.length}");


        videoOuputPath = dir.path+"/savefinalvideos/"+"FIV"+"${directorySavedFilesList.length + 1}_"+pt.basename(widget.videopath);




        //Now Add Color Filter
        _flutterFFmpeg.execute("-i ${widget.videopath} -f lavfi -i 'color=$applyVideoColorCommand:s=${width}x${height}' -filter_complex 'blend=shortest=1:all_mode=overlay' ${videoOuputPath}").then((rc)
        {
          print("FFmpeg process exited with rc $rc");

         //If command execute
          if(rc == 0)
            {

              //Delete the current input file
              File(widget.videopath).deleteSync();

              //Close Dialog Box
              Navigator.of(context, rootNavigator: true).pop();

              Fluttertoast.showToast(
                  msg: "Filter Applied",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blue[300],
                  textColor: Colors.white,
                  fontSize: 16.0
              );

              //Now refresh the page
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => VideoPlay(videopath:videoOuputPath,shareoption:1)));

            }

            //If now heightxwidth
          else if(rc ==1)
            {
              _flutterFFmpeg.execute("-i ${widget.videopath} -f lavfi -i 'color=$applyVideoColorCommand:s=${height}x${width}' -filter_complex 'blend=shortest=1:all_mode=overlay' ${videoOuputPath}").then((rc)
              {
                print("FFmpeg process exited with rc in second command $rc");

                //If command execute
                if(rc == 0)
                {

                  //Delete the current input file
                  File(widget.videopath).deleteSync();

                  //Close Dialog Box
                  Navigator.of(context, rootNavigator: true).pop();

                  Fluttertoast.showToast(
                      msg: "Filter Applied",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue[300],
                      textColor: Colors.white,
                      fontSize: 16.0
                  );

                  //Now refresh the page
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => VideoPlay(videopath:videoOuputPath,shareoption:1)));

                }

                else if(rc == 1)
                  {
                    //Delete the current input file
                    File(videoOuputPath).deleteSync();
                    //Close Dialog Box
                    Navigator.of(context, rootNavigator: true).pop();

                    Fluttertoast.showToast(
                        msg: "Error:Filter can not be applied on this video",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blue[300],
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }


              }
              );
            }







        }
        );




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
                content: Text("You have to select filter"),
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

}
