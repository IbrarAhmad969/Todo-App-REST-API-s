import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPage extends StatefulWidget {
  final Map? todoitem;

  const AddPage({super.key, this.todoitem});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todoitem;

    if(todo != null){
      isEdit = true;
      final title =todo['title'];
      final desc = todo['description'];
      titleController.text= title;
      desController.text = desc;

    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          
          isEdit? 'Edit Page': "Add Todo", style:const TextStyle(color: Colors.white),),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              focusColor: Colors.blue,
              border: OutlineInputBorder(
                
                borderSide: BorderSide(),
                
              ),
              hintText: "Title",
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: desController,
            
            decoration: const InputDecoration(
              hintText: "Description",
             border: OutlineInputBorder(
              
              borderSide: BorderSide(),

             )
            ),
            keyboardType: TextInputType.multiline,
            maxLines: 5,
          ),
          const SizedBox(
            height: 12,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:MaterialStateProperty.all<Color>(Colors.blue),

              
            ),
            onPressed: isEdit? updateData: sumbitData, child: Text(
            
            isEdit? "Update " : "Submit", style: TextStyle(color: Colors.white),
          
          )
          ),

        ],
      ),
    );
  }
  void updateData()async{

     final title = titleController.text;
    final decription = desController.text;
    final todo = widget.todoitem;
    if(todo==null){
      print("you can call updated without todo data");
      return;
    }
    final id = todo['_id'];


    final body = {
      "title": title,
      "description": decription,
      "is_completed": false,
    };
    //update the data to the server
      final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);

    final response = await http.put(uri, body: jsonEncode(body), headers: {
      'Content-Type':
          'application/json' // content type is json, we are sending the json, server will parse it
    });

     if (response.statusCode == 200) {
      showSuccessMessage("Updated Success");
      titleController.text ='';
      desController.text = '';


    } else {
      showErrorMessage("Failed to Update data");

    }
  }
  void sumbitData() async {
    //get data from form
    final title = titleController.text;
    final decription = desController.text;

    final body = {
      "title": title,
      "description": decription,
      "is_completed": false,
    };

    //submit data to server
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);

    final response = await http.post(uri, body: jsonEncode(body), headers: {
      'Content-Type':
          'application/json' // content type is json, we are sending the json, server will parse it
    });
    //show the data

    if (response.statusCode == 201) {
      showSuccessMessage("Success");
      titleController.text ='';
      desController.text = '';


    } else {
      showErrorMessage("Failed to sent data");

    }
  }

  void showSuccessMessage(String message) {
    final snakbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snakbar);
  }
  
  void showErrorMessage(String message){
    final snakbar = SnackBar(content: Text(message, style: const TextStyle(
      color: Colors.red,
    ),), );
    ScaffoldMessenger.of(context).showSnackBar(snakbar);

  }
 
}
