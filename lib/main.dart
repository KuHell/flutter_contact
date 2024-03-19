import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp( MaterialApp( home: MyApp() ) );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Contact> names = [];

  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      var contacts = await ContactsService.getContacts();
      setState(() {
        names = contacts;
      });

    } else if (status.isDenied) {
      print('거절됨');
      Permission.contacts.request();
      openAppSettings();
    }
  }

  frandAdd(frandName) async {
    var newPerson = Contact();
    newPerson.givenName = frandName;
    await ContactsService.addContact(newPerson);
    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    return  // const 제거
      // home: Icon(Icons.star)
      // home: Text('안녕');
      // home: Image.asset('assets/dog.JPG') // 이미지를 assets 라는 이름의 경로로 지정해서 사용
      // home: Container( width:50, height: 50, color: Colors.blue )
      // home: Center(
      //   child: Container( width:50, height: 50, color: Colors.blue )
      // )

      // home: Scaffold( // 앱 상 중 하 나누기
      //   appBar: AppBar(
      //     backgroundColor: Colors.blue,
      //     title: Text('앱임'),
      //     centerTitle: false,
      //   ),
      //   body: Text('안녕'),
      //   bottomNavigationBar: BottomAppBar(
      //     color: Colors.white,
      //     child: SizedBox(
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           Icon(Icons.phone),
      //           Icon(Icons.message),
      //           Icon(Icons.contact_page)
      //         ],
      //       ),
      //     ),
      //   )
      // )

      // home: Scaffold(
      //   appBar: AppBar(
      //     backgroundColor: Colors.blue,
      //     title: Text('앱임'),
      //     centerTitle: false,
      //   ),
      //   body: Align(
      //     alignment: Alignment.center,
      //     child: Container(
      //       width: double.infinity, height: 150,
      //       decoration: BoxDecoration(
      //           border: Border.all(color: Colors.black)
      //       ),
      //       // margin: EdgeInsets.all(20),
      //       // margin: EdgeInsets.fromLTRB(left, top, right, bottom) // 방향
      //       padding: EdgeInsets.all(20),
      //       child: Text('안녕'),
      //     ),
      //   ),
      //   bottomNavigationBar: BottomAppBar(),
      // ),

      // home: Scaffold(
      //   appBar: AppBar(
      //     backgroundColor: Colors.blue,
      //     title: Text('앱임'),
      //     centerTitle: false,
      //   ),
      //   body: SizedBox(
      //     child: Text('안녕하세요', style: TextStyle( color: Color(0xff) ),),
      //   ),
      // )

      // home: Scaffold(
      //   appBar: AppBar(),
      //   body: Container(
      //     height: 150,
      //     child: Row(
      //       children: [
      //         Container(color: Colors.blue, width: 150,),
      //         Expanded(child: Container(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text('카메라팝니다'),
      //               Text('금호동 3가'),
      //               Text('7000원'),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.end,
      //                 children: [
      //                   Icon(Icons.favorite),
      //                   Text('4')
      //                 ],
      //               )
      //             ],
      //           ),
      //         ))
      //       ],
      //     ),
      //   )
      // )

      Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(context: context, builder: (context){
              return DialogUI(frandCount: names.length, frandAddFn: frandAdd, names: names);
            });
          },
        ),
        appBar: AppBar(title: Text(names.length.toString()), centerTitle: false, actions: [
          IconButton(onPressed: (){
            getPermission();
          }, icon: Icon(Icons.contacts))
        ],),
        body: ShopItem(names: names),
      );
  }
}

class DialogUI extends StatelessWidget {
  DialogUI({super.key, this.frandCount, this.frandAddFn, this.names});
  final frandCount;
  final frandAddFn;
  var inputName = TextEditingController();
  final names;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            TextField( decoration: InputDecoration(
              icon: Icon(Icons.star),
            ), controller: inputName ),
            TextButton(onPressed: (){
              print(names);
              frandAddFn(inputName.text);
              Navigator.pop(context);
            }, child: Text('완료')),
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('취소'))
          ],
        ),
      ),
    );
  }
}


class ShopItem extends StatefulWidget {
  ShopItem({super.key, this.names});
  final names;

  @override
  State<ShopItem> createState() => _ShopItemState();
}

class _ShopItemState extends State<ShopItem> {
  var like = [0, 0, 0];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.names.length,
        itemBuilder: (context, i){
          print(widget.names[i]);
          return ListTile(
            leading: Image.asset('assets/dog.JPG'),
            title: Text(widget.names[i].givenName ?? '이름 없음'),
          );
          // ListTile(
          //   leading: Text(like[i].toString()),
          //   title: Text(names[i]),
          //   trailing: ElevatedButton(onPressed: (){
          //     setState(() {
          //       like[i] += 1;
          //     });
          //   }, child: Text('좋아요')),
          // );
        }
    );
  }
}
