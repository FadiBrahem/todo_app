import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo_app1/new_todo.dart';
import 'package:todo_app1/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoApp',
      home: Home(),
      theme: ThemeData(
        primarySwatch: Colors.lime
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin{
  List<Todo> list = new List<Todo>();
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    loadSharedPreferencesAndData();
    super.initState();
  }

  void loadSharedPreferencesAndData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TodoTestapp',
          key: Key('main-app-title'),
        ),
        centerTitle: true,
      ),
      
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>goToNewItemView(),
      ),
      drawer: Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      
      children:  <Widget>[
         Container(
           height: 88, 
           
           child: DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
            
            
          ),
           
       
          
          
            child: Text(
            'options',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
            ),
            textAlign: TextAlign.center,

          ),
          
        ),
        ),
              
        ListTile(
          leading: Icon(Icons.message),
          title: Text('inbox'),
          subtitle: Text('A sub test'),
          onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
 
        ),
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text('tasks'),
          subtitle: Text('A sub test'),
           onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          subtitle: Text('A sub test'),
           onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
      ],
    ),
  ),
      
      body: list.isEmpty ? emptyList() : buildListView()
    );
  }

  Widget emptyList(){
    return Center(
    child:  Text('No items')
    );
  }

  Widget buildListView() {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context,int index){
        return buildItem(list[index], index);
      },
    );
  }

  Widget buildItem(Todo item, index){
    return Dismissible(
      key: Key('${item.hashCode}'),
      background: Container(color: Colors.red[700]),
      onDismissed: (direction) => removeItem(item),
      direction: DismissDirection.startToEnd,
      child: buildListTile(item, index),
    );
  }

  Widget buildListTile(Todo item, int index){
    print(item.completed);
    return ListTile(
      onTap: () => changeItemCompleteness(item),
      onLongPress: () => goToEditItemView(item),
      title: Text(
        item.title,
        key: Key('item-$index'),
        style: TextStyle(
          color: item.completed ? Colors.grey : Colors.black,
          decoration: item.completed ? TextDecoration.lineThrough : null
        ),
      ),
      trailing: Icon(item.completed
        ? Icons.check_box
        : Icons.check_box_outline_blank,
        key: Key('completed-icon-$index'),
      ),
    );
  }

  void goToNewItemView(){

    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return NewTodoView();
    })).then((title){
      if(title != null) {
        addItem(Todo(title: title));
      }
    });
  }

  void addItem(Todo item){
  
    list.insert(0, item);
    saveData();
  }

  void changeItemCompleteness(Todo item){
    setState(() {
      item.completed = !item.completed;
    });
    saveData();
  }

  void goToEditItemView(item){
    // We re-use the NewTodoView and push it to the Navigator stack just like
    // before, but now we send the title of the item on the class constructor
    // and expect a new title to be returned so that we can edit the item
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return NewTodoView(item: item);
    })).then((title){
      if(title != null) {
        editItem(item, title);
      }
    });
  }

  void editItem(Todo item ,String title){
    item.title = title;
    saveData();
  }

  void removeItem(Todo item){
    list.remove(item);
    saveData();
  }

  void loadData() {
    List<String> listString = sharedPreferences.getStringList('list');
    if(listString != null){
      list = listString.map(
        (item) => Todo.fromMap(json.decode(item))
      ).toList();
      setState((){});
    }
  }

  void saveData(){
    List<String> stringList = list.map(
      (item) => json.encode(item.toMap()
    )).toList();
    sharedPreferences.setStringList('list', stringList);
  }
}

/******************************************************************************** */


class LoginPage extends StatefulWidget {
 LoginPage ({Key key, this.title}) : super(key: key);
  final String title;
  @override
      LoginPageState createState() => LoginPageState();
  }


class LoginPageState extends State<LoginPage> {
  
TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

      @override
      Widget build(BuildContext context) {

        final emailField = TextField(
          obscureText: false,
          style: style,
          decoration: InputDecoration(
           
              hintText: "Email",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
        final passwordField = TextField(
          obscureText: true,
          style: style,
          decoration: InputDecoration(
              
              hintText: "Password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        );
        final loginButon = Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff01A0C7),
          child: MaterialButton(
            onPressed :(){ Navigator.push(context, MaterialPageRoute(builder: (context) =>Home()));
            },
            minWidth: MediaQuery.of(context).size.width,
          
            
            child: Text("Login",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );

        return Scaffold(
          resizeToAvoidBottomPadding: false,
          
          body: Center(
            
            child: Container(
              color: Colors.blue[100],
              child: Padding(
                padding: const EdgeInsets.all(35.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 155.0,
                      child: Image.asset(
                        "assets/images/81095077_467940924136090_4126224297297444864_n.jpg",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 45.0),
                    emailField,
                    SizedBox(height: 25.0),
                    passwordField,
                    SizedBox(
                      height: 35.0,
                    ),


                    loginButon,
                  
                  
                    SizedBox(
                      height: 15.0,

                    ),
                   
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }


/********************************************************************************** */



