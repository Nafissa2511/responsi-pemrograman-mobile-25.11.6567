import 'package:flutter/material.dart';
import '../models/student.dart';

/// Kartu yang menampilkan informasi profil mahasiswa.
class ProfileCard extends StatelessWidget {
  final Student student;
  final VoidCallback? onEdit;

  const ProfileCard({super.key, required this.student, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Text(student.name, style: Theme.of(context).textTheme.titleLarge),
          Text(student.nim),
          const Divider(height: 30),
          _row('Program Studi', student.programStudi),
          _row('Email', student.email),
          const SizedBox(height: 12),
          if (onEdit != null)
            ElevatedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profil'),
            ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text(value)],
        ),
      );
}