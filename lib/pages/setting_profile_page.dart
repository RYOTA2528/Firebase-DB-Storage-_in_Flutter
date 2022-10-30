
import 'dart:io';
import 'package:firebase/firestore/user_firestore.dart';
import 'package:firebase/utils/shared_prefs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/user.dart';

class SettingProfilePage extends StatefulWidget {
  const SettingProfilePage({Key? key}) : super(key: key);

  @override
  State<SettingProfilePage> createState() => _SettingProfilePageState();
}

class _SettingProfilePageState extends State<SettingProfilePage> {
  File? image;
  String? imagePath = '';
  final ImagePicker _picker = ImagePicker();
  final TextEditingController controller = TextEditingController();

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
    String path = image!.path.substring(image!.path.lastIndexOf("/"));
    final ref = FirebaseStorage.instance.ref(path); //　イメージの画像を引数に持たせる必要がある
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
                children: [
                  const SizedBox (child: Text('名前'), width: 100,),
                  Expanded(child: TextField(
                    controller: controller,
                  ))
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
                            await uploadImage();
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
                      User newProfile = User(
                        name: controller.text,
                        imagePath: imagePath,
                        uid: SharedPrefs.fetchUid()!
                      );
                     UserFirestore.updateUser(newProfile) ;//編集ボタンを押すと同時に更新するメソッドをここに入れる
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
