# NTC Fit

Aplikasi mobile Flutter yang meniru tampilan dan alur **Nike Training Club**, lengkap dengan backend REST API (PHP + MySQL).
Proyek UTS mata kuliah **Pemrograman Aplikasi Bergerak** — Kelompok 1.

> **Catatan:** NTC Fit adalah proyek belajar dan bukan produk resmi Nike. Nama, logo, dan merek Nike adalah milik pemiliknya masing-masing.

![Flutter](https://img.shields.io/badge/Flutter-Dart%203.13%2B-02569B?logo=flutter&logoColor=white)
![PHP](https://img.shields.io/badge/PHP-8.x-777BB4?logo=php&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-database-4479A1?logo=mysql&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Web-3DDC84)

## Daftar Isi

- [Tentang Proyek](#tentang-proyek)
- [Fitur](#fitur)
- [Teknologi](#teknologi)
- [Alur Aplikasi](#alur-aplikasi)
- [Struktur Proyek](#struktur-proyek)
- [Prasyarat](#prasyarat)
- [Instalasi dan Menjalankan](#instalasi-dan-menjalankan)
- [Konfigurasi Base URL API](#konfigurasi-base-url-api)
- [Dokumentasi API](#dokumentasi-api)
- [Skema Database](#skema-database)
- [Catatan dan Asumsi](#catatan-dan-asumsi)
- [Pemecahan Masalah](#pemecahan-masalah)
- [Aset dan Lisensi](#aset-dan-lisensi)
- [Anggota Kelompok](#anggota-kelompok)

## Tentang Proyek

NTC Fit mereproduksi antarmuka Nike Training Club berdasarkan 22 screenshot referensi: warna, tata letak, teks berbahasa Indonesia, dan alur navigasinya. Pada versi ini aplikasi sudah terhubung ke backend sendiri untuk pendaftaran, daftar latihan, latihan tersimpan, dan riwayat latihan.

## Fitur

**Akun dan onboarding**
- Splash screen dan halaman Welcome dengan tombol **Bergabunglah** dan **Masuk**.
- Masuk atau daftar dengan email dan kode verifikasi (kode demo, lihat [Akun demo](#akun-demo)).
- Formulir pendaftaran: nama, tanggal lahir, dan persetujuan, dengan validasi.
- Onboarding pilihan jenis kelamin dan frekuensi latihan per minggu (0-1, 2-4, 5+).

**Latihan**
- Halaman **Latihan** dengan kolom pencarian, Mode Hibrid, dan kategori: HIIT, Kekuatan, Yoga, Siap untuk Gym, Pilates.
- Daftar latihan per kategori dan detail latihan: deskripsi, info, dan langkah latihan (nama gerakan beserta repetisi atau durasinya).
- **Sesi latihan dengan timer**: hitung mundur "Bersiap", stopwatch untuk gerakan berbasis repetisi, hitung mundur untuk gerakan berbasis waktu, istirahat antar gerakan, jeda, dan konfirmasi keluar.
- Ringkasan setelah latihan selesai dan pemutar video demonstrasi (**Tonton Video Latihan**).

**Navigasi dan data pengguna**
- Menu samping (drawer): Latihan, Program, Rumah, Latihan yang Disimpan, Aktivitas, Kotak Masuk, Pengaturan, dan Profil.
- Simpan latihan dengan ikon bookmark, riwayat latihan di **Aktivitas > Riwayat**, dan tab Prestasi.
- Daftar latihan, latihan tersimpan, dan riwayat dimuat dari REST API; data tersimpan di MySQL.

## Teknologi

| Lapisan | Teknologi |
|---|---|
| Aplikasi | Flutter, Dart (SDK `^3.13.2`), Material 2 |
| Paket Flutter | `http`, `video_player`, `cupertino_icons` |
| Backend | PHP 8 + PDO (tanpa framework, tanpa dependency tambahan) |
| Database | MySQL (schema dan seed disertakan) |
| Autentikasi | Kode verifikasi + token bearer |
| Alat bantu | VS Code, Laragon/XAMPP, HeidiSQL/phpMyAdmin, Postman, Git dan GitHub |

## Alur Aplikasi

```text
Splash → Welcome (Bergabunglah / Masuk)
       → Email → Kode verifikasi + data diri → "Anda berhasil masuk."
       → Selamat datang → Jenis kelamin (2/3) → Frekuensi latihan (3/3) → Memuat pustaka latihan
       → Halaman utama (drawer)
            Latihan · Program · Rumah · Latihan yang Disimpan · Aktivitas · Kotak Masuk
            Pengaturan dan Profil

Latihan → kategori / latihan → Detail latihan → Mulai Latihan
        → Sesi dengan timer → Ringkasan → tercatat di Aktivitas > Riwayat
```

## Struktur Proyek

```text
ntc_fit_kelompok1/
├── lib/
│   ├── main.dart, app.dart
│   ├── core/          # warna, tipografi, tema, rute, konfigurasi (AppConfig)
│   ├── data/          # model, data contoh, status sesi (AppSession)
│   ├── services/      # api_service.dart (klien HTTP ke REST API)
│   ├── widgets/       # komponen yang dipakai ulang (tombol, drawer, kartu, dsb.)
│   └── screens/       # splash, welcome, auth, onboarding, shell, latihan, program,
│                      # home, saved, activity, inbox, settings, profile, workout
├── backend/
│   ├── database/      # schema.sql dan seed.sql
│   ├── public/        # index.php (pintu masuk API) dan .htaccess
│   ├── src/           # Auth, Database, JsonResponse, WorkoutRepository
│   ├── config.php     # konfigurasi database dan kode demo
│   ├── router.php     # router untuk server bawaan PHP
│   ├── run_backend.bat
│   └── NTC_Fit_API.postman_collection.json
├── assets/
│   ├── images/        # foto latihan, kategori, program, dan latar (lihat DAFTAR_ASET.md)
│   └── videos/        # workout_demo.mp4
├── android/, web/     # platform yang didukung
└── pubspec.yaml
```

## Prasyarat

- [Flutter SDK](https://docs.flutter.dev/get-started/install) dengan Dart 3.13.2 atau lebih baru (sesuai `pubspec.yaml`). Cek dengan `flutter --version` dan `flutter doctor`.
- [Laragon](https://laragon.org/) atau XAMPP (PHP 8.x dan MySQL).
- Klien SQL: HeidiSQL (sudah ada di Laragon) atau phpMyAdmin.
- Git, VS Code (dengan ekstensi Flutter), dan Google Chrome.
- Opsional untuk Android: Android Studio dengan emulator, atau HP Android dengan USB debugging.

## Instalasi dan Menjalankan

### 1. Ambil kode

```bash
git clone https://github.com/RADITYA-198classF/NTC-FIT-KELOMPOK-1_UTS.git
cd NTC-FIT-KELOMPOK-1_UTS
flutter pub get
```

### 2. Siapkan database

1. Nyalakan MySQL (di Laragon tekan **Start All**).
2. Buka HeidiSQL atau phpMyAdmin.
3. Jalankan `backend/database/schema.sql` untuk membuat database `ntc_fit_uts` beserta tabelnya.
4. Jalankan `backend/database/seed.sql` untuk mengisi kategori, latihan, dan gerakan.

Pengaturan bawaan: host `127.0.0.1`, port `3306`, database `ntc_fit_uts`, user `root`, password kosong. Jika berbeda, ubah `backend/config.php` atau set environment variable `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASS`.

### 3. Jalankan backend

Di folder `backend`:

```bash
php -S 0.0.0.0:8000 router.php
```

Alternatif di Windows: klik dua kali `backend/run_backend.bat`. Jika perintah `php` tidak dikenali, jalankan dari **terminal Laragon**.

Tes di browser: <http://127.0.0.1:8000/api/health> harus menampilkan `status: ok` dan `database: connected`. Biarkan jendela backend tetap terbuka selama aplikasi dipakai.

### 4. Jalankan aplikasi Flutter

Di terminal lain, pada folder project:

```bash
flutter analyze
flutter run -d chrome        # pratinjau di browser
flutter run                  # emulator atau HP Android
```

Di VS Code tersedia konfigurasi **NTC Fit - Chrome** pada `.vscode/launch.json`.

Untuk pratinjau di Chrome, tekan `F12` lalu aktifkan *Toggle device toolbar* dan pilih ukuran sekitar 360 × 800 agar mirip layar HP.

### Akun demo

Proyek ini tidak memakai layanan email, sehingga kode verifikasi adalah kode demo:

| Langkah | Isian |
|---|---|
| Email | bebas, mis. `demo@ntcfit.test` |
| Kode verifikasi | `123456` (juga ditampilkan di pesan singkat saat kode diminta) |

Email baru akan didaftarkan lewat formulir data diri. Email yang sudah terdaftar masuk dengan kode yang sama. Kode demo diatur lewat variabel `DEMO_OTP` atau di `backend/config.php`.

## Konfigurasi Base URL API

Alamat API dipilih otomatis oleh `AppConfig.apiBaseUrl` di `lib/core/app_config.dart`:

| Perangkat | Base URL |
|---|---|
| Flutter Web / Chrome | `http://127.0.0.1:8000/api` |
| Emulator Android | `http://10.0.2.2:8000/api` (`localhost` di emulator bukan komputer Anda) |
| HP Android fisik | ubah ke `http://<IP-laptop>:8000/api`; HP dan laptop harus satu jaringan Wi-Fi (cek IP dengan `ipconfig`) |

## Dokumentasi API

Semua respons berformat JSON. Endpoint bertanda 🔒 memerlukan header `Authorization: Bearer <token>`.

| Method | Endpoint | Fungsi |
|---|---|---|
| GET | `/api/health` | Cek koneksi backend dan database |
| POST | `/api/auth/request-code` | Minta kode verifikasi (demo) |
| POST | `/api/auth/register` | Daftar pengguna baru |
| POST | `/api/auth/login` | Masuk pengguna terdaftar |
| POST | `/api/logout` 🔒 | Keluar |
| GET | `/api/me` 🔒 | Profil pengguna |
| PUT | `/api/me/preferences` 🔒 | Simpan jenis kelamin dan frekuensi latihan |
| DELETE | `/api/me` 🔒 | Hapus akun |
| GET | `/api/workouts` | Daftar latihan, kategori, dan gerakan |
| GET | `/api/saved` 🔒 | Latihan tersimpan |
| POST | `/api/saved/{code}` 🔒 | Simpan latihan |
| DELETE | `/api/saved/{code}` 🔒 | Batal simpan latihan |
| GET | `/api/history` 🔒 | Riwayat latihan |
| POST | `/api/history` 🔒 | Simpan hasil sesi latihan |

Koleksi Postman tersedia di `backend/NTC_Fit_API.postman_collection.json` (variabel `baseUrl` = `http://127.0.0.1:8000/api`). Panduan backend lengkap ada di [`backend/README.md`](backend/README.md).

## Skema Database

Database `ntc_fit_uts` terdiri dari delapan tabel:

| Tabel | Isi |
|---|---|
| `users` | Akun pengguna dan preferensi (jenis kelamin, frekuensi latihan) |
| `verification_codes` | Kode verifikasi |
| `workouts` | Latihan: kode, judul, level, peralatan, fokus, durasi, gambar, deskripsi |
| `exercises` | Gerakan tiap latihan (repetisi atau durasi, petunjuk, urutan) |
| `categories` | Kategori latihan |
| `category_workout` | Relasi kategori dan latihan |
| `saved_workouts` | Latihan yang disimpan pengguna |
| `workout_history` | Riwayat sesi latihan pengguna |

Definisi lengkap ada di `backend/database/schema.sql`.

## Catatan dan Asumsi

Beberapa layar tidak ada di 22 screenshot referensi sehingga dirancang mengikuti gaya layar lain:

- Daftar kategori, detail latihan, sesi timer, ringkasan, dan pemutar video. Teks di dalamnya (mis. "Langkah Latihan", "Bersiap", "Istirahat") adalah usulan, bukan salinan aplikasi asli.
- Deskripsi, gerakan, repetisi, dan durasi latihan (kecuali Cat Cow dan Quad Rocker 10 repetisi) adalah data contoh.
- Alamat di bilah browser halaman masuk memakai label `accounts.ntcfit.app` (`AppConfig.authHostLabel`), bukan domain Nike.
- Detail program, Edit Profil, Tambahkan Teman, Akses, dan submenu Pengaturan belum memiliki layar; barisnya hanya memberi efek sentuh.
- Layar tidak dijaga tetap menyala selama sesi latihan dan belum ada suara atau getar saat waktu habis.
- Foto dan video bersifat ilustrasi; warna dan tata letak mengikuti screenshot referensi.

## Pemecahan Masalah

| Gejala | Penyebab dan solusi |
|---|---|
| `php is not recognized` | PHP belum ada di PATH. Jalankan dari terminal Laragon, atau pakai `run_backend.bat`. |
| Aplikasi gagal terhubung / *Failed to fetch* | Pastikan backend menyala dan `/api/health` bisa dibuka. Cek Base URL sesuai perangkat (lihat tabel di atas). |
| Di emulator tidak bisa tersambung | Pastikan memakai `10.0.2.2`, bukan `localhost` atau `127.0.0.1`. |
| `database` tidak `connected` pada `/api/health` | MySQL belum menyala atau database `ntc_fit_uts` belum dibuat. Jalankan `schema.sql` lalu `seed.sql`, dan cek `backend/config.php`. |
| Daftar latihan kosong | `seed.sql` belum dijalankan. |
| Port 8000 sudah dipakai | Hentikan server lama, atau jalankan di port lain dan sesuaikan `AppConfig.apiBaseUrl`. |
| Muncul peringatan Windows Firewall | Pilih **Allow access** agar perangkat lain dapat menyambung. |
| Error paket setelah `git pull` | Jalankan `flutter pub get`. |
| Gambar atau video tidak tampil | Periksa nama file di `assets/` dan pastikan `assets/images/` serta `assets/videos/` terdaftar di `pubspec.yaml`. |

## Aset dan Lisensi

- Foto dan video berada di `assets/images/` dan `assets/videos/`. Daftar aset dan ukuran yang disarankan ada di `assets/images/DAFTAR_ASET.md`.
- Pastikan setiap foto dan video yang dipakai memiliki lisensi yang sesuai. Proyek ini hanya untuk keperluan tugas kuliah dan tidak untuk tujuan komersial.
- Font asli Nike tidak disertakan. Teks isi memakai font bawaan Android. Judul kondensed memakai keluarga `NTCDisplay`; untuk tampilan lebih mirip, daftarkan font bebas lisensi seperti Anton (lihat `pubspec_snippet.yaml`).
- Jangan mengunggah folder `.dart_tool/` dan `build/` ke repositori atau ke berkas ZIP pengumpulan; keduanya sudah masuk `.gitignore`.

