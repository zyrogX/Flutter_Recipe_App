import 'package:flutter/material.dart';
import 'package:myapp/Recipe/database_helper_recipe.dart';

class EditRecipeScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const EditRecipeScreen({super.key, required this.recipe});

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  late TextEditingController nameController;
  late TextEditingController bakingTimeController;
  late String selectedMealType;
  List<String> ingredients = [];
  final TextEditingController ingredientController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      nameController = TextEditingController(text: widget.recipe['name']);
    bakingTimeController = TextEditingController(text: widget.recipe['bakingTime']);
    selectedMealType = widget.recipe['mealType'];
    });
    
    _loadIngredients();
  }

  Future<void> _loadIngredients() async {
    ingredients = await DBHelper.instance
        .getIngredients(widget.recipe['id']);
    setState(() {});
  }

  Future<void> _saveChanges() async {
    // Update recipe base info
    await DBHelper.instance.updateRecipe(
      widget.recipe['id'],
      nameController.text.trim(),
      bakingTimeController.text.trim(),
      selectedMealType,
      ingredients,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Recipe Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: bakingTimeController,
                decoration: const InputDecoration(
                  labelText: 'Baking Time',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: selectedMealType,
                items: ['Breakfast', 'Lunch', 'Dinner'].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedMealType = val!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Meal Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: ingredientController,
                      decoration: const InputDecoration(
                        labelText: 'Add Ingredient',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (ingredientController.text.trim().isNotEmpty) {
                        setState(() {
                          ingredients.add(ingredientController.text.trim());
                          ingredientController.clear();
                        });
                      }
                    },
                    child: const Icon(Icons.add),
                  )
                ],
              ),
              const SizedBox(height: 16),
              ...ingredients.map((ingredient) => ListTile(
                    title: Text(ingredient),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          ingredients.remove(ingredient);
                        });
                      },
                    ),
                  )),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
