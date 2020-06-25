import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_trimmer/trim_editor.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:video_trimmer/video_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_trimmer/storage_dir.dart';
import 'package:path/path.dart' as pt;
import 'package:music_application/staticclasses/staticdata.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:music_application/Screens/home.dart';

class VideoTrim extends StatefulWidget {
  final Trimmer trimmer;
  String videopath;
  int videoindex;

  VideoTrim({this.trimmer,this.videopath,this.videoindex});

  @override
  _VideoTrimState createState() => _VideoTrimState();
}

class _VideoTrimState extends State<VideoTrim> {
  StorageDir storageDir;
  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;
  bool _progressVisibility = false;
  Directory dir;
  List trimVideoFiles = List();
  final _flutterVideoCompress = FlutterVideoCompress();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child:Scaffold(
        backgroundColor: Colors.black,
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

          title:Text("Video Trimmer"),
      ),
      body: Builder(
        builder: (context) =>SingleChildScrollView(
            child:Center(
          child: Container(
            height: MediaQuery.of(context).size.height*0.88,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: VideoViewer(),
                ),
                Center(
                  child: TrimEditor(
                    viewerHeight: 50.0,
                    viewerWidth: MediaQuery.of(context).size.width,
                    circlePaintColor: Colors.blue,
                    borderPaintColor: Colors.lightBlue[200],
                    scrubberPaintColor: Colors.red,
                    onChangeStart: (value) {
                      _startValue = value;
                    },
                    onChangeEnd: (value) {
                      _endValue = value;
                    },
                    onChangePlaybackState: (value) {
                      setState(() {
                        _isPlaying = value;
                      });
                    },
                  ),
                ),
                FlatButton(
                  child: _isPlaying
                      ? Icon(
                    Icons.pause,
                    size: 80.0,
                    color: Colors.white,
                  )
                      : Icon(
                    Icons.play_arrow,
                    size: 80.0,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    bool playbackState =
                    await widget.trimmer.videPlaybackControl(
                      startValue: _startValue,
                      endValue: _endValue,
                    );
                    setState(() {
                      _isPlaying = playbackState;
                    });
                  },
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  height: MediaQuery.of(context).size.height/15,

                child:RaisedButton(
                  color: Colors.lightBlue[200],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),


                  onPressed: _progressVisibility
                      ? null
                      : () async {
                    TrimVideos().then((outputPath) {
                      //Output path is path of trimmed video
                      print('OUTPUT PATH: $outputPath');
                      final snackBar = SnackBar(content: Text('Video Trimmed and Saved successfully'));
                      Scaffold.of(context).showSnackBar(snackBar);

                      EditDragDropList(outputPath);

                    });
                  },
                  child: Text("TRIM"),
                )),
              ],
            ),
          ),
          )),
      ),
    ),
      onWillPop: (){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Home()));
      },

    );
  }








  Future<String> TrimVideos() async {

    dir=await getExternalStorageDirectory();
    trimVideoFiles = Directory("${dir.path}/trimvideos/").listSync();

    print("Length of trimVideoFiles: ${trimVideoFiles.length}");

    setState(() {
      _progressVisibility = true;
    });

    String _value;

    await widget.trimmer
        .saveTrimmedVideo(startValue: _startValue,
        endValue: _endValue,
        videoFileName: "TV${trimVideoFiles.length + 1}_${pt.basenameWithoutExtension(widget.videopath)}",
        videoFolderName:"trimvideos",
        storageDir:StorageDir.externalStorageDirectory
    )
        .then((value) {
      setState(() {
        _progressVisibility = false;
        _value = value;
      });
    });

    //print("Output Path is ${_value}");
    return _value;
  }


 //This will edit the list and show path and thumbnail of current trimmed value

 void EditDragDropList(String outputPath) async
 {

   final videoImageThumbnail = await _flutterVideoCompress.getThumbnail(
     outputPath,
     quality: 80,
     position: -1,
   );

   print("Edit drag drop path${videoImageThumbnail}");

   StaticData.dragDropVideoList[widget.videoindex] = {"videoimage":videoImageThumbnail,"videopath":outputPath};

   Navigator.pop(context);
   Navigator.push(context, MaterialPageRoute(
           builder: (context) => Home()));

 }



}