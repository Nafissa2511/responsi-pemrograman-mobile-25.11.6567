import 'package:flutter/material.dart';
import '../providers/app_provider.dart';
import '../widgets/profile_card.dart';

/// Layar yang menampilkan profil mahasiswa.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditDialog(BuildContext context) {
    final provider = AppProvider.of(context);
    final nameCtrl = TextEditingController(text: provider.student.name);
    final nimCtrl = TextEditingController(text: provider.student.nim);
    final prodiCtrl = TextEditingController(text: provider.student.programStudi);
    final emailCtrl = TextEditingController(text: provider.student.email);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profil'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nama')),
              TextField(controller: nimCtrl, decoration: const InputDecoration(labelText: 'NIM')),
              TextField(controller: prodiCtrl, decoration: const InputDecoration(labelText: 'Prodi')),
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              provider.updateStudent(provider.student.copyWith(
                name: nameCtrl.text,
                nim: nimCtrl.text,
                programStudi: prodiCtrl.text,
                email: emailCtrl.text,
              ));
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = AppProvider.of(context).student;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Mahasiswa')),
      body: SingleChildScrollView(
        child: ProfileCard(
          student: student,
          onEdit: () => _showEditDialog(context),
        ),
      ),
    );
  }
}