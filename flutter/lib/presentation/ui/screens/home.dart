import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finances/config/theme/colors.dart';
import '../../../services/auth_service.dart';
import '../../viewmodels/expenses_viewmodel.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../viewmodels/transaction_viewmodel.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets_home/balance_card.dart';
import '../widgets_home/expenses_card.dart';
import '../widgets_home/transaction_filter_bar.dart';
import '../widgets_home/transaction_list.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (!mounted) return;
    
    final homeVM = context.read<HomeViewModel>();
    final expensesVM = context.read<ExpensesViewModel>();
    final transactionVM = context.read<TransactionViewModel>();

    

    await Future.wait([
      homeVM.fetchBalance(),
      expensesVM.fetchExpenses(),
      _fetchAndCacheCategories()
    ]);

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);

    transactionVM.setDateRange(start, end);
  });
}

  Future<void> _fetchAndCacheCategories() async {
    try {
      final response = await http.get(Uri.parse('https://fastapi-service-185169107324.us-central1.run.app/categories'));

      if (response.statusCode == 200) {
        final List<dynamic> categories = json.decode(response.body);

        // Guardar categorías como id => nombre
        final Map<String, String> categoryMap = {
          for (var cat in categories) cat['id'].toString(): cat['name']
        };

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cachedCategories', json.encode(categoryMap));
      } else {
        debugPrint("Error al obtener categorías: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error al cachear categorías: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final homeVM = Provider.of<HomeViewModel>(context);
    final isOffline = homeVM.isOffline;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await AuthService().signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Signed out successfully")),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (isOffline)
              Container(
                color: Colors.orange,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                child: Row(
                  children: const [
                    Icon(Icons.wifi_off, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "You're offline. Showing last known data.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: isPortrait
                  ? _buildPortraitLayout(context)
                  : _buildLandscapeLayout(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BalanceCard(),
            const SizedBox(height: 40),
          ],
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.22,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                ExpensesCard(),
                const SizedBox(height: 10),
                const TransactionFilterBar(),
                const SizedBox(height: 10),
                TransactionList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  BalanceCard(),
                  const SizedBox(height: 12),
                  ExpensesCard(),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  const TransactionFilterBar(),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: TransactionList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}