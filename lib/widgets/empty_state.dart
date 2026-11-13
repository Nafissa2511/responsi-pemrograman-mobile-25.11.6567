import 'package:flutter/material.dart';

/// Widget yang ditampilkan saat tidak ada data (kosong).
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.assignment_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Belum Ada Catatan Kuliah', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text('Tekan tombol + di pojok kanan bawah untuk menambahkan catatan pertama Anda.', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
