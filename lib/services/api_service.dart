import 'package:dio/dio.dart';
import '../models/recipe.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://dummyjson.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  Future<List<Recipe>> fetchRecipes() async {
    try {
      final response = await _dio.get('/recipes');
      if (response.statusCode == 200) {
        final data = response.data;
        return (data['recipes'] as List)
            .map((json) => Recipe.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Recipe> fetchRecipeDetails(int id) async {
    try {
      final response = await _dio.get('/recipes/$id');
      if (response.statusCode == 200) {
        return Recipe.fromJson(response.data);
      } else {
        throw Exception('Failed to load recipe: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
