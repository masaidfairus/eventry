import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:uuid/uuid.dart';
import '../data/services/api_service.dart';

class GenerateTicketScreen extends StatefulWidget {
  const GenerateTicketScreen({super.key});

  @override
  State<GenerateTicketScreen> createState() => _GenerateTicketScreenState();
}

class _GenerateTicketScreenState extends State<GenerateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _descCtl = TextEditingController();
  String? _generatedPayload;
  bool _isLoading = false;
  final ApiService _api = ApiService();

  Future<void> _generate() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    try {
      // call API to create ticket (backend expects name)
      final name = _nameCtl.text.trim();
      await _api.addTicket(name);

      // create payload for QR after successful API add
      final id = const Uuid().v4();
      final payload = {
        'id': id,
        'name': name,
        'description': _descCtl.text.trim(),
        'createdAt': DateTime.now().toIso8601String(),
      };
      setState(() {
        _generatedPayload = payload.toString();
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket created successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create ticket: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _descCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate Ticket')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameCtl,
                    decoration: const InputDecoration(labelText: 'Ticket name'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Enter a name' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descCtl,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _generate,
                      child: _isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Generate QR'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_generatedPayload != null) ...[
              Text('Ticket QR', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BarcodeWidget(
                        barcode: Barcode.qrCode(),
                        data: _generatedPayload!,
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(height: 12),
                      SelectableText(_generatedPayload!),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
