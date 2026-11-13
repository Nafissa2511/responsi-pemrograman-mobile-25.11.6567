import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';
import '../services/secure_storage_service.dart';

/// Repository pengelola metadata & isi catatan.
class NoteRepository {
  static const _metaKey = 'note_metadata';
  final SecureStorageService _secure = SecureStorageService();

  /// Mengambil seluruh metadata catatan.
  Future<List<Note>> fetchAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_metaKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => Note.fromMap(e)).toList();
  }

  /// Menyimpan catatan baru (Metadata ke Prefs, Isi ke Secure Storage).
  Future<void> save(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await fetchAll();
    list.add(note.copyWith(content: null));
    
    await prefs.setString(
      _metaKey,
      jsonEncode(list.map((e) => e.toMap()).toList()),
    );
    
    if (note.content != null) {
      await _secure.saveContent(note.id, note.content!);
    }
  }

  /// Menghapus catatan.
  Future<void> delete(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = (await fetchAll()).where((n) => n.id != id).toList();
    
    await prefs.setString(
      _metaKey,
      jsonEncode(list.map((e) => e.toMap()).toList()),
    );
    await _secure.deleteContent(id);
  }

  /// Mengambil isi catatan terenkripsi berdasarkan ID.
  Future<String?> getContent(String id) async {
    return await _secure.getContent(id);
  }
}