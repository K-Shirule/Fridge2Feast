import 'package:flutter/material.dart';

class Recipe {
  final String id;
  final String name;
  final List<String> ingredients;
  final List<String> instructions;
  final int cookTime; // minutes
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int matchPercentage;
  final String difficulty;
  final List<String> mainIngredients;
  final DateTime? dateSaved;
  final DateTime? dateCooked;
  final int? userRating;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.cookTime,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.matchPercentage,
    required this.difficulty,
    required this.mainIngredients,
    this.dateSaved,
    this.dateCooked,
    this.userRating,
  });

  // For demo/sample recipes
  factory Recipe.sample({
    required String name,
    required List<String> ingredients,
    required List<String> instructions,
    required int cookTime,
    required int calories,
    required int matchPercentage,
  }) {
    return Recipe(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      ingredients: ingredients,
      instructions: instructions,
      cookTime: cookTime,
      calories: calories,
      protein: (calories * 0.15 / 4).round(),
      carbs: (calories * 0.55 / 4).round(),
      fat: (calories * 0.30 / 9).round(),
      matchPercentage: matchPercentage,
      difficulty: cookTime <= 20
          ? 'Easy'
          : (cookTime <= 45 ? 'Medium' : 'Hard'),
      mainIngredients: ingredients.take(3).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients,
      'instructions': instructions,
      'cookTime': cookTime,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'matchPercentage': matchPercentage,
      'difficulty': difficulty,
      'mainIngredients': mainIngredients,
      'dateSaved': dateSaved?.toIso8601String(),
      'dateCooked': dateCooked?.toIso8601String(),
      'userRating': userRating,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
      cookTime: json['cookTime'],
      calories: json['calories'],
      protein: json['protein'],
      carbs: json['carbs'],
      fat: json['fat'],
      matchPercentage: json['matchPercentage'],
      difficulty: json['difficulty'],
      mainIngredients: List<String>.from(json['mainIngredients']),
      dateSaved: json['dateSaved'] != null
          ? DateTime.parse(json['dateSaved'])
          : null,
      dateCooked: json['dateCooked'] != null
          ? DateTime.parse(json['dateCooked'])
          : null,
      userRating: json['userRating'],
    );
  }
}
