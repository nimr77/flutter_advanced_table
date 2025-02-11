//region Example
// Sample Data
import 'package:flutter/material.dart';
import 'package:flutter_advanced_table/flutter_advanced_table.dart';
import 'package:flutter_animate/flutter_animate.dart';

List<Order> _generateFakeOrders(int count) {
  return List.generate(
      count,
      (index) => Order(
            orderNumber: '#${index + 1000}',
            localName: 'Local ${index % 3}', // Simulate different locals
            userFullName: 'User ${index + 1}',
            toBePaidPrice: (index + 1) * 10.5, // Some price
            paymentStatus:
                index % 2 == 0 ? 'Paid' : 'Pending', // Simulate payment status
            createdDate: DateTime.now().subtract(Duration(days: index)),
            orderStatus: index % 3 == 0
                ? 'Completed'
                : (index % 3 == 1 ? 'Processing' : 'Pending'),
          ));
}

class Order {
  final String orderNumber;
  final String localName;
  final String userFullName;
  final double toBePaidPrice;
  final String paymentStatus;
  final DateTime createdDate;
  final String orderStatus;

  Order({
    required this.orderNumber,
    required this.localName,
    required this.userFullName,
    required this.toBePaidPrice,
    required this.paymentStatus,
    required this.createdDate,
    required this.orderStatus,
  });
}

class OrdersTableExample extends StatefulWidget {
  const OrdersTableExample({super.key});

  @override
  State<OrdersTableExample> createState() => _OrdersTableExampleState();
}

class _OrdersTableExampleState extends State<OrdersTableExample> {
  final ValueNotifier<bool> _isLoadingAll = ValueNotifier(false);
  final ValueNotifier<bool> _isLoadingMore = ValueNotifier(false);
  late List<Order> _orders;
  final int _initialLoad = 10;
  final int _loadMoreCount = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Advanced Table Example'),
        ),
        body: AdvancedTableWidget(
            onEmptyState: const Center(child: Text("No orders")),
            rowBuilder: (_, index, row, isHover) {
              return rowBuilder(context, index, row, isHover, _orders.length);
            },
            headerBuilder: (p0, p1) {
              final isCenter = p1.index != 0;

              return SizedBox(
                  width: p1.defualtWidth,
                  child: isCenter
                      ? Center(
                          child: Text(
                          p1.value,
                        ))
                      : Text(
                          p1.value,
                        ));
            },
            rowElementsBuilder: (ctx, row) {
              final item = _orders[row.index];
              return [
                SizedBox(
                    width: row.defualtWidth, child: Text(item.orderNumber)),
                ...[
                  Text(item.localName),
                  Text(item.userFullName),
                  Text(item.toBePaidPrice.toStringAsFixed(2)),
                  // Format as currency
                  Text(item.paymentStatus),
                  Text(item.createdDate.toIso8601String().split('T')[0]),
                  // Format date
                  Text(item.orderStatus),
                ].map((e) => SizedBox(
                      width: row.defualtWidth,
                      child: Center(child: e),
                    )),
              ];
            },
            headerDecoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(0.7))), // Example radius
            outterRowsPadding: const EdgeInsets.symmetric(horizontal: 5),
            innerHeaderPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            innerRowElementsPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            rowDecorationBuilder: (p0, isHover) =>
                rowDecorationBuilder(context, p0, isHover),
            items: _orders,
            isLoadingAll: _isLoadingAll,
            isLoadingMore: _isLoadingMore,
            fullLoadingPlaceHolder:
                const Center(child: CircularProgressIndicator()),
            loadingMorePlaceHolder: const LinearProgressIndicator(),
            headerItems: const [
              "TEXT", //orderNumber
              "TEXT", // local
              "TEXT", // customer
              "TEXT", // cost
              "TEXT", // paymentStatus
              "TEXT", // createdDate
              "TEXT", //orderStatus
            ],
            actionBuilder: (context, params) {
              return IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // Handle action (e.g., show menu)
                  print(
                      "Action on row ${params.rowIndex}, item ${params.index}");
                },
              );
            },
            actions: [
              // define the action buttons per row
              {
                "label": "View"
              }, // used for  `actionBuilder` width and count calculate
            ]));
  }

  @override
  void initState() {
    super.initState();
    _orders = _generateFakeOrders(_initialLoad); // Initial load
  }

  Widget rowBuilder(BuildContext context, int rowIndex, Widget row,
      bool isHover, int length) {
    _loadMore(rowIndex); // For lazy loading

    return AnimatedScale(
      duration: const Duration(milliseconds: 300),
      scale: isHover ? 1.02 : 1,
      child: row.animate(
          delay: length < 10
              ? (rowIndex.milliseconds * 300)
              : null, // Add .milliseconds here
          effects: [
            SlideEffect(
              duration: 500.milliseconds,
              curve: Curves.easeInOut,
              begin: const Offset(0, -0.1),
            ),
            FadeEffect()
          ]),
    );
  }

  BoxDecoration rowDecorationBuilder(
      BuildContext context, int index, bool isHover) {
    final isOdd = index % 2 == 0;
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(0.7)),
        color: isHover
            ? Theme.of(context).primaryColor.withAlpha(100)
            : isOdd
                ? Colors.transparent
                : Theme.of(context).primaryColor.withOpacity(0.1));
  }

  Future<void> _loadMore(int index) async {
    if (index < _orders.length - 2) return; // Only load if near the end.

    if (_isLoadingMore.value) return;
    _isLoadingMore.value = true;
    await Future.delayed(const Duration(seconds: 1));
    final newOrders = _generateFakeOrders(_loadMoreCount); // Get next batch
    setState(() {
      _orders.addAll(newOrders);
    });
    _isLoadingMore.value = false;
  }
}
