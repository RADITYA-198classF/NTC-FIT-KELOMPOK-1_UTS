# NTC Fit — kode UI/UX (Flutter)

Kode antarmuka klon Nike Training Club berdasarkan 22 screenshot referensi.
Hanya UI dan navigasi; belum ada backend (titik sambung API ditandai `TODO(api)`).

> **Belum dikompilasi.** Kode ditulis tanpa Flutter SDK, jadi belum pernah
> dijalankan atau diuji dengan `flutter analyze`. Jalankan di komputer Anda,
> lalu kirim error atau screenshot hasilnya supaya bisa diperbaiki dan
> dibandingkan dengan referensi.

## Cara menjalankan project ini

1. Ekstrak ZIP project ke folder lokal, misalnya `C:\Flutter\NTC-FIT-KELOMPOK-1_UTS`.
2. Buka folder tersebut di VS Code.
3. Jalankan `flutter pub get` untuk memasang dependency, termasuk `video_player`.
4. Jalankan `flutter analyze`, lalu `flutter run -d chrome`.

Jika hanya ingin menyalin aset ke project yang sudah ada, salin folder `assets/`, terapkan perubahan `lib/data/dummy_data.dart`, `lib/screens/workout/workout_detail_screen.dart`, dan tambahkan dependency `video_player: ^2.10.0` serta entri `assets/videos/` di `pubspec.yaml`.

Versi yang disarankan: Flutter 3.22 atau lebih baru (memakai `super.key`, `context.mounted`, dan `PopScope.onPopInvokedWithResult`).
Tampilan memakai Material 2 (`useMaterial3: false`) agar mirip aplikasi aslinya.

## Alur layar

```
Splash → Welcome (Bergabunglah / Masuk)
       → Email (bilah browser) → Daftar (kode, nama, tanggal lahir) → "Anda berhasil masuk."
       → Selamat datang → 2/3 Jenis kelamin → 3/3 Frekuensi latihan → Loading pustaka
       → Halaman utama (drawer): Latihan · Program · Rumah · Latihan yang Disimpan ·
         Aktivitas (Riwayat, Prestasi) · Kotak Masuk
       → dari drawer: Profil (ketuk avatar/nama) dan Pengaturan

Latihan:  ketuk latihan atau kategori (HIIT, Kekuatan, Yoga, Siap untuk Gym, Pilates)
       → daftar latihan kategori → Detail latihan (deskripsi + langkah latihan)
       → Mulai Latihan → sesi dengan timer per gerakan → Ringkasan → Aktivitas > Riwayat
```

| Screenshot | File |
|---|---|
| 1 Splash | `screens/splash/splash_screen.dart` |
| 2 Welcome | `screens/welcome/welcome_screen.dart` |
| 3 Email | `screens/auth/email_screen.dart` |
| 4 Daftar | `screens/auth/register_screen.dart` |
| 5 Berhasil masuk | `screens/auth/signin_success_screen.dart` |
| 6 Selamat datang | `screens/onboarding/member_welcome_screen.dart` |
| 7 Jenis kelamin (2/3) | `screens/onboarding/gender_screen.dart` |
| 8 Frekuensi (3/3) | `screens/onboarding/frequency_screen.dart` |
| 9 Loading | `screens/onboarding/library_loading_screen.dart` |
| 10-12 Latihan | `screens/latihan/latihan_screen.dart` |
| 13 Drawer | `widgets/ntc_drawer.dart` |
| 14 Program | `screens/program/program_screen.dart` |
| 15 Rumah | `screens/home/rumah_screen.dart` |
| 16 Latihan yang Disimpan | `screens/saved/saved_screen.dart` |
| 17-18 Aktivitas | `screens/activity/activity_screen.dart` |
| 19 Kotak Masuk | `screens/inbox/inbox_screen.dart` |
| 20-21 Pengaturan | `screens/settings/settings_screen.dart` |
| 22 Profil | `screens/profile/profile_screen.dart` |

Kerangka halaman utama (AppBar, drawer, TabBar Aktivitas) ada di `screens/shell/main_shell.dart`.

Halaman latihan yang ditambahkan (tidak ada di screenshot, gayanya mengikuti layar lain):

| Layar | File |
|---|---|
| Daftar latihan per kategori / semua latihan | `screens/workout/workout_list_screen.dart` |
| Detail latihan: foto, info, deskripsi, langkah latihan, tombol **Mulai Latihan** | `screens/workout/workout_detail_screen.dart` |
| Sesi latihan dengan timer | `screens/workout/workout_session_screen.dart` |
| Ringkasan setelah selesai | `screens/workout/workout_summary_screen.dart` |

## Struktur

```
lib/
  main.dart, app.dart
  core/     app_colors, app_text_styles, app_theme, app_routes, app_config
  data/     models, dummy_data, app_session
  widgets/  pill_button, option_pill, browser_frame, web_text_field, ntc_drawer,
            workout_tile, app_image, ntc_logo, trophy_badge, your_workout_icons
  screens/  splash, welcome, auth, onboarding, shell, latihan, program, home,
            saved, activity, inbox, settings, profile, workout
```

Warna ada di satu tempat (`core/app_colors.dart`), diambil dari sampel piksel
screenshot. Teks mengikuti screenshot apa adanya, termasuk bagian berbahasa
Inggris di Rumah ("Hybrid Training", "WORKOUTS THAT DO IT ALL", "Explore") dan
"0 workouts".

## Yang berfungsi

- Tombol Bergabunglah dan Masuk sama-sama membuka halaman email; validasi email dan formulir daftar (kode, nama, tanggal lahir, persetujuan) berjalan.
- Hitung mundur "Kirim ulang kode dalam 20 dtk" berjalan, lalu berubah menjadi "Kirim ulang kode".
- Nama dari formulir tampil di sambutan, drawer, dan Profil; email tampil di Pengaturan.
- Pilihan jenis kelamin dan frekuensi latihan tersimpan di sesi, lalu menuju layar loading dan halaman utama.
- Drawer berpindah halaman; ikon bookmark menyimpan latihan dan mengubah jumlah "Disimpan" serta isi halaman Latihan yang Disimpan.
- Mengetuk kartu kategori membuka daftar latihan kategori itu; "Lihat semua" dan kartu "Semua latihan" membuka seluruh latihan. Kolom cari memfilter langsung di halaman Latihan.
- Mengetuk latihan (di Latihan, daftar kategori, atau Disimpan) membuka detail: deskripsi dan langkah latihan, mis. "Cat Cow 10 repetisi", "Quad Rocker 10 repetisi", dan seterusnya.
- **Mulai Latihan** membuka sesi: hitung mundur "Bersiap" 5 dtk, lalu tiap gerakan dijalankan berurutan. Gerakan berbasis repetisi memakai stopwatch naik yang mengukur lama gerakan, dan Anda menekan **Selesai**. Gerakan berbasis waktu (mis. Plank 40 dtk) memakai hitung mundur otomatis. Di antara gerakan ada istirahat 10 dtk yang bisa dilewati. Tombol jeda dan tombol tutup (dengan konfirmasi) tersedia.
- Setelah gerakan terakhir, ringkasan menampilkan waktu total. Sesi tercatat di **Aktivitas > Riwayat**, dan angka "Selesai" di halaman Latihan bertambah.
- Lama istirahat dan hitung mundur awal diatur di `core/app_config.dart`; isi gerakan tiap latihan di `data/dummy_data.dart`.
- Carousel Rumah, tab Riwayat/Prestasi, Keluar, dan Hapus Akun berjalan.

## Asumsi (tidak ada di screenshot)

- Alamat di bilah browser memakai `AppConfig.authHostLabel` (`accounts.ntcfit.app`), bukan domain Nike. Ubah di `core/app_config.dart`.
- Logo Jumpman di halaman web tidak dibuat; swoosh digambar vektor sebagai pendekatan.
- Layar 6 dianggap langkah 1/3 (di screenshot hanya ada 2/3 dan 3/3).
- Teks "Tidak ada latihan yang cocok." dan pesan validasi formulir adalah isian sementara.
- Halaman daftar kategori, detail, sesi timer, dan ringkasan dirancang mengikuti gaya layar lain karena tidak ada screenshot-nya. Teks di dalamnya ("Deskripsi", "Langkah Latihan", "Mulai Latihan", "Bersiap", "Istirahat", "Lewati", "Selesai", "LATIHAN SELESAI") adalah usulan, bukan salinan aplikasi asli.
- Deskripsi, daftar gerakan, repetisi/durasi, dan petunjuk gerakan (kecuali Cat Cow dan Quad Rocker 10 repetisi) adalah data contoh. Latihan ke-4 sampai ke-12 juga contoh.
- Layar tidak dijaga tetap menyala selama sesi (butuh paket `wakelock_plus`), dan belum ada suara/getar saat waktu habis.
- Dialog konfirmasi Keluar/Hapus Akun adalah asumsi.
- Slide 2-5 carousel, kartu program ke-2 dan ke-3, latihan ke-4 sampai ke-8, dan trofi ke-4 sampai ke-6 adalah data contoh.
- Detail program, Edit Profil, Tambahkan Teman, Akses, dan submenu Pengaturan belum ada referensinya sehingga belum dibuat (barisnya hanya memberi efek sentuh).
- Angka "Semua latihan" dihitung dari data contoh, bukan 325.

## Font

Aplikasi asli memakai font milik Nike yang tidak boleh didistribusikan. Teks isi memakai font bawaan Android.
Judul kondensed (Rumah, Aktivitas, logo NTC) memakai keluarga `NTCDisplay`; daftarkan font gratis seperti
Anton (lihat `pubspec_snippet.yaml`). Tanpa font itu, aplikasi tetap jalan memakai font bawaan, tetapi
judul akan lebih lebar dan bisa membungkus ke baris tambahan.

## Video latar Welcome

Layar Welcome memakai foto (`assets/images/welcome_bg.jpg`). Untuk video:

1. Tambahkan `video_player` (`flutter pub add video_player`) dan daftarkan `assets/videos/` di pubspec.
2. Buat widget berikut dan ganti `AppImage('assets/images/welcome_bg.jpg', ...)` di `welcome_screen.dart` dengan `const WelcomeVideoBackground()`.

```dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WelcomeVideoBackground extends StatefulWidget {
  const WelcomeVideoBackground({super.key});

  @override
  State<WelcomeVideoBackground> createState() => _WelcomeVideoBackgroundState();
}

class _WelcomeVideoBackgroundState extends State<WelcomeVideoBackground> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/welcome.mp4')
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (!mounted) return;
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const ColoredBox(color: Color(0xFF4A1A5C));
    }
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _controller.value.size.width,
        height: _controller.value.size.height,
        child: VideoPlayer(_controller),
      ),
    );
  }
}
```

## Tahap berikutnya (backend)

Cari komentar `TODO(api)` untuk titik sambung: cek email, verifikasi kode dan pendaftaran,
simpan jenis kelamin dan frekuensi, muat pustaka latihan, logout, dan hapus akun.
Data contoh ada di `data/dummy_data.dart`; status sesi di `data/app_session.dart`.


## Aset foto dan video

Aset foto sudah disimpan dengan nama yang mudah dibaca di `assets/images/`, sedangkan video demonstrasi ada di `assets/videos/workout_demo.mp4`. Pada halaman detail latihan, gunakan tombol **Tonton Video Latihan** untuk membuka pemutar video. Karena package `video_player` baru ditambahkan, jalankan `flutter pub get` sebelum `flutter run -d chrome`. Lihat `assets/images/DAFTAR_ASET.md` untuk daftar aset.
