/// Konfigurasi UI yang mudah diganti di satu tempat.
class AppConfig {
  AppConfig._();

  /// Teks alamat yang tampil di bilah atas halaman masuk/daftar bergaya browser.
  /// Di aplikasi asli tertulis domain akun Nike. Di NTC Fit sengaja memakai
  /// label sendiri agar tidak tampil seolah-olah produk resmi Nike.
  static const String authHostLabel = 'accounts.ntcfit.app';

  /// Durasi hitung mundur "Kirim ulang kode" pada halaman daftar (detik).
  static const int resendCodeSeconds = 20;

  /// Hitung mundur "Bersiap" sebelum gerakan pertama (detik).
  static const int getReadySeconds = 5;

  /// Istirahat antar gerakan pada sesi latihan (detik).
  static const int restSeconds = 10;
}
