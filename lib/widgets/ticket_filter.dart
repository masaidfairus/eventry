import 'package:flutter/material.dart';
// import '../core/utils/app_color.dart';

class TicketFilter extends StatelessWidget {
  // 0 = All, 1 = Unredeemed, 2 = Redeemed
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const TicketFilter({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 8,
            runSpacing: 6,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: selectedIndex == 0,
                selectedColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).chipTheme.backgroundColor,
                labelStyle: TextStyle(
                  color: selectedIndex == 0
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
                onSelected: (selected) {
                  if (selected) onChanged(0);
                },
              ),
              ChoiceChip(
                label: const Text('Unredeemed'),
                selected: selectedIndex == 1,
                selectedColor: Theme.of(context).colorScheme.secondary,
                backgroundColor: Theme.of(context).chipTheme.backgroundColor,
                labelStyle: TextStyle(
                  color: selectedIndex == 1
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
                onSelected: (selected) {
                  if (selected) onChanged(1);
                },
              ),
              ChoiceChip(
                label: const Text('Redeemed'),
                selected: selectedIndex == 2,
                selectedColor: Theme.of(context).colorScheme.error,
                backgroundColor: Theme.of(context).chipTheme.backgroundColor,
                labelStyle: TextStyle(
                  color: selectedIndex == 2
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
                onSelected: (selected) {
                  if (selected) onChanged(2);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
