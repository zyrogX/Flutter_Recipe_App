import 'package:flutter/material.dart';
import 'package:myapp/Recipe/Screens/EditRecipe.dart';
import 'package:myapp/Recipe/Screens/SearchRecipe.dart';
import 'package:myapp/Recipe/Screens/addRecipe.dart';
import 'package:myapp/Recipe/database_helper_recipe.dart';

class RecipelistScreen extends StatefulWidget {
  const RecipelistScreen({super.key});

  @override
  State<RecipelistScreen> createState() => _RecipelistScreenState();
}

class _RecipelistScreenState extends State<RecipelistScreen> {
  List<Map<String, dynamic>> recipes = [];

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    recipes = await DBHelper.instance.getAllRecipes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipes"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchScreen()),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final item = recipes[index];

          return ListTile(
            title: Text(item['name']),
            subtitle: Text('${item['mealType']} - ${item['bakingTime']}'),
            trailing: SizedBox(
              height: 96,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                      await DBHelper.instance.toggleFavorite(
                        item['id'],
                        item['isFavorite'],
                      );
                      _fetchRecipes();
                    },
                    icon: Icon(
                      item['isFavorite'] == 1
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 15),
                  IconButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditRecipeScreen(recipe: item),
                        ),
                      );
                      _fetchRecipes();
                    },
                    icon: Icon(Icons.edit, color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddRecipeScreen()),
          );
          _fetchRecipes();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
