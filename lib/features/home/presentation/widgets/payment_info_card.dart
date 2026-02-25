import 'package:flutter/material.dart';

class PaymentInfoCard extends StatelessWidget {
  final String date;
  final String time;
  final double fee;

  const PaymentInfoCard({
    super.key,
    required this.date,
    required this.time,
    required this.fee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.calendar_today_outlined, 'Date', date),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.access_time_outlined, 'Time', time),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFFE2E8F0)),
          ),
          _buildInfoRow(
            Icons.account_balance_wallet_outlined,
            'Consultation Fee',
            '\$${fee.toStringAsFixed(2)}',
            valueColor: const Color(0xFF1E5BB1),
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
