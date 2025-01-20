import 'package:flutter/material.dart';
import 'package:todo_app/giris_ekran.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/services/giris_kontrol.dart';
import 'package:todo_app/services/veritabani.dart';
import 'package:todo_app/widgets/tamamlanmis_widget.dart';
import 'package:todo_app/widgets/bekleyen_widget.dart';

class AnaEkran extends StatefulWidget {
  const AnaEkran({super.key});

  @override
  State<AnaEkran> createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {

  int _buttonIndex = 0;


  final _widgets = [
    BekleyenWidget(),
    Tamamlanmis(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1d2630),
      appBar: AppBar(
        backgroundColor: Color(0xFF1d2630),
        foregroundColor: Colors.white,
        title: Text("ToDo"),
        actions: [
          IconButton(onPressed: ()async{
            await girisKontrol().signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GirisEkrani()));
          }, icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _buttonIndex = 0;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                      color: _buttonIndex == 0 ? Colors.indigo : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      
                    ),
                    child: Center(
                      child: Text("Bekleyen",
                      style: TextStyle(
                        fontSize: _buttonIndex == 0 ? 16 : 14,
                        fontWeight: FontWeight.w500,
                        color: _buttonIndex == 0 ? Colors.white : Colors.black38,
                      ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _buttonIndex = 1;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                      color: _buttonIndex == 1 ? Colors.indigo : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      
                    ),
                    child: Center(
                      child: Text("Tamamlanan",
                      style: TextStyle(
                        fontSize: _buttonIndex == 1 ? 16 : 14,
                        fontWeight: FontWeight.w500,
                        color: _buttonIndex == 1 ? Colors.white : Colors.black38,
                      ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            _widgets[_buttonIndex],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          _showTaskDialog(context);
        },

      ),
    );
  }

  void _showTaskDialog(BuildContext context, {Todo? todo}){
    final TextEditingController _titleController = TextEditingController(text: todo?.baslik);
    final TextEditingController _descriptionController = TextEditingController(text: todo?.aciklama);
    final Veritabani _databaseService = Veritabani();

    showDialog(context: context, 
    builder: (context){
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(todo == null ? "Görev Ekle" : "Görev Düzenle",
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
        ),
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Başlık",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Açıklama",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, 
          child: Text("İptal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            onPressed: ()async{
            if (todo == null){
              await _databaseService.addTodoTask(_titleController.text, _descriptionController.text);
            }
            else{
              await _databaseService.updateTodo(todo.id, _titleController.text, _descriptionController.text);
            }
            Navigator.pop(context);
          }, child: Text(todo == null ? "Ekle" : "Güncelle"),
          ),
        ],
      );
    },
    );
  }
}