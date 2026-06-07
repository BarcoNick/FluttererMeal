import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/recipe_viewmodel.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      context.read<RecipeViewModel>().fetchRecipeDetails(widget.recipeId)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RecipeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.selectedRecipe == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final recipe = viewModel.selectedRecipe;
          if (recipe == null) {
            return const Center(child: Text('Recipe not found'));
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 350,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(recipe.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                    ),
                  ),
                  background: Hero(
                    tag: 'recipe-image-${recipe.id}',
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(recipe.image, fit: BoxFit.cover),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black54],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildQuickInfo(recipe),
                      const SizedBox(height: 30),
                      const Text('Ingredients', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: recipe.ingredients.map((ing) => _buildSquareIngredient(ing)).toList(),
                      ),
                      const SizedBox(height: 30),
                      const Text('Instructions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ...recipe.instructions.take(2).toList().asMap().entries.map((entry) => _buildStepRow(entry.key + 1, entry.value)),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: _isExpanded
                          ? Column(
                              children: recipe.instructions.skip(2).toList().asMap().entries.map((entry) {
                                return _buildStepRow(entry.key + 3, entry.value);
                              }).toList(),
                            )
                          : const SizedBox.shrink(),
                      ),

                      Center(
                        child: TextButton.icon(
                          onPressed: () => setState(() => _isExpanded = !_isExpanded),
                          icon: Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                          label: Text(_isExpanded ? 'Read Less' : 'Read More'),
                          style: TextButton.styleFrom(foregroundColor: Colors.orange),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickInfo(Recipe recipe) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _infoCard(Icons.access_time, '${recipe.prepTimeMinutes + recipe.cookTimeMinutes} min'),
        _infoCard(Icons.restaurant, '${recipe.servings} Servings'),
        _infoCard(Icons.bolt, '${recipe.caloriesPerServing} kcal'),
      ],
    );
  }

  Widget _infoCard(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.brown, size: 24),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildSquareIngredient(String ingredient) {
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Text(
          ingredient,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildStepRow(int step, String instruction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$step.', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
          const SizedBox(width: 12),
          Expanded(child: Text(instruction, style: const TextStyle(fontSize: 16, height: 1.5))),
        ],
      ),
    );
  }
}
