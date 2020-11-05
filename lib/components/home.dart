import 'package:flutter/material.dart';

import 'dart:math';

import './transaction_form.dart';
import './transaction_list.dart';
import '../models/transaction.dart';
import './chart.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Transaction> _transaction = [];
  bool _triggerChart = false;

  List<Transaction> get _recentTransactions {
    return _transaction.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransation(int id, String title, double value, DateTime date, int op) {
    var newTransaction = Transaction(
      id: op == 1 ? id : Random().nextInt(1000),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      switch (op) {
        case 0:
          _transaction.add(newTransaction);
          break;
        case 1:
          for (var item in _transaction) {
            if (item.id == id) {
              item.id = newTransaction.id;
              item.title = newTransaction.title;
              item.value = newTransaction.value;
              item.date = newTransaction.date;
            }
          }
          break;
        default:
      }
    });

    Navigator.of(context).pop();
  }

  _editTransation(int id) {
    Transaction a;
    for (var item in _transaction) {
      if (item.id == id) {
        a = item;
      }
    }

    if (a != null) {
      _openTransactionFormModal(context, a);
    }
  }

  _openTransactionFormModal(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return transaction == null
            ? TransactionForm(_addTransation, null)
            : TransactionForm(_addTransation, transaction);
      },
    );
  }

  _removeTransaction(int id) {
    setState(() {
      _transaction.removeWhere((tr) => tr.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool _modePaisagem =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text("Despesas Pessoais"),
      actions: [
        if (_modePaisagem)
          IconButton(
            icon: Icon(_triggerChart ? Icons.list : Icons.insert_chart),
            onPressed: () {
              setState(() {
                _triggerChart = !_triggerChart;
              });
            },
          ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _openTransactionFormModal(context, null),
        ),
      ],
    );

    final heightDispositivo = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_triggerChart || !_modePaisagem)
              Container(
                height: heightDispositivo * (_modePaisagem ? 0.7 : 0.3),
                child: Chart(_recentTransactions),
              ),
            if (!_triggerChart || !_modePaisagem)
              Container(
                height: heightDispositivo * 0.7,
                child: TransactionList(
                    _transaction, _removeTransaction, _editTransation),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context, null),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
