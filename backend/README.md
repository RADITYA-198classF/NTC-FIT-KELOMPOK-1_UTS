# NTC Fit REST API — UTS Pemrograman Aplikasi Bergerak

Backend ringan tanpa dependency tambahan: **PHP 8 + PDO + MySQL**. Dipilih agar mudah dijalankan di Laragon/XAMPP dan tetap memenuhi ketentuan REST API + database relasional.

## 1. Siapkan database

1. Nyalakan MySQL di Laragon/XAMPP.
2. Buka phpMyAdmin atau HeidiSQL.
3. Jalankan `database/schema.sql`.
4. Setelah itu jalankan `database/seed.sql`.

Default database: `ntc_fit_uts`, user `root`, password kosong. Jika berbeda, edit `config.php` atau set environment variable `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASS`.

## 2. Jalankan API

Di terminal pada folder `backend`:

```bash
php -S 0.0.0.0:8000 router.php
```

Tes di browser:

```text
http://127.0.0.1:8000/api/health
```

Harus menghasilkan JSON dengan `status: ok` dan `database: connected`.

## 3. Endpoint utama

| Method | Endpoint | Fungsi |
|---|---|---|
| GET | `/api/health` | cek koneksi backend/database |
| POST | `/api/auth/request-code` | minta kode OTP demo |
| POST | `/api/auth/register` | daftar user baru |
| POST | `/api/auth/login` | login user terdaftar |
| POST | `/api/logout` | logout |
| GET | `/api/me` | profil user |
| PUT | `/api/me/preferences` | simpan gender/frekuensi |
| DELETE | `/api/me` | hapus akun |
| GET | `/api/workouts` | data workout + kategori + exercise |
| GET | `/api/saved` | workout tersimpan |
| POST | `/api/saved/{code}` | simpan workout |
| DELETE | `/api/saved/{code}` | batal simpan |
| GET | `/api/history` | riwayat workout |
| POST | `/api/history` | simpan hasil sesi workout |

Kode OTP demo default: **123456**. Ini sengaja untuk demo lokal UTS karena proyek tidak memakai layanan email eksternal.

## 4. Base URL Flutter

- Android Emulator: `http://10.0.2.2:8000/api`
- Flutter Web/Chrome: `http://127.0.0.1:8000/api`

Patch Flutter sudah mengatur base URL otomatis lewat `AppConfig.apiBaseUrl`.
