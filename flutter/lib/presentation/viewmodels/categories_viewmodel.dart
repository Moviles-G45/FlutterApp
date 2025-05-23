import 'dart:convert';
import 'package:finances/data/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesViewModel extends ChangeNotifier {
  List<CategoryModel> _categories = [];
  bool _isOffline = false;
  bool _isLoading = true;

  List<CategoryModel> get categories => _categories;
  bool get isOffline => _isOffline;
  bool get isLoading => _isLoading;

  CategoriesViewModel() {
    loadCategories();
  }

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('cachedCategories');

      if (data != null) {
        final Map<String, dynamic> decoded = json.decode(data);
        _categories = decoded.entries
            .map((entry) => CategoryModel(id: int.parse(entry.key), name: entry.value))
            .toList();
      }
    } catch (e) {
      _isOffline = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  IconData getIconForCategory(String label) {
    switch (label.toLowerCase()) {
      case 'salary':
      case 'freelance':
      case 'investments':
      case 'bonuses':
        return Icons.attach_money;
      case 'travel':
        return Icons.airplane_ticket;
      case 'health':
        return Icons.health_and_safety;
      case 'utilities':
        return Icons.check_box;
      case 'restaurants':
        return Icons.food_bank;
      case 'transport':
        return Icons.directions_bus;
      case 'groceries':
      case 'personal shopping':
        return Icons.shopping_bag;
      case 'rent':
      case 'housing':
        return Icons.house;
      case 'savings':
        return Icons.savings;
      case 'entertainment':
        return Icons.movie;
      default:
        return Icons.add;
    }
  }
}
