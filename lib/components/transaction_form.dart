import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionForm extends StatefulWidget {
  final void Function(int, String, double, DateTime, int) onSubmit;
  final Transaction tr;

  TransactionForm(this.onSubmit, this.tr);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  var titleController = TextEditingController();
  var valueController = TextEditingController();
  DateTime selectDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(
        text: widget.tr != null ? widget.tr.title.toString() : '');
    valueController = TextEditingController(
        text: widget.tr != null ? widget.tr.value.toStringAsFixed(2) : '');
    selectDate = widget.tr != null ? widget.tr.date : DateTime.now();
  }

  _submit({int id, int op}) {
    final title = titleController.text;
    double value = 0.0;
    if (valueController.text.isNotEmpty) {
      value = double.parse(valueController.text) ?? 0.0;
    }

    if (title.isEmpty || value <= 0 || selectDate == null) {
      return;
    }

    widget.onSubmit(id, title, value, selectDate, op);
  }

  _showDatePicker(DateTime dateInit) {
    showDatePicker(
      locale: Locale("pt", "BR"),
      context: context,
      initialDate: dateInit == null ? DateTime.now() : dateInit,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickerDate) {
      if (pickerDate == null) return;

      setState(() {
        selectDate = pickerDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Titulo'),
              controller: titleController,
              onSubmitted: (_) => widget.tr != null
                  ? _submit(id: widget.tr.id, op: 1)
                  : _submit(id: null, op: 0),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Valor (R\$)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: valueController,
              onSubmitted: (_) => widget.tr != null
                  ? _submit(id: widget.tr.id, op: 1)
                  : _submit(id: null, op: 0),
            ),
            Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    selectDate == null
                        ? 'Nenhuma data selecionada!'
                        : 'Data selecionada: ${DateFormat('dd/MM/y').format(selectDate)}',
                  ),
                  Container(
                    child: FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(widget.tr != null
                          ? 'Alterar Data'
                          : 'Selecionar Data'),
                      onPressed: () => widget.tr != null
                          ? _showDatePicker(widget.tr.date)
                          : _showDatePicker(null),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 1),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.purple[50],
                  width: 2,
                ),
              ),
              child: FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text(
                  widget.tr != null ? "Salvar" : "Cadastrar",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => widget.tr != null
                    ? _submit(id: widget.tr.id, op: 1)
                    : _submit(id: null, op: 0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
