import 'package:flutter/material.dart';
import 'package:eventry/data/services/api_service.dart';
import 'package:eventry/data/models/ticket.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event Scanner')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshTickets,
              child: ListView.builder(
                itemCount: _tickets.length,
                itemBuilder: (context, index) {
                  final ticket = _tickets[index];
                  return ListTile(
                    title: Text(ticket.name),
                    subtitle: Text(ticket.status),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteTicket(ticket.id),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.qr_code_scanner),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ScannerScreen()),
        ).then((_) => _refreshTickets()), // Refresh when coming back!
      ),
    );
  }

  Future<void> _deleteTicket(String id) async {
    await _api.deleteTicket(id);
    _refreshTickets(); // Simple way: fetch everything again
    // Or: setState(() => _tickets.removeWhere((t) => t.id == id));
  }
}

