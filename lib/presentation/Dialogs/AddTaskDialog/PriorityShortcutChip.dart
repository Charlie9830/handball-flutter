import 'package:flutter/material.dart';

class PriorityShortcutChip extends StatefulWidget {
  final bool isHighPriority;
  final onChanged;

  PriorityShortcutChip({
    this.isHighPriority,
    this.onChanged,
  });

  @override
  _PriorityShortcutChipState createState() => _PriorityShortcutChipState();
}

class _PriorityShortcutChipState extends State<PriorityShortcutChip> {

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(
        widget.isHighPriority ? Icons.star : Icons.star_border,
        size: 18,
      ),
      label: Text('Importance'),
      onPressed: () => _submit(!widget.isHighPriority)
    );
  }
  
  void _submit(bool value) {
    widget.onChanged(value);
  }
}
