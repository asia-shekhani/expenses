import 'package:expenses/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final formatter = DateFormat.yMd();
  final titleController = TextEditingController();
  final amuontController = TextEditingController();
  Category selectedCategory = Category.leisure;
  DateTime? selectedDate;
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(
            'Invalid Input',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Please make sure Title, Amount, And date is set correctley',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Okay',
              ),
            ),
          ],
        ),
      );
    } else {
      //showing error message if the title and amount is empty
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Invalid Input',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Please make sure Title, Amount, And date is set correctley',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Okay',
              ),
            ),
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(amuontController.text);
    bool amountIsValid = enteredAmount == null || enteredAmount <= 0;
    if (titleController.text.trim().isEmpty ||
        amountIsValid ||
        selectedDate == null) {
      _showDialog();
      return;
    }
    widget.onAddExpense(Expense(
        title: titleController.text,
        amount: enteredAmount,
        date: selectedDate!,
        category: selectedCategory));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    amuontController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constrains) {
      final width = constrains.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, keyboardSpace + 20, 20, 20),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: titleController,
                          maxLength: 100,
                          decoration:
                              const InputDecoration(label: Text('Title')),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: amuontController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              prefixText: '\$ ', label: Text('Amount')),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: titleController,
                    maxLength: 100,
                    decoration: const InputDecoration(label: Text('Title')),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // ignore: unrelated_type_equality_checks
                            Text(
                              selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(selectedDate!),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                              onPressed: _presentDatePicker,
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: amuontController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              prefixText: '\$ ', label: Text('Amount')),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // ignore: unrelated_type_equality_checks
                            Text(
                              selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(selectedDate!),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                              onPressed: _presentDatePicker,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 30,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: const Text('Save Expense')),
                      const Spacer(),
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'))
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                        value: selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save Expense'),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      )
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
