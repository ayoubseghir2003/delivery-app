class OrderItem {
  final String name;
  final num price;
  final int quantity;

  OrderItem({
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name']?.toString() ?? '',
      price: (json['price'] is num)
          ? json['price'] as num
          : num.tryParse(json['price'].toString()) ?? 0,
      quantity: (json['quantity'] is int)
          ? json['quantity'] as int
          : int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'quantity': quantity,
      };

  OrderItem copyWith({String? name, num? price, int? quantity}) {
    return OrderItem(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}

class Order {
  final String id;
  final String client;
  final String clientPhone;
  final String address;
  final List<OrderItem> items;
  final num total;
  final num deliveryPrice;
  final String status; // pending | assigned | ready | in_transit | arrived | delivered
  final String? deliveryAgent;
  final String? agentName;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.client,
    required this.clientPhone,
    required this.address,
    required this.items,
    required this.total,
    required this.deliveryPrice,
    required this.status,
    this.deliveryAgent,
    this.agentName,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List<dynamic>? ?? []);
    return Order(
      id: json['id']?.toString() ?? '',
      client: json['client']?.toString() ?? '',
      clientPhone: json['clientPhone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      items: itemsJson.map((e) => OrderItem.fromJson(e)).toList(),
      total: (json['total'] is num)
          ? json['total'] as num
          : num.tryParse(json['total']?.toString() ?? '0') ?? 0,
      deliveryPrice: (json['deliveryPrice'] is num)
          ? json['deliveryPrice'] as num
          : num.tryParse(json['deliveryPrice']?.toString() ?? '0') ?? 0,
      status: json['status']?.toString() ?? 'pending',
      deliveryAgent: json['deliveryAgent']?.toString(),
      agentName: json['agentName']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'client': client,
        'clientPhone': clientPhone,
        'address': address,
        'items': items.map((e) => e.toJson()).toList(),
        'total': total,
        'deliveryPrice': deliveryPrice,
        'status': status,
        'deliveryAgent': deliveryAgent,
        'agentName': agentName,
        'createdAt': createdAt.toIso8601String(),
      };

  Order copyWith({
    String? id,
    String? client,
    String? clientPhone,
    String? address,
    List<OrderItem>? items,
    num? total,
    num? deliveryPrice,
    String? status,
    String? deliveryAgent,
    String? agentName,
    DateTime? createdAt,
  }) {
    return Order(
      id: id ?? this.id,
      client: client ?? this.client,
      clientPhone: clientPhone ?? this.clientPhone,
      address: address ?? this.address,
      items: items ?? this.items,
      total: total ?? this.total,
      deliveryPrice: deliveryPrice ?? this.deliveryPrice,
      status: status ?? this.status,
      deliveryAgent: deliveryAgent ?? this.deliveryAgent,
      agentName: agentName ?? this.agentName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
