import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';

export '../models/recipe.dart';

class RecipeViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRecipes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _recipes = await _apiService.fetchRecipes();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Recipe? _selectedRecipe;
  Recipe? get selectedRecipe => _selectedRecipe;

  Future<void> fetchRecipeDetails(int id) async {
    _isLoading = true;
    _selectedRecipe = null;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedRecipe = await _apiService.fetchRecipeDetails(id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
