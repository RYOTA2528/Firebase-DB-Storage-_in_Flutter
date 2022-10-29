import 'package:flutter/material.dart';

class SettingProfilePage extends StatefulWidget {
  const SettingProfilePage({Key? key}) : super(key: key);

  @override
  State<SettingProfilePage> createState() => _SettingProfilePageState();
}

class _SettingProfilePageState extends State<SettingProfilePage> {

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
                          onPressed: () {

                          },
                          child: Text('画像を選択')
                      ),
                    ),
                  )
                ],
              ),
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
