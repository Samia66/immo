import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/models/payment_model.dart';
import '../../../../../core/network/api_exception.dart';
import '../../../../../core/utils/formatters.dart';
import '../../providers/manager_providers.dart';

/// "Record payment" action - `POST /payments/:id/record`. Pre-fills the
/// amount with the remaining balance due; `method` and `paidAt` are required
/// by the real `RecordPaymentDto`, `transactionRef` is optional.
class RecordPaymentSheet extends ConsumerStatefulWidget {
  const RecordPaymentSheet({super.key, required this.payment});

  final PaymentModel payment;

  @override
  ConsumerState<RecordPaymentSheet> createState() => _RecordPaymentSheetState();
}

class _RecordPaymentSheetState extends ConsumerState<RecordPaymentSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  final _transactionRefController = TextEditingController();

  PaymentMethod _method = PaymentMethod.ESPECES;
  DateTime _paidAt = DateTime.now();
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.payment.balanceDue.toString());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _transactionRefController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _paidAt,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _paidAt = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref.read(managerPaymentsRepositoryProvider).record(
            widget.payment.id,
            amountPaid: num.parse(_amountController.text.trim()),
            method: _method,
            paidAt: _paidAt,
            transactionRef: _transactionRefController.text.trim(),
          );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Une erreur est survenue.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Enregistrer un paiement', style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text('Échéance ${Formatters.date(widget.payment.dueDate)}',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
              const SizedBox(height: 16),
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(_error!, style: TextStyle(color: theme.colorScheme.onErrorContainer)),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Montant payé'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Montant requis';
                  return num.tryParse(value.trim()) == null ? 'Montant invalide' : null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PaymentMethod>(
                initialValue: _method,
                decoration: const InputDecoration(labelText: 'Méthode'),
                items: [
                  for (final m in PaymentMethod.values)
                    DropdownMenuItem(value: m, child: Text(m.label)),
                ],
                onChanged: (value) => setState(() => _method = value ?? _method),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration:
                      const InputDecoration(labelText: 'Date de paiement', prefixIcon: Icon(Icons.event_outlined)),
                  child: Text(Formatters.date(_paidAt)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _transactionRefController,
                decoration: const InputDecoration(labelText: 'Référence de transaction (facultatif)'),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
                    : const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
