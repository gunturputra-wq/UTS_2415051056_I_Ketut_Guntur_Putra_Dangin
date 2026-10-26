# BookNest — Aplikasi Eksplorasi dan Koleksi Buku

BookNest adalah aplikasi mobile berbasis Flutter yang membantu pengguna menjelajahi buku dan mengelola koleksi bacaan pribadi. Aplikasi ini dikembangkan sebagai proyek Ujian Tengah Semester (UTS) mata kuliah Aplikasi Mobile.

## Fitur Utama

- **Home:** Menampilkan halaman utama dan akses ke fitur aplikasi.
- **Explore:** Menjelajahi buku melalui Open Library API.
- **Book Detail:** Melihat informasi buku yang dipilih.
- **My Library:** Menyimpan dan menampilkan koleksi bacaan pribadi.
- **Tambah Buku:** Menambahkan buku ke koleksi.
- **Edit Buku:** Memperbarui status membaca dan catatan buku.
- **Hapus Buku:** Menghapus buku dari koleksi.
- **Profile:** Menampilkan halaman profil pengguna.

## Teknologi yang Digunakan

- Flutter dan Dart untuk pengembangan aplikasi.
- Provider dan ChangeNotifier untuk pengelolaan state.
- Open Library API untuk mengambil informasi buku.
- Supabase dan PostgreSQL untuk penyimpanan koleksi bacaan.
- Git dan GitHub untuk version control.

## Arsitektur Aplikasi

Proyek menggunakan pemisahan tanggung jawab agar kode lebih mudah dikelola:

- **Models:** Mendefinisikan struktur data buku dan catatan bacaan.
- **Services:** Menangani komunikasi dengan API dan database.
- **Repositories:** Menyediakan lapisan akses data.
- **Providers:** Mengelola state dan proses bisnis aplikasi.
- **Screens:** Menampilkan halaman utama aplikasi.
- **Widgets:** Menyediakan komponen antarmuka yang dapat digunakan kembali.
- **Config:** Menyimpan konfigurasi layanan eksternal.

## Persyaratan

- Flutter SDK yang kompatibel dengan proyek.
- Dart SDK yang disertakan dengan Flutter.
- Koneksi internet untuk mengakses Open Library API dan Supabase.
- Proyek Supabase dengan tabel `reading_notes` yang telah dikonfigurasi.

## Cara Menjalankan

1. Clone repository GitHub.
2. Buka folder proyek di terminal.
3. Instal dependensi.
4. Konfigurasikan URL dan publishable key Supabase pada file konfigurasi lokal.
5. Jalankan aplikasi.

```bash
git clone https://github.com/gunturputra-wq/UTS_2415051056_I_Ketut_Guntur_Putra_Dangin.git
cd UTS_2415051056_I_Ketut_Guntur_Putra_Dangin
flutter pub get
flutter run
```

Pastikan konfigurasi Supabase telah diisi sebelum menjalankan aplikasi.

## Pengujian

Jalankan analisis kode dan pengujian otomatis menggunakan perintah berikut:

```bash
flutter analyze
flutter test
```

Pengujian widget mencakup tampilan halaman Home dan navigasi utama. Pengujian manual juga dilakukan untuk memeriksa fungsi tambah