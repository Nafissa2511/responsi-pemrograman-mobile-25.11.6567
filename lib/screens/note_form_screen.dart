import 'package:flutter/material.dart';
import '../models/note.dart';
import '../providers/app_provider.dart';
import '../utils/validators.dart';

/// Layar form untuk menambah catatan baru.
class NoteFormScreen extends StatefulWidget {
  const NoteFormScreen({super.key});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    final cleanTitle = Validators.sanitize(_titleController.text);
    final cleanContent = Validators.sanitize(_contentController.text);

    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: cleanTitle,
      date: DateTime.now(),
      content: cleanContent,
    );

    await AppProvider.of(context).addNote(newNote);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Catatan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Catatan',
                border: OutlineInputBorder(),
              ),
              validator: Validators.validateTitle,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Isi Catatan',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: Validators.validateContent,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text('Simpan Catatan'),
            ),
          ],
        ),
      ),
    );
  }
}