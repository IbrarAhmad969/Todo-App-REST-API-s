import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/addpage.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

   List items= [];
   bool isLoading = true;


   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Visibility(
        visible: isLoading,
       child: const Center(child: CircularProgressIndicator(),),
         replacement: RefreshIndicator(
          onRefresh: fetchData,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),color: const Color.fromARGB(115, 209, 207, 207)
              ),
              height: 500,
              width: 450,
              
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index){
              
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
              
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text('${index+1}', style: const TextStyle(color: Colors.white),)),
                  title: Text(item['title'], style:const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if(value == 'edit'){
                        //open the page 
                        navigatorToEditPage(item);
              
                      }
                      else if(value == 'delete'){
                        // Delete and refresh 
                        deleteById(id);
              
                      }
                    },
                    itemBuilder: (context){
                    
                    return [
                     const PopupMenuItem(
                      child: Text("Edit"),
                      value: 'edit',
                      
                      ),
                     const PopupMenuItem(
                      child: Text("Delete"),
                      value: 'delete',
                      ),
                    ];
                  },),
                );
              
              }),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: () {
         navigatorToAddPage();
        },
        label: const Text("Add todo", style: TextStyle(color: Colors.white),),
      ),
    );
    
  }
 Future<void> navigatorToAddPage() async{
    final route = MaterialPageRoute(builder: (context) => AddPage());
    await Navigator.push(context, route);
    fetchData();
  }
 
  Future<void> navigatorToEditPage(Map item) async{
    final route = MaterialPageRoute(builder: (context) => AddPage(todoitem: item,),);
    await Navigator.push(context, route);
    fetchData();
  }

  Future<void> fetchData()async{

    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    
    if(response.statusCode == 200 ){
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items=result;
      });
    }
    else{
     const SnackBar(content:  Text("Failded to delete"));

    }

    setState(() {
      isLoading=false;

    });
  }
  
 Future<void> deleteById(String id)async {

  final url = 'https://api.nstack.in/v1/todos/$id';
  final uri = Uri.parse(url);

  final response = await http.delete(uri);
  
  if(response.statusCode==200){
    //remove item 
    final filteredItems = items.where((element) => element['_id']!=id).toList();
  setState(() {

    items=filteredItems;
  });
  }
  else{

    const snakbar = SnackBar(content: Text('Error while deleting'),

    );
    ScaffoldMessenger.of(context).showSnackBar(snakbar);

  }

  }
}
