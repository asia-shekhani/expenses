import 'package:expenses/models/expense.dart';
import 'package:expenses/widget/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExpensesList extends StatelessWidget {
  ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpenses});
  final List<Expense> expenses;
  void Function(Expense) onRemoveExpenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        background: Container(color: Theme.of(ctx).colorScheme.error,),
        
        onDismissed: (direction) {
          onRemoveExpenses(expenses[index]);
        },
        key: ValueKey(expenses[index]),
        child: ExpenseItem(expense: expenses[index]),
      ),
    );
  }
}
