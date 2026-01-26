import 'package:flutter/material.dart';
import 'package:eventry/data/services/api_service.dart';
import 'package:eventry/data/models/ticket.dart';
import 'package:intl/intl.dart';
import 'package:eventry/widgets/ticket_filter.dart';
import 'package:eventry/core/utils/app_color.dart';

import 'package:eventry/features/scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _api = ApiService();
  List<Ticket> _tickets = [];
  bool _isLoading = true;
  // 0 = All, 1 = Unredeemed (default), 2 = Redeemed
  int _filterMode = 1;

  @override
  void initState() {
    super.initState();
    _refreshTickets();
  }

  Future<void> _refreshTickets() async {
    setState(() => _isLoading = true);
    try {
      final data = await _api.getTickets();
      setState(() => _tickets = data);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<Ticket> get _filteredTickets {
    return _tickets.where((t) {
      final isRedeemed = t.redeemedAt != null;
      if (_filterMode == 0) return true;
      if (_filterMode == 1) return !isRedeemed;
      return isRedeemed;
    }).toList();
  }

  Color _statusColor(BuildContext context, String status) {
    final s = status.toLowerCase();
    final scheme = Theme.of(context).colorScheme;
    if (s.contains('unredeem')) return scheme.secondary;
    if (s.contains('redeem')) return scheme.error;
    return scheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... no AppBar; show a simple header instead
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My Ticket',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          TicketFilter(
            selectedIndex: _filterMode,
            onChanged: (i) => setState(() => _filterMode = i),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _refreshTickets,
                    child: _filteredTickets.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 120),
                              Center(
                                child: Text(
                                  'No tickets here — pull to refresh',
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            itemCount: _filteredTickets.length,
                            itemBuilder: (context, index) {
                              final ticket = _filteredTickets[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: _statusColor(
                                      context,
                                      ticket.status,
                                    ).withOpacity(0.15),
                                    child: Icon(
                                      Icons.confirmation_num,
                                      color: _statusColor(
                                        context,
                                        ticket.status,
                                      ),
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ticket.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        DateFormat.yMMMd().add_jm().format(
                                          ticket.createdAt,
                                        ),
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Chip(
                                        label: Text(ticket.status),
                                        backgroundColor: _statusColor(
                                          context,
                                          ticket.status,
                                        ).withOpacity(0.12),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        labelStyle: TextStyle(
                                          color: _statusColor(
                                            context,
                                            ticket.status,
                                          ),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () => _confirmDelete(ticket.id),
                                  ),
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Ticket: ${ticket.name}'),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScannerScreen()),
        ).then((_) => _refreshTickets()),
      ),
    );
  }

  Future<void> _confirmDelete(String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete ticket'),
        content: const Text('Are you sure you want to delete this ticket?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _api.deleteTicket(id);
      await _refreshTickets();
    }
  }
}
