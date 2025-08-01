import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';

//issue here
const kInitialFilters = {
  Filter.glutenFree : false,
  Filter.lactoseFree : false,
  Filter.vegetarian :false,
  Filter.vegan : false,
};

class TabsScreen extends StatefulWidget{
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState(){
    return _TabsScreenState();
  }
}

class  _TabsScreenState extends State<TabsScreen>{
   int _selectPageIndex = 0;
   final List<Meal> _favoriteMeals = [];
   Map<Filter,bool> _selectedFilters = kInitialFilters;

   void _showInfoMessage(String message){
     ScaffoldMessenger.of(context).clearSnackBars();
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
           content: Text(message)),
     );
   }



   void _toggleMealFavoriteStatus(Meal meal){
     final isExisting = _favoriteMeals.contains(meal);
     if (isExisting){
       setState(() {
         _favoriteMeals.remove(meal);
       });
       _showInfoMessage('Meal is no longer as favorite.');
     } else {
       setState(() {
         _favoriteMeals.add(meal);
       });
       _showInfoMessage('Marked as a favorite!');
     }
   }
   void _selectPage(int index){
     setState(() {
       _selectPageIndex = index;
     });
   }
   //issue here
   void _setScreen(String identifier) async{
     Navigator.of(context).pop();
     if(identifier == 'filters'){
       final result = await Navigator.of(context).push<Map<Filter,bool>>(MaterialPageRoute(
           builder: (ctx) => FiltersScreen(
             currentFilters: _selectedFilters,
           ),
       ),
       );
       setState(() {
         _selectedFilters = result ?? kInitialFilters;
       });
     }
   }

  @override
  Widget build(BuildContext context) {
     final availableMeals = dummyMeals.where((meal) {
       if(_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree){
         return false;
       }
       if(_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree){
         return false;
       }
       if(_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian){
         return false;
       }
       if(_selectedFilters[Filter.vegan]! && !meal.isVegan){
         return false;
       }
       return true;
     }).toList();

     Widget activePage =  CategoriesScreen(
       onToggleFavorites: _toggleMealFavoriteStatus,
       availableMeals: availableMeals,
     );
     var activePageTitle = 'Categories';
     if(_selectPageIndex == 1){
       activePage = MealsScreen(meals: _favoriteMeals,
         onToggleFavorites: _toggleMealFavoriteStatus,);
       activePageTitle = 'Your Favorites';
     }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen,),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectPageIndex,
        items: [
          BottomNavigationBarItem(icon:Icon(Icons.set_meal),label: 'Categories' ),
          BottomNavigationBarItem(icon:Icon(Icons.star),label: 'Favorites' ),
        ]),

    );
  }
}
