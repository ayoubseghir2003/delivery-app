import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/api_service.dart';

class OrderDetailPage extends StatefulWidget {
  final Order order;
  const OrderDetailPage({super.key, required this.order});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool _busy = false;
  String? _error;
  late Order _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  Future<void> _assign() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final updated = await ApiService.assignOrder(_order.id);
      setState(() {
        _order = updated;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _busy = false;
      });
    }
  }

  Future<void> _updateStatus(String status) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final updated = await ApiService.updateStatus(_order.id, status);
      setState(() {
        _order = updated;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Commande #${_order.id}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Client: ${_order.client}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Téléphone: ${_order.clientPhone}'),
              const SizedBox(height: 4),
              Text('Adresse: ${_order.address}'),
              const Divider(height: 24),
              const Text('Articles:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._order.items.map((i) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(i.name),
                    trailing: Text(
                        '${i.price} DZA${i.quantity != null ? ' × ${i.quantity}' : ''}'),
                  )),
              const Divider(height: 24),
              Text('Total: ${_order.total} DZA (+ livraison ${_order.deliveryPrice} DZA)'),
              const SizedBox(height: 8),
              Text('Statut: ${_order.status}'),
              if (_order.agentName != null)
                Text('Assignée à: ${_order.agentName}'),
              const SizedBox(height: 12),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),

              // Bouton accepter
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          _busy || _order.status != 'pending' ? null : _assign,
                      icon: const Icon(Icons.assignment_turned_in),
                      label: const Text('Accepter'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Boutons de statut
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _StatusBtn(
                      label: 'Prête',
                      status: 'ready',
                      onTap: _updateStatus,
                      enabled: _order.status == 'assigned' ||
                          _order.status == 'ready'),
                  _StatusBtn(
                      label: 'En route',
                      status: 'in_transit',
                      onTap: _updateStatus,
                      enabled: _order.status == 'ready' ||
                          _order.status == 'in_transit'),
                  _StatusBtn(
                      label: 'Arrivée',
                      status: 'arrived',
                      onTap: _updateStatus,
                      enabled: _order.status == 'in_transit' ||
                          _order.status == 'arrived'),
                  _StatusBtn(
                      label: 'Livrée',
                      status: 'delivered',
                      onTap: _updateStatus,
                      enabled: _order.status == 'arrived' ||
                          _order.status == 'delivered'),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBtn extends StatelessWidget {
  final String label;
  final String status;
  final void Function(String) onTap;
  final bool enabled;
  const _StatusBtn(
      {required this.label,
      required this.status,
      required this.onTap,
      required this.enabled});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? () => onTap(status) : null,
      child: Text(label),
    );
  }
}
