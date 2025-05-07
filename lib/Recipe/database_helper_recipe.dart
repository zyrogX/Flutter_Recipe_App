

// DB/dbhelper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static DBHelper instance = DBHelper._privateConstructor();
  DBHelper._privateConstructor();

  static Database? _db;

  Future<Database> get db async {
    _db ??= await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'recipes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Recipe(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        bakingTime TEXT,
        mealType TEXT,
        isFavorite INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE Ingredient(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipeId INTEGER,
        name TEXT
      )
    ''');
  }

  Future<int> insertRecipe(String name, String bakingTime, String mealTime, List<String> ingredients) async {
    final dbClient = await db;
    int recipeId = await dbClient.insert('Recipe', {
      'name': name,
      'bakingTime': bakingTime,
      'mealType': mealTime,
      'isFavorite': 0
    });

    for (var ingredient in ingredients) {
      await dbClient.insert('Ingredient', {
        'recipeId': recipeId,
        'name': ingredient
      });
    }

    return recipeId;
  }

  Future<List<Map<String, dynamic>>> getAllRecipes() async {
    final dbClient = await db;
    return await dbClient.query('Recipe');
  }

  Future<List<String>> getIngredients(int recipeId) async {
    final dbClient = await db;
    final result = await dbClient.query('Ingredient', where: 'recipeId = ?', whereArgs: [recipeId]);
    return result.map((e) => e['name'] as String).toList();
  }

  Future<void> toggleFavorite(int id, int current) async {
    final dbClient = await db;
    await dbClient.update('Recipe', {'isFavorite': current == 0 ? 1 : 0}, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> searchRecipesByIngredient(String keyword) async {
    final dbClient = await db;
    return await dbClient.rawQuery('''
      SELECT DISTINCT Recipe.* FROM Recipe
      INNER JOIN Ingredient ON Recipe.id = Ingredient.recipeId
      WHERE Ingredient.name LIKE ?
    ''', ['%$keyword%']);
  }

Future<void> updateRecipe(
  int recipeId,
  String name,
  String bakingTime,
  String mealType,
  List<String> newIngredients,
) async {
  final dbClient = await db;

  // Update main recipe info
  await dbClient.update(
    'Recipe',
    {
      'name': name,
      'bakingTime': bakingTime,
      'mealType': mealType,
    },
    where: 'id = ?',
    whereArgs: [recipeId],
  );

  // Clear old ingredients
  await dbClient.delete('Ingredient', where: 'recipeId = ?', whereArgs: [recipeId]);

  // Insert updated ingredients
  for (var ingredient in newIngredients) {
    await dbClient.insert('Ingredient', {
      'recipeId': recipeId,
      'name': ingredient,
    });
  }
}

}
