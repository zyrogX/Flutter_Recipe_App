import 'package:flutter/material.dart';
 
import 'package:myapp/Recipe/Screens/recipeList.dart';
 // correct path

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: RecipelistScreen(), // <-- MAKE SURE THIS IS NOT NULL
    );
  }
}
