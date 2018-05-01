import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'views/video_cell.dart';

void main() => runApp(new RealWorldApp());

class RealWorldApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RealWorldState();
  }
}

class RealWorldState extends State<RealWorldApp> {
  var _isLoading = true;
  var videos;

  _fetchData() async {
    final url = "https://api.letsbuildthatapp.com/youtube/home_feed";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final map = json.decode(response.body);

      setState(() {
        _isLoading = false;
        videos = map["videos"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text("Real world app"),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    _fetchData();
                  })
            ],
          ),
          body: new Center(
              child: _isLoading
                  ? new CircularProgressIndicator()
                  : new ListView.builder(
                      itemCount: videos != null ? videos.length : 0,
                      itemBuilder: (context, i) {
                        final video = videos[i];
                        return new FlatButton(
                          padding: EdgeInsets.all(0.0),
                          child: new VideoCell(video),
                          onPressed: () {
                            Navigator.push(context, 
                              new MaterialPageRoute(
                                builder: (context) => new DetailPage()
                              )
                            );
                          },
                        );
                      }))),
    );
  }
}

class DetailPage extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
     return new Scaffold(
       appBar: new AppBar(
         title: new Text("Detail page"),
       ),
       body: new Center(
         child: new Text("Detail")
       ),
     );
    }
}
