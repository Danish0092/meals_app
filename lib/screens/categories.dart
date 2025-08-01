import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key,
    required this.onToggleFavorites,
    required this.availableMeals,
  });

  final void Function(Meal meal) onToggleFavorites;
  final List<Meal> availableMeals;

  void _selectCategory(BuildContext context, Category category){
    final filteredMeals = availableMeals.where((meal) =>
        meal.categories.contains(category.id)).toList();

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (ctx) => MealsScreen(
              title: category.title,
              meals: filteredMeals,
            onToggleFavorites: onToggleFavorites,
          )),
    );
  }
  @override
  Widget build(BuildContext context) {
    return GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      padding: EdgeInsets.all(24) ,
      children: [
        for (final category in availableCategories)
        CategoryGridItem(category: category,
        onSelectCategory: (){
          _selectCategory(context,category);
        },
        )
      ],
      );


  }
}