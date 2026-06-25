# TAHAP 1: RESUME 3 APLIKASI SEJENIS

Dalam merancang sistem inventaris "NovaBox", kami melakukan studi literatur dan observasi terhadap 3 aplikasi manajemen stok yang sudah ada di pasaran. Berikut adalah resume dari ketiga aplikasi tersebut:

## 1. Jurnal.id (Mekari)
* **Informasi Website:** Jurnal.id adalah *software* akuntansi dan inventaris *cloud-based* yang ditargetkan untuk UKM di Indonesia. Sistem ini mengintegrasikan pencatatan keuangan dengan pergerakan barang.
* **Proses Utama (Menu Penting):** Menu "Manajemen Stok / Produk".
* **Proses & Data yang Digunakan:** 
  Proses utamanya adalah pelacakan multi-gudang dan penyesuaian stok (*stock opname*). Data yang digunakan meliputi SKU barang, nama barang, harga beli rata-rata (*moving average*), batas stok minimum, dan riwayat mutasi perpindahan barang antar gudang.

## 2. Odoo (Modul Inventory)
* **Informasi Website:** Odoo adalah aplikasi ERP (*Enterprise Resource Planning*) *open-source* global yang memiliki modul *Inventory* yang sangat komprehensif.
* **Proses Utama (Menu Penting):** Menu "Inventory / Operations".
* **Proses & Data yang Digunakan:** 
  Proses utamanya adalah *Double-Entry Inventory* (tidak ada barang yang hilang, hanya berpindah lokasi). Data yang digunakan meliputi *Location* (lokasi rak/gudang), *Serial Number/Lot*, kuantitas produk, dan *Lead Time* (waktu tunggu pemesanan).

## 3. Moka POS (Modul Manajemen Stok)
* **Informasi Website:** Moka POS adalah aplikasi Kasir (Point of Sales) yang memiliki fitur manajemen stok di *back-office* mereka, cocok untuk *retail* dan *F&B*.
* **Proses Utama (Menu Penting):** Menu "Ingredient / Item Library".
* **Proses & Data yang Digunakan:** 
  Proses utamanya adalah pemotongan stok otomatis saat terjadi penjualan di kasir (*Real-time Deduction*). Data yang digunakan meliputi daftar *item/ingredient*, resep (kalkulasi bahan baku), peringatan stok rendah (*low stock alert*), dan daftar *Supplier*.

---

# TAHAP 2: REQUIREMENT APLIKASI NOVABOX

## 1. Deskripsi Aplikasi
**NovaBox** adalah aplikasi Sistem Manajemen Inventaris Berbasis Web yang dirancang dengan desain antarmuka *Neo-Brutalism* modern. Aplikasi ini berfungsi untuk membantu pemilik usaha dan staf gudang dalam mencatat pergerakan barang secara mutakhir (*real-time*), memberikan peringatan dini jika ada barang yang hampir habis, serta mengkalkulasi valuasi aset yang ada di dalam gudang secara otomatis. Aplikasi ini dibangun eksklusif menggunakan ekosistem JavaScript (React.js untuk *Frontend* dan Node.js/Express untuk *Backend*).

## 2. Data yang Digunakan
Sistem ini mengelola beberapa entitas data utama yang disimpan di dalam *database* MySQL:
* **Data Kredensial (Aktor):** Nama lengkap, Email, Kata Sandi (*Bcrypt Hashed*), dan Peran/Role (Super Admin, Admin, Manajer, Staff Gudang).
* **Data Produk:** Kode SKU unik, Nama Produk, Kategori, Lokasi Rak, Stok Aktual, Batas Minimum Stok, Harga Beli (Modal), Harga Jual, dan URL Foto Produk.
* **Data Transaksi (Mutasi):** ID Produk referensi, Jenis Mutasi (Masuk/Keluar), Jumlah unit yang dimutasi, dan *Timestamp* pencatatan.

## 3. Alur dari Fungsi Utama (*Main Function*)
Fungsi utama NovaBox adalah **Dashboard Analitik & Quick Stock**, dengan alur sebagai berikut:
1. **Otentikasi & Penentuan Akses (RBAC):** Pengguna masuk (Login). Node.js memvalidasi *password* dan memberikan token JWT berisi Peran pengguna. React.js membaca token ini untuk menyembunyikan atau menampilkan tombol sensitif (seperti menu "Hapus" yang hanya untuk Admin).
2. **Pengambilan Data (Fetch Data):** Sistem memanggil data dari tabel `tb_products`. 
3. **Komputasi Status Inventaris:** Algoritma *Backend* mengevaluasi data:
   * Jika `Stok = 0` $\rightarrow$ Status **Habis** (Merah).
   * Jika `Stok <= Batas Minimum` $\rightarrow$ Status **Butuh Re-stock** (Kuning).
   * Jika di luar kondisi di atas $\rightarrow$ Status **Aman** (Hijau).
4. **Kalkulasi Finansial:** Menjumlahkan (`Stok Aktual` $\times$ `Harga Beli`) dari seluruh barang untuk menghasilkan **Total Nilai Aset Gudang**.
5. **Quick Stock Update (Tombol +/-):** Saat staf menekan tombol (+), React.js memanggil *Endpoint PATCH* di Node.js. Server menambahkan stok di `tb_products` dan otomatis menyuntikkan catatan ke `tb_stock_logs` tanpa mengubah halaman.
