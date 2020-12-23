import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import '../widgets/rounded_button.dart';
import '../widgets/progress_dialog.dart';
import '../constant/constants.dart';
import '../network/network.dart';

class ImageUploadScreen extends StatefulWidget {
  static const String id = 'ImageUploadScreen';
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final _imageNameController = TextEditingController();

  bool _isUploaded = false;
  File _storedImage;
  var base64Image;
  List<int> utf8Inmage;
  File imageResized;
  final _auth = FirebaseAuth.instance;
  String id = '1';


  Future<void> _takePicture() async {
    final picker = ImagePicker();

    final imageFile = await picker.getImage(
      source: ImageSource.camera,
      maxWidth: 400,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
  }

  Future<void> _takePictureGalley() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = imageFile;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
  }

  void gettingNextId() async {
    try {
      const URL =
          'https://phoenixsales-ca589-default-rtdb.firebaseio.com/user_images.json';
      final response = await http.get(URL);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      extractedData.forEach((key, value) {
        id = value['id'];
      });

      id = (int.parse(id) + 1).toString();

      print(id);
    } catch (e) {
      print('errpr $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: _imageNameController,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Enter Image Name/Description'),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 400,
                width: 350,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: _storedImage != null
                    ? Image.file(
                        _storedImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : Text(
                        'No Image Taken',
                        textAlign: TextAlign.center,
                      ),
                alignment: Alignment.center,
              ),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton.icon(
                icon: Icon(Icons.camera),
                label: Text('Take Picture '),
                textColor: Theme.of(context).primaryColor,
                onPressed: _takePicture,
              ),
              FlatButton.icon(
                icon: Icon(Icons.folder_open),
                label: Text('Select Picture From Gallery'),
                textColor: Theme.of(context).primaryColor,
                onPressed: _takePictureGalley,
              ),
              _isUploaded ? CircularProgressIndicator(strokeWidth: 3,semanticsLabel: 'Uploading...',) :
              RoundedButton(

                  title: 'Upload Image',
                  colour: Colors.lightBlueAccent,
                  onPressed: () async {
                    setState(() {
                      _isUploaded = true;
                    });
                    gettingNextId();
                    var url='';
                    print("auth res");

                    final authResult = await _auth.signInWithEmailAndPassword(
                      email: 'kk@gmail.com',
                      password: '12345678',
                    );

                    print("auth res" + authResult.user.uid);

                    final ref = FirebaseStorage.instance
                        .ref()
                        .child('user_image')
                        .child(AreaCode + id + '.jpg');

                    await ref.putFile(_storedImage);
                    print("ref" + ref.toString());
                    url = await ref.getDownloadURL();

                    const URL =
                        'https://phoenixsales-ca589-default-rtdb.firebaseio.com/user_images.json';
                    final response = await http.post(
                      URL,
                      body: json.encode(
                        {
                          'id': id,
                          'AreaCode': AreaCode,
                          'AreaName': AreaName,
                          'uname': UserName,
                          'Image_Name': _imageNameController.text,
                          'url': url,
                          'entrydate': DateTime.now().toString()
                        },
                      ),
                    );

                    var valkey =  json.decode(response.body) as Map<String,dynamic>;
                    print(valkey['name'].toString());


                    try {
                      String urlserver =
                          '$Url/InsertImageFlutter?AreaCode=$AreaCode&uname=$UserName&AreaName=$AreaName&Img_Name=${_imageNameController.text}&Img=$url&user_id=${valkey['name'].toString()}';
                      print(urlserver);
                      NetworkHelper networkHelper = NetworkHelper(urlserver);
                      var data = await networkHelper.getData();
                      print(data);
                    } catch (e) {
                      print(e);
                    }
                    setState(() {
                      _isUploaded = false;
                    });
                    Toast.show("Image Uploaded", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                    Navigator.of(context).pop();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
