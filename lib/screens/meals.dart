import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meal_details.dart';
import 'package:meals/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget{
  const MealsScreen({super.key,
    this.title,
    required this.meals,
    required this.onToggleFavorites,
  });

  final String? title;
  final List<Meal> meals;
  final void Function(Meal meal) onToggleFavorites;

  void selectMeal(BuildContext context, Meal meal){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => MealDetailsScreen(
          meal: meal,
        onToggleFavorites: onToggleFavorites,
      ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content =  ListView.builder(
        itemCount: meals.length,
        itemBuilder: (ctx,index) => MealItem(meal: meals[index],
          onSelectMeal: selectMeal,
        )
    );
    if(meals.isEmpty){
      content = Center(
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('OMG.....nothing here!',style: Theme.of(context).textTheme.headlineLarge!.copyWith(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        ),
        SizedBox(height: 16,),
        Text(
          'Try selecting a different category!',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
    ),
    )
    ],
      ),
      );
    }
    if(title == null){
      return content;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: content,
    );
  }
}
