import 'package:flutter/material.dart';
import 'package:iot/generated/pocketbase/orders_record.dart';
import 'package:iot/main.dart';
import 'package:provider/provider.dart';
import 'package:iot/core/providers/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

class WeeklyOrdersPage extends StatefulWidget {
  const WeeklyOrdersPage({super.key});

  @override
  State<WeeklyOrdersPage> createState() => _WeeklyOrdersPageState();
}

class _WeeklyOrdersPageState extends State<WeeklyOrdersPage> {
  List<OrdersRecord> weeklyOrders = [];
  List<OrdersRecord> filteredOrders = [];
  bool isLoading = true;
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  OrdersRecordStatusEnum? _statusFilter;

  @override
  void initState() {
    super.initState();
    _fetchWeeklyOrders();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeeklyOrders() async {
    try {
      setState(() => isLoading = true);
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 7));

      final records = await pb.collection('orders').getList(
            filter:
                'created >= "${startOfWeek.toIso8601String()}" && created <= "${endOfWeek.toIso8601String()}"',
            sort: '-created',
          );

      setState(() {
        weeklyOrders =
            records.items.map((e) => OrdersRecord.fromRecordModel(e)).toList();
        filteredOrders = weeklyOrders;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading orders: $e')),
        );
      }
    }
  }

  void _filterOrders() {
    setState(() {
      filteredOrders = weeklyOrders.where((order) {
        final matchesSearch = order.id.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );
        final matchesStatus =
            _statusFilter == null || order.status == _statusFilter;
        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search and Filter Row
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search orders...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (value) => _filterOrders(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      _buildStatusFilterDropdown(),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Stats Cards
                  _buildStatsCards(),
                  const SizedBox(height: 24),

                  // Orders Table
                  if (filteredOrders.isEmpty)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_rounded,
                            size: 64,
                            color: Colors.grey.shade400,
                          )
                              .animate()
                              .fade(duration: 600.ms)
                              .scale(delay: 200.ms),
                          const SizedBox(height: 16),
                          Text(
                            'No orders this week',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                            ),
                          )
                              .animate()
                              .fade(delay: 400.ms)
                              .slideY(begin: 0.3, curve: Curves.easeOut),
                        ],
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .outlineVariant
                              .withOpacity(0.5),
                        ),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.surfaceVariant,
                            ),
                            columns: _buildColumns(),
                            rows: _buildRows(),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _fetchWeeklyOrders,
        icon: const Icon(Icons.refresh),
        label: const Text('Refresh'),
      ).animate().fade().scale(),
    );
  }

  Widget _buildStatusFilterDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<OrdersRecordStatusEnum?>(
        value: _statusFilter,
        hint: const Text('Filter Status'),
        underline: const SizedBox(),
        items: [
          const DropdownMenuItem(
            value: null,
            child: Text('All Statuses'),
          ),
          ...OrdersRecordStatusEnum.values.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getStatusColor(status),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(_getStatusText(status)),
                ],
              ),
            );
          }),
        ],
        onChanged: (value) {
          setState(() {
            _statusFilter = value;
            _filterOrders();
          });
        },
      ),
    );
  }

  Widget _buildStatsCards() {
    final totalOrders = weeklyOrders.length;
    final deliveredOrders = weeklyOrders
        .where((o) => o.status == OrdersRecordStatusEnum.delivered)
        .length;
    final pendingOrders = weeklyOrders
        .where((o) => o.status == OrdersRecordStatusEnum.pending)
        .length;

    return Row(
      children: [
        _buildStatCard(
          'Total Orders',
          totalOrders.toString(),
          Icons.shopping_cart,
          Colors.blue,
        ),
        _buildStatCard(
          'Delivered',
          deliveredOrders.toString(),
          Icons.check_circle,
          Colors.green,
        ),
        _buildStatCard(
          'Pending',
          pendingOrders.toString(),
          Icons.pending,
          Colors.orange,
        ),
      ].map((widget) => Expanded(child: widget)).toList(),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ).animate().scale(delay: 100.ms),
    );
  }

  List<DataColumn> _buildColumns() {
    return const [
      DataColumn(
        label: Row(
          children: [
            Icon(Icons.check_box_outline_blank, size: 20),
            SizedBox(width: 8),
            Text('Order #'),
          ],
        ),
      ),
      DataColumn(label: Text('Status')),
      DataColumn(label: Text('Created')),
      DataColumn(label: Text('Last Updated')),
      DataColumn(label: Text('Actions')),
    ];
  }

  List<DataRow> _buildRows() {
    return filteredOrders.map((order) {
      return DataRow(
        selected: false,
        cells: [
          DataCell(
            Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (value) {
                    // Implement selection logic
                  },
                ),
                Text(
                  '#${order.id.substring(0, 8)}',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          DataCell(_buildStatusChip(order.status)),
          DataCell(Text(
            DateFormat('MMM dd, yyyy').format(order.created.toLocal()),
          )),
          DataCell(Text(
            DateFormat('MMM dd, yyyy')
                .format(order.updated?.toLocal() ?? order.created.toLocal()),
          )),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () => _showTimelineDialog(order),
                  tooltip: 'View Details',
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildStatusChip(OrdersRecordStatusEnum? status) {
    final (backgroundColor, textColor, label) = switch (status) {
      OrdersRecordStatusEnum.delivered => (
          const Color(0xFFE7F5ED),
          const Color(0xFF1B855E),
          'FULFILLED'
        ),
      OrdersRecordStatusEnum.inProgress => (
          const Color(0xFFE5F0FF),
          const Color(0xFF1570EF),
          'IN PROGRESS'
        ),
      OrdersRecordStatusEnum.pending => (
          const Color(0xFFFEF0C7),
          const Color(0xFFB54708),
          'PENDING'
        ),
      _ => (Colors.grey[200]!, Colors.grey[700]!, 'UNKNOWN'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showOrderDetails(OrdersRecord order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _OrderDetailsSheet(order: order),
    );
  }

  void _showTimelineDialog(OrdersRecord order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Details',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '#${order.id.substring(0, 8)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildTimelineSection(order),
                        const SizedBox(height: 32),
                        _buildOrderDetailsSection(order),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fade().scale(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
      },
    );
  }

  Widget _buildTimelineSection(OrdersRecord order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Timeline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          ...buildTimelineItems(order),
        ],
      ),
    );
  }

  List<Widget> buildTimelineItems(OrdersRecord order) {
    final items = <Widget>[];
    final now = DateTime.now();

    // Created
    items.add(
      _buildTimelineItem(
        'Order Created',
        order.created,
        Icons.fiber_manual_record,
        Theme.of(context).colorScheme.primary,
        true,
        isCompleted: true,
      ),
    );

    // In Progress
    items.add(
      _buildTimelineItem(
        'Processing',
        order.created.add(const Duration(hours: 1)),
        Icons.local_shipping_rounded,
        Theme.of(context).colorScheme.secondary,
        true,
        isCompleted: order.status != OrdersRecordStatusEnum.pending,
      ),
    );

    // Delivered
    items.add(
      _buildTimelineItem(
        'Delivered',
        order.created.add(const Duration(hours: 2)),
        Icons.check_circle_outline_rounded,
        Theme.of(context).colorScheme.tertiary,
        false,
        isCompleted: order.status == OrdersRecordStatusEnum.delivered,
      ),
    );

    return items;
  }

  Widget _buildTimelineItem(String title, DateTime date, IconData icon,
      Color color, bool showConnector,
      {required bool isCompleted}) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? color.withOpacity(0.1)
                        : Theme.of(context)
                            .colorScheme
                            .surfaceVariant
                            .withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isCompleted
                        ? color
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                if (showConnector)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            color.withOpacity(0.5),
                            color.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isCompleted
                    ? color.withOpacity(0.05)
                    : Theme.of(context)
                        .colorScheme
                        .surfaceVariant
                        .withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCompleted
                      ? color.withOpacity(0.2)
                      : Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isCompleted
                          ? color
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd, yyyy HH:mm').format(date.toLocal()),
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetailsSection(OrdersRecord order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailRow(
            'Delivery Address',
            order.address ?? 'No address provided',
            Icons.location_on_rounded,
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            'Quantity',
            '${order.quantity?.toStringAsFixed(2) ?? 'N/A'} units',
            Icons.inventory_2_rounded,
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            'Status',
            _getStatusText(order.status),
            Icons.local_shipping_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(OrdersRecordStatusEnum? status) {
    switch (status) {
      case OrdersRecordStatusEnum.pending:
        return Colors.orange;
      case OrdersRecordStatusEnum.inProgress:
        return Colors.blue;
      case OrdersRecordStatusEnum.delivered:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(OrdersRecordStatusEnum? status) {
    switch (status) {
      case OrdersRecordStatusEnum.pending:
        return 'Pending';
      case OrdersRecordStatusEnum.inProgress:
        return 'In Progress';
      case OrdersRecordStatusEnum.delivered:
        return 'Delivered';
      default:
        return 'Unknown';
    }
  }
}

class _OrderDetailsSheet extends StatelessWidget {
  final OrdersRecord order;

  const _OrderDetailsSheet({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Add more detailed order information here
        ],
      ),
    ).animate().fade().slideY(begin: 0.2);
  }
}

class DotPatternPainter extends CustomPainter {
  final Color color;

  DotPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    for (var i = 0; i < size.width; i += 20) {
      for (var j = 0; j < size.height; j += 20) {
        canvas.drawCircle(Offset(i.toDouble(), j.toDouble()), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
