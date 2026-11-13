import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/note.dart';
import '../repositories/note_repository.dart';

/// Provider global berbasis InheritedWidget.
class AppProvider extends InheritedWidget {
  final Student student;
  final List<Note> notes;
  final void Function(Student) updateStudent;
  final Future<void> Function(Note) addNote;
  final Future<void> Function(String) deleteNote;

  const AppProvider({
    super.key,
    required this.student,
    required this.notes,
    required this.updateStudent,
    required this.addNote,
    required this.deleteNote,
    required super.child,
  });

  static AppProvider of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppProvider>();
    assert(result != null, 'AppProvider tidak ditemukan');
    return result!;
  }

  @override
  bool updateShouldNotify(AppProvider oldWidget) {
    return student != oldWidget.student || notes != oldWidget.notes;
  }
}

/// Wrapper StatefulWidget yang mengelola state.
class AppProviderWrapper extends StatefulWidget {
  final Widget child;
  const AppProviderWrapper({super.key, required this.child});

  @override
  State<AppProviderWrapper> createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  Student _student = const Student(
    name: 'Nafissa Shofi Ardina',
    nim: '25.11.6567',
    programStudi: 'S1 Informatika',
    email: 'n.shofi@students.amikom.ac.id',
  );
  List<Note> _notes = [];
  final NoteRepository _repo = NoteRepository();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _repo.fetchAll();
    setState(() => _notes = notes);
  }

  void _updateStudent(Student s) => setState(() => _student = s);

  Future<void> _addNote(Note n) async {
    await _repo.save(n);
    await _loadNotes();
  }

  Future<void> _deleteNote(String id) async {
    await _repo.delete(id);
    await _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      notes: _notes,
      updateStudent: _updateStudent,
      addNote: _addNote,
      deleteNote: _deleteNote,
      child: widget.child,
    );
  }
}