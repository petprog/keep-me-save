import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keep_me_save/common/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../superbase/supabase_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var imageUrl = '';
  BuildContext? bcontext;
  bool _isLoading = false;
  final _supabaseClient = SupabaseManager();
  @override
  Widget build(BuildContext context) {
    bcontext = context;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Home Page"),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {
                  'Logout',
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Center(
          child: Container(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _upload();
                  },
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text('Upload an Image'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _download();
                  },
                  child: Text('Download the uploaded Image'),
                ),
              ],
            ),
          ),
        ));
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        _supabaseClient.logout(bcontext);
        break;
    }
  }

  Future<void> _upload() async {
    final supabase = Supabase.instance.client;
    final _picker = ImagePicker();
    final imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (imageFile == null) {
      return;
    }
    setState(() => _isLoading = true);

    final bytes = await imageFile.readAsBytes();
    final fileExt = imageFile.path.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    final filePath = fileName;
    final response =
        await supabase.storage.from('public').uploadBinary(filePath, bytes);

    setState(() => _isLoading = false);

    final error = response.error;
    if (error != null) {
      // print(error.message);
      showToastMessage(error.message, isError: true);
      return;
    } else {
      showToastMessage('Uploaded successfully', isError: false);
    }
    final imageUrlResponse =
        supabase.storage.from('public').getPublicUrl(filePath);
    imageUrl = imageUrlResponse.data!;
  }

  Future<void> _download() async {
    final dio = Dio();
    final path = await getDownloadPath();
    final response = await dio.download(imageUrl,
        '$path/new_image_${Random().nextInt(20)}_${Random().nextInt(20)}.jpg');
    if (response.statusCode == 200) {
      showToastMessage("Downloaded succesfully");
    }
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      // print("Cannot get download folder path");
    }
    return directory?.path;
  }
}
