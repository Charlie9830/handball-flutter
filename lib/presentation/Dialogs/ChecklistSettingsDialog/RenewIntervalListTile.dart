import 'package:flutter/material.dart';

class RenewIntervalListTile extends StatefulWidget {
  final int value;
  final bool enabled;
  final onChange;

  RenewIntervalListTile({
    this.value = 1,
    this.enabled,
    this.onChange,
  });

  @override
  _RenewIntervalListTileState createState() => _RenewIntervalListTileState();
}

class _RenewIntervalListTileState extends State<RenewIntervalListTile> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toRadixString(10));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        enabled: widget.enabled,
        leading: Icon(Icons.refresh),
        title: TextField(
          enabled: widget.enabled,
          controller: _controller,
          keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
          decoration: InputDecoration(
            labelText: 'Then renew every',
            suffix: Text('days'),
            hintText: '1',
            errorText: _validateInput(_controller.text),
          ),
          onSubmitted: (value) { widget.onChange(int.parse(value)); }
        ));
  }

  String _validateInput(String input) {
    if (input == null || input == '') {
      return 'You must enter a value';
    }

    var parsedValue = int.tryParse(input, radix: 10);
    if (parsedValue == null) {
      return 'An error occured';
    }

    if (parsedValue <= 0) {
      return 'Must be greater than zero';
    }

    return null;
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }
}
