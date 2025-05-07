
import 'package:flutter/material.dart';
import 'package:myapp/Recipe/database_helper_recipe.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> results = [];

  Future<void> search() async {
    results = await DBHelper.instance.searchRecipesByIngredient(searchController.text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search by Ingredient')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Enter ingredient',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: search,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(results[index]['name']),
                  subtitle: Text('${results[index]['mealType']} - ${results[index]['bakingTime']}'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
