import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class RecipeService {
  static const String _savedRecipesKey = 'savedRecipes';
  static const String _mealHistoryKey = 'mealHistory';

  // Generate recipes based on ingredients and user preferences
  static Future<List<Recipe>> generateRecipes({
    required List<String> ingredients,
    required List<String> dietaryRestrictions,
    required String allergies,
    required int calorieGoal,
  }) async {
    // TODO: Replace with actual AI API call
    // For now, return sample recipes for demo

    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    if (ingredients.isEmpty) {
      return [];
    }

    List<Recipe> recipes = [];

    // Sample recipe 1
    if (ingredients.any((i) => i.toLowerCase().contains('chicken'))) {
      recipes.add(
        Recipe.sample(
          name: '🍗 Herb Roasted Chicken',
          ingredients: [
            'chicken breast',
            'olive oil',
            'garlic',
            'rosemary',
            'salt',
            'pepper',
          ],
          instructions: [
            'Preheat oven to 400°F',
            'Rub chicken with olive oil and herbs',
            'Roast for 25-30 minutes',
            'Let rest for 5 minutes before serving',
          ],
          cookTime: 35,
          calories: 450,
          matchPercentage: 92,
        ),
      );
    }

    // Sample recipe 2
    if (ingredients.any((i) => i.toLowerCase().contains('rice'))) {
      recipes.add(
        Recipe.sample(
          name: '🍚 Garlic Fried Rice',
          ingredients: ['rice', 'garlic', 'soy sauce', 'eggs', 'green onions'],
          instructions: [
            'Heat oil in a wok',
            'Add minced garlic and stir for 30 seconds',
            'Add rice and soy sauce, stir-fry for 3 minutes',
            'Push rice aside, scramble eggs, then mix everything',
            'Garnish with green onions',
          ],
          cookTime: 15,
          calories: 380,
          matchPercentage: 88,
        ),
      );
    }

    // Sample recipe 3
    if (ingredients.any(
      (i) =>
          i.toLowerCase().contains('broccoli') ||
          i.toLowerCase().contains('pasta'),
    )) {
      recipes.add(
        Recipe.sample(
          name: '🥦 Broccoli Pasta',
          ingredients: [
            'pasta',
            'broccoli',
            'garlic',
            'olive oil',
            'parmesan',
            'red pepper flakes',
          ],
          instructions: [
            'Cook pasta according to package',
            'Steam broccoli for 5 minutes',
            'Sauté garlic in olive oil',
            'Toss pasta and broccoli with garlic oil',
            'Top with parmesan and red pepper flakes',
          ],
          cookTime: 20,
          calories: 520,
          matchPercentage: 75,
        ),
      );
    }

    // Sample recipe 4 (default)
    if (recipes.isEmpty) {
      recipes.add(
        Recipe.sample(
          name: '🥗 Simple Veggie Stir-fry',
          ingredients: [
            'mixed vegetables',
            'soy sauce',
            'garlic',
            'ginger',
            'sesame oil',
          ],
          instructions: [
            'Heat oil in a large pan',
            'Add garlic and ginger, stir for 30 seconds',
            'Add vegetables and stir-fry for 5-7 minutes',
            'Add soy sauce and cook for 1 more minute',
          ],
          cookTime: 15,
          calories: 250,
          matchPercentage: 65,
        ),
      );
    }

    return recipes;
  }

  // Save a recipe to Saved Recipes
  static Future<void> saveRecipe(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    final savedRecipesJson = prefs.getStringList(_savedRecipesKey) ?? [];

    final recipeWithDate = Recipe(
      id: recipe.id,
      name: recipe.name,
      ingredients: recipe.ingredients,
      instructions: recipe.instructions,
      cookTime: recipe.cookTime,
      calories: recipe.calories,
      protein: recipe.protein,
      carbs: recipe.carbs,
      fat: recipe.fat,
      matchPercentage: recipe.matchPercentage,
      difficulty: recipe.difficulty,
      mainIngredients: recipe.mainIngredients,
      dateSaved: DateTime.now(),
      dateCooked: null,
      userRating: null,
    );

    savedRecipesJson.add(jsonEncode(recipeWithDate.toJson()));
    await prefs.setStringList(_savedRecipesKey, savedRecipesJson);
  }

  // Remove a saved recipe
  static Future<void> removeSavedRecipe(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final savedRecipesJson = prefs.getStringList(_savedRecipesKey) ?? [];

    final updatedList = savedRecipesJson.where((jsonStr) {
      final recipe = Recipe.fromJson(jsonDecode(jsonStr));
      return recipe.id != recipeId;
    }).toList();

    await prefs.setStringList(_savedRecipesKey, updatedList);
  }

  // Get all saved recipes
  static Future<List<Recipe>> getSavedRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRecipesJson = prefs.getStringList(_savedRecipesKey) ?? [];

    return savedRecipesJson
        .map((jsonStr) => Recipe.fromJson(jsonDecode(jsonStr)))
        .toList();
  }

  // Add a cooked meal to history
  static Future<void> addToMealHistory(Recipe recipe, int rating) async {
    final prefs = await SharedPreferences.getInstance();
    final mealHistoryJson = prefs.getStringList(_mealHistoryKey) ?? [];

    final cookedRecipe = Recipe(
      id: recipe.id,
      name: recipe.name,
      ingredients: recipe.ingredients,
      instructions: recipe.instructions,
      cookTime: recipe.cookTime,
      calories: recipe.calories,
      protein: recipe.protein,
      carbs: recipe.carbs,
      fat: recipe.fat,
      matchPercentage: recipe.matchPercentage,
      difficulty: recipe.difficulty,
      mainIngredients: recipe.mainIngredients,
      dateSaved: null,
      dateCooked: DateTime.now(),
      userRating: rating,
    );

    mealHistoryJson.insert(
      0,
      jsonEncode(cookedRecipe.toJson()),
    ); // Newest first
    await prefs.setStringList(_mealHistoryKey, mealHistoryJson);
  }

  // Get meal history
  static Future<List<Recipe>> getMealHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final mealHistoryJson = prefs.getStringList(_mealHistoryKey) ?? [];

    return mealHistoryJson
        .map((jsonStr) => Recipe.fromJson(jsonDecode(jsonStr)))
        .toList();
  }
}
