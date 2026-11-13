import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../providers/app_provider.dart';
import '../widgets/note_card.dart';
import '../widgets/empty_state.dart';
import 'profile_screen.dart';
import 'note_form_screen.dart';

/// Layar utama aplikasi.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoadingApi = false;
  String _apiResult = '';

  /// Mengambil data dari API dengan error handling dan logging aman.
  Future<void> _fetchApiData() async {
    setState(() {
      _isLoadingApi = true;
      _apiResult = 'Memuat data...';
    });

    try {
      final uri = Uri.parse('${AppConfig.baseUrl}/users');
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      
      if (res.statusCode == 200) {
        // Logging aman: tidak mencetak token atau isi data sensitif
        debugPrint('[INFO] GET /users sukses (${res.body.length} byte)');
        setState(() => _apiResult = 'Berhasil memuat data API (Status: 200)');
      } else {
        debugPrint('[WARN] GET /users status ${res.statusCode}');
        setState(() => _apiResult = 'Gagal: Status ${res.statusCode}');
      }
    } on TimeoutException {
      debugPrint('[ERROR] Request timeout');
      setState(() => _apiResult = 'Error: Koneksi Timeout');
    } on SocketException {
      debugPrint('[ERROR] Tidak ada koneksi internet');
      setState(() => _apiResult = 'Error: Tidak ada koneksi internet');
    } catch (_) {
      debugPrint('[ERROR] Gagal mengambil data');
      setState(() => _apiResult = 'Error: Gagal mengambil data');
    } finally {
      setState(() => _isLoadingApi = false);
    }
  }

  void _confirmDelete(BuildContext context, String noteId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Catatan?'),
        content: const Text('Catatan ini akan dihapus permanen.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              AppProvider.of(context).deleteNote(noteId);
              Navigator.pop(ctx);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    final notes = provider.notes;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Catatan Kuliah'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.book), text: 'Catatan Saya'),
              Tab(icon: Icon(Icons.cloud), text: 'Referensi API'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: Daftar Catatan
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(provider.student.name[0], style: const TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(provider.student.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('NIM: ${provider.student.nim} • ${provider.student.programStudi}'),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: notes.isEmpty
                      ? const EmptyState()
                      : ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (ctx, index) {
                            final note = notes[index];
                            return NoteCard(
                              note: note,
                              onDelete: () => _confirmDelete(context, note.id),
                            );
                          },
                        ),
                ),
              ],
            ),
            
            // TAB 2: HTTP GET API
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLoadingApi) const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(_apiResult, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoadingApi ? null : _fetchApiData,
                    child: const Text('Ambil Data dari API'),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NoteFormScreen()),
            );
            if (result == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Catatan berhasil ditambahkan')),
              );
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}