// main.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:select_form_field/select_form_field.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  // await Hive.deleteBoxFromDisk('shopping_box');
  await Hive.openBox('shopping_box');

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'tp3',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
    );
  }
}

// Home Page
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _items = [];

  final _shoppingBox = Hive.box('shopping_box');

  @override
  void initState() {
    super.initState();
    _refreshItems(); // Load data when app starts
  }

  // Get all items from the database
  void _refreshItems() {
    final data = _shoppingBox.keys.map((key) {
      final value = _shoppingBox.get(key);
      return {"key": key, "Entreprise": value['Entreprise'], "Salaire": value['Salaire'],"SalaireNet":value['SalaireNet'],"Commentaire":value['Commentaire']};
    }).toList();

    setState(() {
      _items = data.reversed.toList();
      // we use "reversed" to sort items in order from the latest to the oldest
    });
  }

  // Create new item
  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _shoppingBox.add(newItem);
    _refreshItems(); // update the UI
  }

  // Retrieve a single item from the database by using its key
  // Our app won't use this function but I put it here for your reference
  Map<String, dynamic> _readItem(int key) {
    final item = _shoppingBox.get(key);
    return item;
  }

  // Update a single item
  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _shoppingBox.put(itemKey, item);
    _refreshItems(); // Update the UI
  }

  // Delete a single item
  Future<void> _deleteItem(int itemKey) async {
    await _shoppingBox.delete(itemKey);
    _refreshItems(); // update the UI

    // Display a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('un job a été suprimer')));
  }

  // TextFields' controllers
  final TextEditingController _EntrepriseController = TextEditingController();
  final TextEditingController _SalaireController = TextEditingController();
  final TextEditingController _SalairenetController = TextEditingController();
  final TextEditingController _CommentaireController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(BuildContext ctx, int? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item

    if (itemKey != null) {
      final existingItem =
      _items.firstWhere((element) => element['key'] == itemKey);
      _EntrepriseController.text = existingItem['Entreprise'];
      _SalaireController.text = existingItem['Salaire'];
      _SalairenetController.text = existingItem['SalaireNet'];
      _CommentaireController.text = existingItem['Commentaire'];
    }

    showModalBottomSheet(
        context: ctx,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              top: 15,
              left: 15,
              right: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _EntrepriseController,
                decoration: const InputDecoration(hintText: 'Entreprise :'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _SalaireController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Salaire :'),
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),],
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 10,
              ),

              SelectFormField(
                type: SelectFormFieldType.dropdown, // or can be dialog
                initialValue: 'circle',
                labelText: 'cadre/non_cadre',
                items: _items,
                onChanged: (val) => print(val),
                onSaved: (val) => print(val),
              ),
              TextField(
                controller: _SalairenetController,
                decoration: const InputDecoration(hintText: 'Salaire Net : '),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _CommentaireController,
                decoration: const InputDecoration(hintText: 'Commentaire :'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  // Save new item
                  if (itemKey == null) {
                    _createItem({
                      'Entreprise': _EntrepriseController.text,
                      'Salaire': _SalaireController.text,
                      'SalaireNet':_SalairenetController.text,
                      'Commentaire':_CommentaireController.text,
                    });
                  }

                  // update an existing item
                  if (itemKey != null) {
                    _updateItem(itemKey, {
                      'Entreprise': _EntrepriseController.text.trim(),
                      'Salaire': _SalaireController.text.trim(),
                      'SalaireNet':_SalairenetController.text.trim(),
                      'Commentaire':_CommentaireController.text.trim()
                    });
                  }

                  // Clear the text fields
                  _EntrepriseController.text = '';
                  _SalaireController.text = '';
                 _SalairenetController.text = '';
                  _CommentaireController.text = '';

                  Navigator.of(context).pop(); // Close the bottom sheet
                },
                child: Text(itemKey == null ? 'Nouveau' : 'mis a jour '),
              ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('trouve-ton-taf.com'),
      ),
      body: _items.isEmpty
          ? const Center(
        child: Text(
          'Vide',
          style: TextStyle(fontSize: 30),
        ),
      )
          : ListView.builder(
        // the list of items
          itemCount: _items.length,
          itemBuilder: (_, index) {
            final currentItem = _items[index];
            return Card(
              color: Colors.blue,
              margin: const EdgeInsets.all(10),
              elevation: 3,
              child: ListTile(
                  title: Text("entreprise : " + currentItem['Entreprise']),
                  subtitle: Text("salaire : " + currentItem['Salaire'].toString() + '\n' +"Salaire Net : "+ currentItem['SalaireNet'].toString() + '\n' +"Commentaire :"+ currentItem['Commentaire'].toString()),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit button
                      IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _showForm(context, currentItem['key'])),
                      // Delete button
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteItem(currentItem['key']),
                      ),
                    ],
                  )),
            );
          }),
      // Add new item button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(context, null),
        icon: Icon(Icons.cookie),
        label: Text("nouveau"),
      ),
    );
  }
}