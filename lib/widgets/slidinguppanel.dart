import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:music_application/theme.dart';
import 'package:music_application/youtube_api/youtube_api.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//import 'dropbox.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:storage_path/storage_path.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:webview_media/webview_flutter.dart';
import 'package:http/http.dart' as http;

import 'dropbox.dart';

class SlidingUpPanelTabs extends StatefulWidget {
  PanelController controller = PanelController();
  SlidingUpPanelTabs({Key key, this.controller});
  @override
  _SlidingUpPanelTabsState createState() => _SlidingUpPanelTabsState();
}

class _SlidingUpPanelTabsState extends State<SlidingUpPanelTabs>
    with SingleTickerProviderStateMixin {
  String url = 'https://api.dailymotion.com/videos?page=1';
  String url2 = 'https://api.dailymotion.com/videos?page=2';
  List<dynamic> data;
  List<dynamic> searchData;

  TextEditingController searchbar;
  Icon iconSearch = Icon(Icons.search);
  Widget barForDailymotion = Text(
    'dailymotion',
    style: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  TabController _controller;
  int currentPos;
  String stateText;
  String apikey = 'AIzaSyDVklre5qoxkR7TVa11mp4Gr0B6yz1M8h4';
  //String apikey = 'AIzaSyByk6OwDukiENI7QR6VKRuzi4ZDtKLRWdg';
  TextEditingController search;
  YoutubePlayerController videoController;
  YoutubeAPI _youtubeAPI;
  List<YT_API> you_res;
  List<VideoItem> videoitem;
  List list = [];
  List paths = [];
  List videoName = [];
  List<Uint8List> videoImg = [];
  final _flutterVideoCompress = FlutterVideoCompress();

  Icon cusIcon = Icon(
    Icons.search,
    color: Colors.grey,
  );

  Widget barForYoutube = Image.asset(
    'assets/youtube.png',
    width: 98.0,
    height: 22.0,
  );
  Widget iconsadd = IconButton(
    icon: Icon(
      Icons.account_circle,
      color: Colors.grey,
    ),
    onPressed: () {},
  );

  bool onSearch = true;
  @override
  void initState() {
    currentPos = 0;
    stateText = "Video not started";
    super.initState();
    _controller = new TabController(length: 3, vsync: this);

    search = TextEditingController();
    _youtubeAPI = YoutubeAPI(apikey, type: 'video', maxResults: 30);
    you_res = [];
    videoitem = [];

    callApi('YOUTUBE CHANNEL FIRST PAGE');

    super.initState();
    run();

    searchbar = TextEditingController();
    getRequest();
  }

  Future<Null> callApi(String query) async {
    if (you_res.isNotEmpty) {
      videoitem.clear();
    }
    you_res = await _youtubeAPI.search(query);

    print("Youtube api data is:"+you_res.toString());



    for (YT_API res in you_res) {

      print("Response response:"+res.toString());

      VideoItem item = VideoItem(api: res);
      videoitem.add(item);
    }
    setState(() {});
  }

  void run() async {
    String video = await StoragePath.videoPath;
    if (video != null) {
      list = json.decode(video);

      setState(() {
        for (int i = 0; i < list[0]['files'].length; i++) {
          if (!paths.contains(list[0]['files'][i]['path'])) {
            paths.add(list[0]['files'][i]['path']);
            videoName.add(list[0]['files'][i]['displayName']);
          }
        }
        getVideoImage();
      });
    }
  }

  void getVideoImage() async {
    for (int i = 0; i < paths.length; i++) {
      final thumbnail = await _flutterVideoCompress.getThumbnail(
        paths[i],
        quality: 50,
        position: -1,
      );

      setState(() {
        videoImg.add(thumbnail);
      });
    }
  }

  Future<Null> getRequest() async {
    var result = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var result2 = await http
        .get(Uri.encodeFull(url2), headers: {"Accept": "application/json"});
    setState(() {
      var res = json.decode(result.body);
      var res2 = json.decode(result2.body);
      data = res['list'];
      data += res2['list'];
    });
  }

  Future<Null> onSearchForDailymotion(String query) async {
    List q = query.split(' ');
    String dat = '';
    for (int i = 0; i < q.length; i++) {
      if (q[i] != ' ') dat = '$dat+${q[i]}';
    }
    if (dat[dat.length - 1] == '+')
      dat = dat.substring(1, (dat.length - 1));
    else
      dat = dat.substring(1, dat.length);

    print(
        '-------------------------------------------------------------------------------$dat');
    String searchApi =
        'https://api.dailymotion.com/videos?fields=id,thumbnail_url,title%2Ctitle&country=pk&search=$dat&limit=50';

    var resSearch = await http.get(Uri.encodeFull(searchApi),
        headers: {"Accept": "application/json"});
    setState(() {
      var res = json.decode(resSearch.body);
      searchData = res['list'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: new Scaffold(
        body: new Column(
          children: <Widget>[
            new TabBar(
              unselectedLabelColor: theme.primaryColor,
              indicatorColor: theme.primaryColor,
              controller: _controller,
              labelColor: theme.primaryColor,
              tabs: [
                new Tab(
                  text: 'Gallery',
                ),
                new Tab(
                  icon: Image.asset(
                    "assets/youtube.png",
                    height: 80,
                    width: 80,
                  ),
                ),
                new Tab(
                  text: 'Dailymotion',
                ),
              ],
            ),
            new Flexible(
              child: new TabBarView(
                controller: _controller,
                children: <Widget>[
                  //Gallery code starts
                  videoImg.length == videoName.length && videoName.length != 0
                      ? new GridView.count(
                          crossAxisCount: 2,
                          children: List.generate(paths.length, (index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 10.0,
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                          bottomLeft: Radius.zero,
                                          bottomRight: Radius.zero),
                                      child: Image.memory(
                                        videoImg[index],
                                        height: 150.0,
                                        width: 180.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    AutoSizeText(
                                      '${videoName[index]}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        )
                      : Center(child: Text("Videos not found!")),
                  Scaffold(
                    appBar: AppBar(
                      leading: Container(),
                      backgroundColor: Colors.white,
                      title: barForYoutube,
                      actions: <Widget>[
                        IconButton(
                          icon: cusIcon,
                          onPressed: () {
                            setState(() {
                              if (this.cusIcon.icon == Icons.search) {
                                this.cusIcon = Icon(
                                  Icons.cancel,
                                  color: Colors.grey,
                                );
                                this.barForYoutube = TextFormField(
                                  textInputAction: TextInputAction.go,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                                    hintText: 'Search...',
                                  ),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                  controller: search,
                                  onFieldSubmitted: (String query) async {
                                    await callApi(query);
                                    setState(() {});
                                  },
                                );
                                setState(() {
                                  onSearch = !onSearch;
                                });
                              } else {
                                this.cusIcon = Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                );
                                setState(() {
                                  onSearch = true;
                                  search.clear();
                                });
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    body: Stack(
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                child: ListView.builder(
                                  padding: EdgeInsets.all(8.0),
                                  itemCount: videoitem.length,
                                  itemBuilder: (_, int index) =>
                                      videoitem[index],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Stack(children: <Widget>[
                  //   DragBox(Offset(0.0, 0.0), 'Box One', Colors.blueAccent),
                  //   DragBox(Offset(200.0, 0.0), 'Box Two', Colors.orange),
                  //   DragBox(Offset(300.0, 0.0), 'Box Three', Colors.lightGreen),
                  // ]),
                  Scaffold(
                    appBar: AppBar(
                      title: barForDailymotion,
                      backgroundColor: Colors.black,
                      actions: <Widget>[
                        IconButton(
                            icon: iconSearch,
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                if (this.iconSearch.icon == Icons.search) {
                                  this.iconSearch = Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                  );
                                  this.barForDailymotion = TextFormField(
                                    textInputAction: TextInputAction.go,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(
                                            5.0, 0.0, 0.0, 0.0),
                                        hintText: 'Search...',
                                        hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white))),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                    controller: searchbar,
                                    onFieldSubmitted: (String query) {
                                      onSearchForDailymotion(query);
                                    },
                                  );
                                } else {
                                  this.iconSearch = Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  );
                                  this.barForDailymotion = Text(
                                    'dailymotion',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              });
                            }),
                      ],
                    ),
                    body: Container(
                      child: data != null && searchData == null
                          ? ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: Image.network(
                                          'https://www.dailymotion.com/thumbnail/video/${data[index]['id']}',
                                          height: 100.0,
                                          width: 100.0),
                                      title: Text('${data[index]['title']}'),
                                      subtitle:
                                          Text('${data[index]['channel']}'),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PlayerForDailymotion(
                                                        url:
                                                            'https://www.dailymotion.com/embed/video/${data[index]['id']}')));
                                      },
                                    ),
                                  ),
                                );
                              })
                          : searchData != null
                              ? ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          leading: Image.network(
                                              '${searchData[index]['thumbnail_url']}',
                                              height: 100.0,
                                              width: 100.0),
                                          title: Text(
                                              '${searchData[index]['title']}'),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PlayerForDailymotion(
                                                            url:
                                                                'https://www.dailymotion.com/embed/video/${searchData[index]['id']}')));
                                          },
                                        ),
                                      ),
                                    );
                                  })
                              : Center(child: CircularProgressIndicator()),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoItem extends StatelessWidget {
  final YT_API api;

  const VideoItem({Key key, this.api}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Card(
        child: ListTile(
          leading: Image.network(api.thumbnail['high']['url']),
          title: Text(
            api.title,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            api.channelTitle,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlayerForYoutube(api, context)),
            );
          },
        ),
      ),
    );
  }
}

class PlayerForYoutube extends StatelessWidget {
  String videoId;
  YoutubePlayerController _controller;
  YT_API _yi_api;

  PlayerForYoutube(YT_API api, BuildContext context) {
    //onTap(api, context);
    _yi_api = api;
    _controller = YoutubePlayerController(
      initialVideoId: api.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

              //For url of Youtube
              Divider(
                height: 5.0,
                color: Colors.grey,
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'URL: ${_yi_api.url}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayerForDailymotion extends StatefulWidget {
  final String url;

  PlayerForDailymotion({this.url});

  @override
  _PlayerForDailymotionState createState() => _PlayerForDailymotionState();
}

class _PlayerForDailymotionState extends State<PlayerForDailymotion> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'dailymotion',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webviewController) {
          _controller.complete(webviewController);
        },
      ),
    );
  }
}