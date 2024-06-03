import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/widgets/main_drawer.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}
var kinitialValues = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TabsScreen();
  }
}

class _TabsScreen extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedFilters = kinitialValues;
  final TextEditingController _searchController = TextEditingController();
  List<Meal> _resultMeals = [];
  bool _isLoading = false;
  List<Meal> _filteredMeals = [];
  List<Meal> _searchedForMeals = [];

  @override
  void initState() {
    super.initState();
     _searchedForMeals =_filteredMeals  =_resultMeals = dummyMeals;
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMeals() {
    setState(() {

      _filteredMeals = dummyMeals.where((meal) {
        if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) return false;
        if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) return false;
        if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) return false;
        if (_selectedFilters[Filter.vegan]! && !meal.isVegan) return false;
        return true;
      }).toList();
      _resultMeals = _filteredMeals.where((meal) => _searchedForMeals.contains(meal)).toList();
    });

  }

  void _performSearch() {
    setState(() {
      _isLoading = true;
      _searchedForMeals = dummyMeals.where((meal) {
        if(meal.title.toLowerCase().contains(_searchController.text.toLowerCase())) return true;
        return false;
      }).toList();
      _resultMeals = _searchedForMeals.where((meal) => _filteredMeals.contains(meal)).toList();
      _isLoading = false;
    });
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
        _showInfoMessage('Meal is no longer a Favorite');
      });
    } else
      setState(() {
        _favoriteMeals.add(meal);
        _showInfoMessage('Marked as a Favorite!');
      });
  } //لازم اضيفها للتطبيق السياحي عشان لما يشيل الشخص اختياره من المفضلة مباشرة ينشال

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CategoriesScreen(
      onToggleFavorites: _toggleMealFavoriteStatus,
      availableMeals: _resultMeals,
    );

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorites: _toggleMealFavoriteStatus,
      );
    }
    else if(_searchController.text.isNotEmpty){
      activePage = MealsScreen(
        meals: _resultMeals,
        onToggleFavorites: _toggleMealFavoriteStatus,
      );
    }
    return Scaffold(
      appBar: AppBar(
        //title: Text(activePageTitle),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: (_selectedPageIndex == 1) ? const Text("Your Favourite Meals") :
        TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white54),
            //border: InputBorder.none,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
            ),
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.filter_6_sharp),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SwitchListTile(
                        value: _selectedFilters[Filter.glutenFree]!,
                        onChanged: (bool isChecked) {
                          setState(() {
                            _selectedFilters[Filter.glutenFree] = isChecked;
                            _filterMeals();
                          });
                        },
                        title: Text(
                          'Gluten-Free',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                        subtitle: Text(
                          'Only Include Gluten-Free meals',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                        activeColor: Theme.of(context).colorScheme.tertiary,
                        contentPadding:
                            const EdgeInsets.only(left: 34, right: 22),
                      );
                    },
                  ),
                ),
                PopupMenuItem(
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SwitchListTile(
                        value: _selectedFilters[Filter.lactoseFree]!,
                        onChanged: (bool isChecked) {
                          setState(() {
                            _selectedFilters[Filter.lactoseFree] = isChecked;
                            _filterMeals();
                          });
                        },
                        title: Text(
                          'Lactose-Free',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                        subtitle: Text(
                          'Only Include Lactose-Free meals',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                        activeColor: Theme.of(context).colorScheme.tertiary,
                        contentPadding:
                            const EdgeInsets.only(left: 34, right: 22),
                      );
                    },
                  ),
                ),
                PopupMenuItem(
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SwitchListTile(
                        value: _selectedFilters[Filter.vegetarian]!,
                        onChanged: (bool isChecked) {
                          setState(() {
                            _selectedFilters[Filter.vegetarian] = isChecked;
                            _filterMeals();
                          });
                        },
                        title: Text(
                          'Vegetarian',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                        subtitle: Text(
                          'Only Include Vegetarian meals',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                        activeColor: Theme.of(context).colorScheme.tertiary,
                        contentPadding:
                            const EdgeInsets.only(left: 34, right: 22),
                      );
                    },
                  ),
                ),
                PopupMenuItem(
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SwitchListTile(
                        value: _selectedFilters[Filter.vegan]!,
                        onChanged: (bool isChecked) {
                          setState(() {
                            _selectedFilters[Filter.vegan] = isChecked;
                            _filterMeals();
                          });
                        },
                        title: Text(
                          'Vegan',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                        subtitle: Text(
                          'Only Include Vegan meals',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                        activeColor: Theme.of(context).colorScheme.tertiary,
                        contentPadding:
                            const EdgeInsets.only(left: 34, right: 22),
                      );
                    },
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
