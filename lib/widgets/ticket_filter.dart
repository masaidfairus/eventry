import 'package:flutter/material.dart';

class TicketFilter extends StatelessWidget {
  final bool showRedeemed;
  final ValueChanged<bool> onChanged;

  const TicketFilter({
    super.key,
    required this.showRedeemed,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text('Unredeemed'),
          selected: !showRedeemed,
          onSelected: (_) => onChanged(false),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text('Redeemed'),
          selected: showRedeemed,
          onSelected: (_) => onChanged(true),
        ),
      ],
    );
  }
}
