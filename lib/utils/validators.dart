/// Kelas utilitas untuk validasi dan sanitasi input pengguna.
class Validators {
  /// Validasi judul catatan: minimal 3 karakter dan maksimal 50 karakter[cite: 5].
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Judul catatan tidak boleh kosong';
    }
    final trimmed = value.trim();
    if (trimmed.length < 3) {
      return 'Judul minimal 3 karakter';
    }
    if (trimmed.length > 50) {
      return 'Judul maksimal 50 karakter';
    }
    return null;
  }

  /// Validasi isi catatan: minimal 10 karakter dan maksimal 1000 karakter[cite: 5].
  static String? validateContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Isi catatan tidak boleh kosong';
    }
    final trimmed = value.trim();
    if (trimmed.length < 10) {
      return 'Isi catatan minimal 10 karakter';
    }
    if (trimmed.length > 1000) {
      return 'Isi catatan maksimal 1000 karakter';
    }
    return null;
  }

  /// Membersihkan input dari karakter berbahaya (<, >, ", ')[cite: 5].
  static String sanitize(String input) {
    return input.replaceAll(RegExp(r'[<>"\x27]'), '').trim();
  }
}