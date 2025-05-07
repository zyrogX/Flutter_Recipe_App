import 'package:flutter/material.dart';
import 'package:myapp/Recipe/database_helper_recipe.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  var nameController = TextEditingController();
  var bakingTimeController = TextEditingController();
  String _selectedMealType = "Breakfast";
  final List<String> _mealTypes = ["Breakfast", "Lunch", "Dinner"];

  var ingredientsController = TextEditingController();
  List<String> ingredients = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'Recipe Name'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: bakingTimeController,
                decoration: InputDecoration(hintText: 'Baking Time'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Meal Type'),
                value: _selectedMealType,
                items:
                    _mealTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMealType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 10),

              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: ingredientsController,
                          decoration: InputDecoration(
                            hintText: 'Add Ingredient',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            ingredients.add(ingredientsController.text);
                            ingredientsController.clear();
                          });
                        },
                      ),
                    ],
                  ),
                  ...ingredients.map(
                    (ingredient) => ListTile(
                      title: Text(ingredient),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            ingredients.remove(ingredient);
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              ElevatedButton(
                child: Text('Add Recipe'),
                onPressed: () async {
                  print('Save button pressed');
                  if (nameController.text.isNotEmpty &&
                      bakingTimeController.text.isNotEmpty &&
                      ingredients.isNotEmpty) {
                    int recipeId = await DBHelper.instance.insertRecipe(
                      nameController.text.trim(),
                      bakingTimeController.text,
                      _selectedMealType,
                      ingredients,
                    );
                    print('Recipe saved with ID: $recipeId');
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
