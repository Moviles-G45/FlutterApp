import 'package:finances/presentation/viewmodels/transaction_viewmodel.dart';
import 'package:finances/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finances/config/theme/colors.dart';
import 'package:finances/presentation/ui/widgets/bottom_nav_bar.dart';
import 'package:finances/presentation/ui/widgets/expense_widgets.dart';
import 'package:finances/presentation/viewmodels/track_expense_viewmodel.dart';

class TrackExpenseScreen extends StatelessWidget {
  const TrackExpenseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TrackExpenseViewModel(),
      child: const _TrackExpenseView(),
    );
  }
}

class _TrackExpenseView extends StatefulWidget {
  const _TrackExpenseView({Key? key}) : super(key: key);

  @override
  State<_TrackExpenseView> createState() => _TrackExpenseViewState();
}

class _TrackExpenseViewState extends State<_TrackExpenseView> {
  final GlobalKey<ExpenseDatePickerState> datePickerKey = GlobalKey();
  final GlobalKey<CategoriesInputFieldState> categoryPickerKey = GlobalKey();

  Future<void> _onSavePressed(TrackExpenseViewModel viewModel) async {
  FocusScope.of(context).unfocus();
  final notificationService = Provider.of<NotificationService>(context, listen: false);
  final error = await viewModel.saveExpense(notificationService:  notificationService);


  if (error != null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  } else {
    datePickerKey.currentState?.resetDate();
    categoryPickerKey.currentState?.resetCategory();

    // Recarga de transacciones
    final transactionVM = Provider.of<TransactionViewModel>(context, listen: false);
    transactionVM.fetchTransactions();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Transacción guardada exitosamente")),
    );
  }
}


  TrackExpenseViewModel? _viewModel;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  _viewModel ??= Provider.of<TrackExpenseViewModel>(context);
}

@override
void dispose() {
  _viewModel?.disposeControllers(); 
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TrackExpenseViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expenses", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.cardBackground),
          onPressed: () => Navigator.pushNamed(context, '/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.cardBackground),
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          ),
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const ExpenseLabel(text: "Date"),
                ExpenseDatePicker(
                  key: datePickerKey,
                  hintText: "Select a date",
                  onDateChanged: viewModel.setDate,
                ),
                const SizedBox(height: 10),
                const ExpenseLabel(text: "Category"),
                CategoriesInputField(
                  key: categoryPickerKey,
                  placeholder: 'Select the category',
                  apiUrl: 'http://localhost:8000/categories',
                  onCategoryChanged: viewModel.setCategory,
                ),
                const SizedBox(height: 10),
                const ExpenseLabel(text: "Amount"),
                ExpenseInputField(
                  placeholder: "\$26.00",
                  controller: viewModel.amountController,
                  icon: Icons.attach_money,
                ),
                const SizedBox(height: 10),
                const ExpenseLabel(text: "Enter Message"),
                ExpenseMessageBox(controller: viewModel.descriptionController),
                const SizedBox(height: 20),
                SaveExpenseButton(onPressed: () => _onSavePressed(viewModel)),
                const SizedBox(height: 150),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}