import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/order_model.dart';

class OrderItem extends StatefulWidget {
  final OrderModel order;

  const OrderItem(this.order, {Key? key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> orderItems;

    if (_expanded) {
      orderItems = widget.order.items.map<Widget>((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text('${item.quantity} x R\$ ${item.price.toStringAsFixed(2)}'),
            ],
          ),
        );
      }).toList();
    } else {
      orderItems = [];
    }

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('R\$ ${widget.order.total.toStringAsFixed(2)}'),
            subtitle:
                Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date)),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.only(
                bottom: 15.0,
                left: 15.0,
                right: 15.0,
              ),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: orderItems,
              ),
            ),
        ],
      ),
    );
  }
}
