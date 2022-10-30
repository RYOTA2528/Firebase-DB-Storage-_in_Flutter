
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingProfilePage extends StatefulWidget {
  const SettingProfilePage({Key? key}) : super(key: key);

  @override
  State<SettingProfilePage> createState() => _SettingProfilePageState();
}

class _SettingProfilePageState extends State<SettingProfilePage> {
  File? image;
  String? imagePath = '';
  final ImagePicker _picker = ImagePicker();

  Future<void> selectImage() async {
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if(pickedImage == null) return;
    //再描画する方法
    setState(() {
      image = File(pickedImage.path);
    });
  }
  //FireStorageへのupload用にメソッドを定義
  Future<void> uploadImage() async {
    final ref = FirebaseStorage.instance.ref('test.png'); //　イメージの画像を引数に持たせる必要がある
    final storedImage = await ref.putFile(image!);
    imagePath = await storedImage.ref.getDownloadURL();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール編集ページ'),),
        body:
          Column(
            children: [
              Row(
                children: const [
                  SizedBox (child: Text('名前'), width: 100,),
                  Expanded(child: TextField())
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const SizedBox(child: Text("プロフィール編集"), width: 150,),
                  Expanded( //ExpandedにはaligmentプロパティがないためContainerでこの中をrapする。
                    child: Container(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          onPressed: () async {
                            await selectImage();
                            uploadImage();
                          },
                          child: Text('画像を選択')
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              image == null ? const SizedBox() : SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.file(image!, fit: BoxFit.cover)),
              const SizedBox(height: 150,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: ElevatedButton(onPressed: () {

                    },
                        child: Text('編集',
                        style: TextStyle(
                          fontWeight: FontWeight.bold)
                        ),
                    ),
                    width: 100,),
                ],
              ),
            ],
          ),
        );
  }
}
