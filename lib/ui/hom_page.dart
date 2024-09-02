import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {

  String? _search = null;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if( _search == null ){
      response = await http.get(Uri.parse('https://api.giphy.com/v1/gifs/trending?api_key=MMrynW5F4avbqJMZGTjVSyoLYohWzeCz&limit=20&offset=0&rating=g&bundle=messaging_non_clips'));
    }else{
      response = await http.get(Uri.parse('https://api.giphy.com/v1/gifs/search?api_key=MMrynW5F4avbqJMZGTjVSyoLYohWzeCz&q=$_search&limit=20&offset=0&rating=g&lang=en&bundle=messaging_non_clips'));
    }


    return jsonDecode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then( (map){
      print(map);
    } );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: const InputDecoration(
                  labelText: "Pesquise aqui",
                  labelStyle: TextStyle( color: Colors.white ),
                  border: OutlineInputBorder()
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0
              ),
              textAlign: TextAlign.center,
              onSubmitted: (texto){
                setState(() {
                  if( texto == ''){
                    _search = null;
                  }else{
                    _search = texto;
                  }
                });
              },
            ),
          ),
          Expanded(child: FutureBuilder(
            future: _getGifs(),
            builder: (context,snap){
              switch(snap.connectionState){
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Container(
                    width: 200.0,
                    height: 200.0,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      valueColor:  AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5.0,
                    ),
                  );
                default:
                  if( snap.hasError) {
                    return Container();
                  } else {
                    return _createGifTable(context,snap);
                  }
              }
            },
          ))
        ],
      ),
    );
  }

  int _getCount(List data){
    if( _search )
  }

  Widget _createGifTable(BuildContext context,AsyncSnapshot snap){
  return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: snap.data['data'].length,
      itemBuilder: (context,index){
        return GestureDetector(
          child: Image.network( snap.data['data'][index]['images']['fixed_height_small']['url'],
          height: 300,
          fit: BoxFit.cover,),
        );
      }
  );
  }
}
