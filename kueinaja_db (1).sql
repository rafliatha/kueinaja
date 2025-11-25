-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 25 Nov 2025 pada 05.29
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `kueinaja_db`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `admin`
--

CREATE TABLE `admin` (
  `id_admin` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `admin`
--

INSERT INTO `admin` (`id_admin`, `nama`, `email`, `password_hash`) VALUES
(1, 'Admin Utama', 'admin.utama@kueinaja.com', 'hashed_password_admin1'),
(2, 'Admin Verifikasi', 'admin.verifikasi@kueinaja.com', 'hashed_password_admin2'),
(3, 'Admin Promosi', 'admin.promo@kueinaja.com', 'hashed_password_admin3');

-- --------------------------------------------------------

--
-- Struktur dari tabel `alamat`
--

CREATE TABLE `alamat` (
  `id_alamat` int(11) NOT NULL,
  `id_penjual` int(11) NOT NULL,
  `judul_alamat` varchar(100) DEFAULT 'Alamat Utama',
  `detail_alamat` text NOT NULL,
  `kota` varchar(50) NOT NULL,
  `kode_pos` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `alamat`
--

INSERT INTO `alamat` (`id_alamat`, `id_penjual`, `judul_alamat`, `detail_alamat`, `kota`, `kode_pos`) VALUES
(1, 1, 'Alamat Utama', 'Jl. Pahlawan No. 10, Semarang Tengah', 'Semarang', '50241'),
(2, 2, 'Alamat Utama', 'Jl. Gajah Mada No. 25, Candisari', 'Semarang', '50257'),
(3, 3, 'Alamat Utama', 'Jl. Pemuda No. 150, Banyumanik', 'Semarang', '50264'),
(4, 4, 'Alamat Utama', 'Jl. Veteran No. 33, Gayamsari', 'Semarang', '50248'),
(5, 5, 'Alamat Utama', 'Jl. Wolter Monginsidi No. 5, Genuk', 'Semarang', '50111');

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_pesanan`
--

CREATE TABLE `detail_pesanan` (
  `id_pesanan` int(11) NOT NULL,
  `id_produk` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `harga_saat_beli` decimal(10,2) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `detail_pesanan`
--

INSERT INTO `detail_pesanan` (`id_pesanan`, `id_produk`, `jumlah`, `harga_saat_beli`, `subtotal`) VALUES
(1, 1, 1, 85000.00, 85000.00),
(1, 3, 1, 55000.00, 55000.00),
(2, 4, 1, 65000.00, 65000.00),
(3, 2, 1, 90000.00, 90000.00),
(3, 5, 1, 70000.00, 70000.00),
(4, 5, 1, 70000.00, 70000.00),
(5, 6, 1, 45000.00, 45000.00),
(5, 7, 1, 60000.00, 60000.00),
(6, 8, 1, 250000.00, 250000.00),
(7, 1, 1, 85000.00, 85000.00),
(8, 9, 1, 110000.00, 110000.00);

--
-- Trigger `detail_pesanan`
--
DELIMITER $$
CREATE TRIGGER `CegahStokMinus` BEFORE INSERT ON `detail_pesanan` FOR EACH ROW BEGIN
    DECLARE stok_saat_ini INT;
    
    -- 1. Ambil data stok produk yang mau dibeli
    SELECT stok INTO stok_saat_ini FROM `produk` WHERE id_produk = NEW.id_produk;
    
    -- 2. Cek apakah jumlah beli (NEW.jumlah) melebihi stok
    IF NEW.jumlah > stok_saat_ini THEN
        -- 3. Jika ya, GAGALKAN transaksi ini dan beri pesan error
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stok tidak mencukupi untuk produk ini!';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `KurangiStok_SetelahPesan` AFTER INSERT ON `detail_pesanan` FOR EACH ROW BEGIN
    UPDATE `produk`
    SET stok = stok - NEW.jumlah
    WHERE id_produk = NEW.id_produk;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `UpdateTotalHarga_Kurang` AFTER DELETE ON `detail_pesanan` FOR EACH ROW BEGIN
    UPDATE `pesanan`
    SET total_harga = total_harga - OLD.subtotal
    WHERE id_pesanan = OLD.id_pesanan;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `UpdateTotalHarga_Tambah` AFTER INSERT ON `detail_pesanan` FOR EACH ROW BEGIN
    UPDATE `pesanan`
    SET total_harga = total_harga + NEW.subtotal
    WHERE id_pesanan = NEW.id_pesanan;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `kategori_produk`
--

CREATE TABLE `kategori_produk` (
  `id_kategori` int(11) NOT NULL,
  `nama_kategori` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kategori_produk`
--

INSERT INTO `kategori_produk` (`id_kategori`, `nama_kategori`, `deskripsi`) VALUES
(1, 'Kue Kering Klasik', 'Kue kering tradisional seperti Nastar, Kastengel, dll.'),
(2, 'Cookies Modern', 'Inovasi kue kering dengan rasa dan bentuk modern.'),
(3, 'Kue Rendah Gula', 'Kue kering yang diformulasikan khusus untuk penderita diabetes atau diet rendah gula.'),
(4, 'Kue Kering Gurih', 'Kue kering dengan cita rasa asin atau gurih, seperti kue bawang atau cheese stick.'),
(5, 'Paket Hampers', 'Paket gabungan beberapa jenis kue kering untuk hadiah.');

-- --------------------------------------------------------

--
-- Struktur dari tabel `konsumen`
--

CREATE TABLE `konsumen` (
  `id_konsumen` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `no_telepon` varchar(20) DEFAULT NULL,
  `tanggal_daftar` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `konsumen`
--

INSERT INTO `konsumen` (`id_konsumen`, `nama`, `email`, `password_hash`, `no_telepon`, `tanggal_daftar`) VALUES
(1, 'Budi Santoso', 'budi.s@example.com', 'hashed_password_budi', '081234567890', '2025-10-21 03:17:55'),
(2, 'Citra Lestari', 'citra.l@example.com', 'hashed_password_citra', '081234567891', '2025-10-21 03:17:55'),
(3, 'Dewi Anggraini', 'dewi.a@example.com', 'hashed_password_dewi', '081234567892', '2025-10-21 03:17:55'),
(4, 'Eko Prasetyo', 'eko.p@example.com', 'hashed_password_eko', '081234567893', '2025-10-21 03:17:55'),
(5, 'Fajar Nugroho', 'fajar.n@example.com', 'hashed_password_fajar', '081234567894', '2025-10-21 03:17:55'),
(6, 'Gita Permata', 'gita.p@example.com', 'hashed_password_gita', '081234567895', '2025-10-21 03:17:55');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kurir`
--

CREATE TABLE `kurir` (
  `id_kurir` int(11) NOT NULL,
  `nama_kurir` varchar(50) NOT NULL,
  `service_type` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kurir`
--

INSERT INTO `kurir` (`id_kurir`, `nama_kurir`, `service_type`) VALUES
(1, 'JNE', 'Reguler'),
(2, 'GoSend', 'Instant'),
(3, 'GrabExpress', 'Sameday'),
(4, 'SiCepat', 'Reguler');

-- --------------------------------------------------------

--
-- Struktur dari tabel `log_status_pesanan`
--

CREATE TABLE `log_status_pesanan` (
  `id_log` int(11) NOT NULL,
  `id_pesanan` int(11) DEFAULT NULL,
  `tanggal_ubah` timestamp NOT NULL DEFAULT current_timestamp(),
  `status_lama` varchar(50) DEFAULT NULL,
  `status_baru` varchar(50) DEFAULT NULL,
  `diubah_oleh` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `penjual`
--

CREATE TABLE `penjual` (
  `id_penjual` int(11) NOT NULL,
  `id_admin_verifikator` int(11) DEFAULT NULL,
  `nama_toko` varchar(100) NOT NULL,
  `nama_pemilik` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `deskripsi_toko` text DEFAULT NULL,
  `status` enum('pending','verified','rejected') DEFAULT 'pending',
  `tanggal_daftar` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `penjual`
--

INSERT INTO `penjual` (`id_penjual`, `id_admin_verifikator`, `nama_toko`, `nama_pemilik`, `email`, `password_hash`, `deskripsi_toko`, `status`, `tanggal_daftar`) VALUES
(1, 2, 'Rara Bakery', 'Rara Kumalasari', 'rara.bakery@example.com', 'hashed_password_rara', NULL, 'verified', '2025-10-21 03:17:55'),
(2, 2, 'Cookies by Mama', 'Indah Permata', 'cookies.mama@example.com', 'hashed_password_indah', NULL, 'verified', '2025-10-21 03:17:55'),
(3, 1, 'Kue Sehat Semarang', 'Joko Susilo', 'kuesehat.smg@example.com', 'hashed_password_joko', NULL, 'verified', '2025-10-21 03:17:55'),
(4, 2, 'Dapur Nyonya', 'Lina Hartono', 'nyonya.dapur@example.com', 'hashed_password_lina', NULL, 'verified', '2025-10-21 03:17:55'),
(5, NULL, 'Cemilan Asin Laris', 'Bambang Irawan', 'cemilan.laris@example.com', 'hashed_password_bambang', NULL, 'pending', '2025-10-21 03:17:55');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pesan`
--

CREATE TABLE `pesan` (
  `id_pesan` int(11) NOT NULL,
  `id_pengirim` int(11) NOT NULL,
  `id_penerima` int(11) NOT NULL,
  `tipe_pengirim` enum('konsumen','penjual') NOT NULL,
  `tipe_penerima` enum('konsumen','penjual') NOT NULL,
  `isi_pesan` text NOT NULL,
  `waktu_kirim` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pesan`
--

INSERT INTO `pesan` (`id_pesan`, `id_pengirim`, `id_penerima`, `tipe_pengirim`, `tipe_penerima`, `isi_pesan`, `waktu_kirim`) VALUES
(1, 2, 1, 'konsumen', 'penjual', 'Halo Kak, untuk hampers lebaran apakah bisa custom isinya?', '2025-10-21 03:17:55'),
(2, 1, 2, 'penjual', 'konsumen', 'Halo Kak Citra, tentu bisa. Mau diisi kue apa saja dan berapa toples?', '2025-10-21 03:17:55'),
(3, 2, 1, 'konsumen', 'penjual', 'Saya mau 2 nastar dan 1 kastengel ya.', '2025-10-21 03:17:55'),
(4, 4, 4, 'konsumen', 'penjual', 'Kak, kue bawangnya ready? Mau pesan 5 toples.', '2025-10-21 03:17:55'),
(5, 4, 4, 'penjual', 'konsumen', 'Ready Kak Eko, silakan diorder.', '2025-10-21 03:17:55');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pesanan`
--

CREATE TABLE `pesanan` (
  `id_pesanan` int(11) NOT NULL,
  `id_konsumen` int(11) NOT NULL,
  `id_kurir` int(11) NOT NULL,
  `id_voucher` int(11) DEFAULT NULL,
  `tanggal_pesanan` timestamp NOT NULL DEFAULT current_timestamp(),
  `total_harga` decimal(12,2) NOT NULL,
  `alamat_pengiriman` text NOT NULL,
  `status_pesanan` varchar(50) NOT NULL,
  `no_resi` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pesanan`
--

INSERT INTO `pesanan` (`id_pesanan`, `id_konsumen`, `id_kurir`, `id_voucher`, `tanggal_pesanan`, `total_harga`, `alamat_pengiriman`, `status_pesanan`, `no_resi`) VALUES
(1, 1, 1, 2, '2025-10-21 03:17:55', 140000.00, 'Jl. Majapahit No. 1, Semarang', 'selesai', 'JNE0012345678'),
(2, 2, 2, NULL, '2025-10-21 03:17:55', 65000.00, 'Jl. Siliwangi No. 2, Semarang Barat', 'selesai', 'GOSEND-XYZ123'),
(3, 1, 3, 1, '2025-10-21 03:17:55', 135000.00, 'Jl. Majapahit No. 1, Semarang', 'selesai', 'GRAB-ABC987'),
(4, 3, 4, 4, '2025-10-21 03:17:55', 70000.00, 'Jl. Tentara Pelajar No. 5, Mijen', 'dikirim', 'SICEPAT-001A'),
(5, 4, 1, NULL, '2025-10-21 03:17:55', 105000.00, 'Jl. Imam Bonjol No. 12, Semarang Utara', 'diproses', NULL),
(6, 2, 2, 3, '2025-10-21 03:17:55', 225000.00, 'Jl. Siliwangi No. 2, Semarang Barat', 'selesai', 'GOSEND-DEF456'),
(7, 5, 3, 4, '2025-10-21 03:17:55', 85000.00, 'Jl. Fatmawati No. 8, Pedurungan', 'selesai', 'GRAB-GHI789'),
(8, 6, 1, NULL, '2025-10-21 03:17:55', 110000.00, 'Jl. Kedungmundu Raya No. 10, Tembalang', 'diproses', NULL);

--
-- Trigger `pesanan`
--
DELIMITER $$
CREATE TRIGGER `LogStatusPesanan` AFTER UPDATE ON `pesanan` FOR EACH ROW BEGIN
    -- Hanya jalankan jika kolom 'status_pesanan' yang berubah
    IF OLD.status_pesanan <> NEW.status_pesanan THEN
        INSERT INTO `log_status_pesanan` 
            (id_pesanan, status_lama, status_baru, diubah_oleh)
        VALUES 
            (NEW.id_pesanan, OLD.status_pesanan, NEW.status_pesanan, USER());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `produk`
--

CREATE TABLE `produk` (
  `id_produk` int(11) NOT NULL,
  `id_penjual` int(11) NOT NULL,
  `id_kategori` int(11) NOT NULL,
  `nama_produk` varchar(255) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `harga` decimal(10,2) NOT NULL,
  `berat_gram` int(11) NOT NULL,
  `stok` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `produk`
--

INSERT INTO `produk` (`id_produk`, `id_penjual`, `id_kategori`, `nama_produk`, `deskripsi`, `harga`, `berat_gram`, `stok`) VALUES
(1, 1, 1, 'Nastar Premium Wisman', 'Nastar lembut dengan isian nanas asli dan mentega Wisman.', 85000.00, 500, 50),
(2, 1, 1, 'Kastengel Keju Edam', 'Kastengel renyah dengan rasa keju Edam yang kuat.', 90000.00, 500, 40),
(3, 2, 2, 'Choco Chips Cookies', 'Cookies renyah dengan taburan choco chips melimpah.', 55000.00, 350, 100),
(4, 2, 2, 'Red Velvet Cookies', 'Cookies kekinian dengan rasa red velvet dan isian cream cheese.', 65000.00, 300, 75),
(5, 3, 3, 'Oatmeal Cookies (Rendah Gula)', 'Cookies sehat dari oatmeal, cocok untuk diet.', 70000.00, 400, 30),
(6, 4, 4, 'Kue Bawang Super Renyah', 'Kue bawang tradisional renyah dan gurih.', 45000.00, 500, 80),
(7, 4, 4, 'Cheese Stick Premium', 'Stik keju gurih menggunakan keju cheddar impor.', 60000.00, 450, 60),
(8, 1, 5, 'Hampers Lebaran \"Barokah\"', 'Paket 3 toples (Nastar, Kastengel, Putri Salju).', 250000.00, 1500, 20),
(9, 2, 5, 'Paket Cookies \"Joy\"', 'Paket 2 toples (Choco Chips, Red Velvet).', 110000.00, 650, 30),
(10, 3, 3, 'Almond Cookies (Gluten Free)', 'Kue kering almond bebas gluten dan rendah gula.', 95000.00, 300, 25);

-- --------------------------------------------------------

--
-- Struktur dari tabel `refund`
--

CREATE TABLE `refund` (
  `id_refund` int(11) NOT NULL,
  `id_pesanan` int(11) NOT NULL,
  `id_admin_mediator` int(11) DEFAULT NULL,
  `tanggal_pengajuan` timestamp NOT NULL DEFAULT current_timestamp(),
  `alasan` text NOT NULL,
  `status_refund` enum('diajukan','ditinjau','disetujui','ditolak') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `refund`
--

INSERT INTO `refund` (`id_refund`, `id_pesanan`, `id_admin_mediator`, `tanggal_pengajuan`, `alasan`, `status_refund`) VALUES
(1, 1, 1, '2025-10-21 03:17:55', 'Nastar yang diterima sedikit hancur.', 'disetujui'),
(2, 7, 2, '2025-10-21 03:17:55', 'Pesanan salah kirim. Saya pesan Nastar, yang datang Kastengel.', 'ditolak');

-- --------------------------------------------------------

--
-- Struktur dari tabel `ulasan`
--

CREATE TABLE `ulasan` (
  `id_ulasan` int(11) NOT NULL,
  `id_konsumen` int(11) NOT NULL,
  `id_produk` int(11) NOT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `komentar` text DEFAULT NULL,
  `tanggal_ulasan` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `ulasan`
--

INSERT INTO `ulasan` (`id_ulasan`, `id_konsumen`, `id_produk`, `rating`, `komentar`, `tanggal_ulasan`) VALUES
(1, 1, 1, 4, 'Nastarnya enak, tapi packingnya kurang aman jadi ada yg retak.', '2025-10-21 03:17:55'),
(2, 1, 3, 5, 'Cookiesnya mantap, anak saya suka!', '2025-10-21 03:17:55'),
(3, 2, 4, 5, 'Perfect! Red velvet cookiesnya juara!', '2025-10-21 03:17:55'),
(4, 1, 2, 5, 'Kastengelnya benar-benar pakai keju Edam asli, rasanya mantap.', '2025-10-21 03:17:55'),
(5, 3, 5, 5, 'Akhirnya nemu cookies rendah gula yang enak. Suka banget!', '2025-10-21 03:17:55'),
(6, 4, 6, 5, 'Kue bawangnya gurih, renyah, ga berhenti ngunyah.', '2025-10-21 03:17:55'),
(7, 4, 7, 4, 'Cheese sticknya enak, tapi harganya agak mahal ya.', '2025-10-21 03:17:55'),
(8, 2, 8, 5, 'Hampersnya cantik, kuenya enak semua. Puas.', '2025-10-21 03:17:55');

--
-- Trigger `ulasan`
--
DELIMITER $$
CREATE TRIGGER `CegahUlasanGanda` BEFORE INSERT ON `ulasan` FOR EACH ROW BEGIN
    DECLARE jumlah_ulasan_ada INT;

    -- 1. Cek apakah sudah ada ulasan dari konsumen ini untuk produk ini
    SELECT COUNT(*) INTO jumlah_ulasan_ada FROM `ulasan`
    WHERE id_konsumen = NEW.id_konsumen AND id_produk = NEW.id_produk;
    
    -- 2. Jika sudah ada (jumlah_ulasan_ada > 0), gagalkan
    IF jumlah_ulasan_ada > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Anda sudah pernah memberikan ulasan untuk produk ini!';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `voucher`
--

CREATE TABLE `voucher` (
  `id_voucher` int(11) NOT NULL,
  `kode_voucher` varchar(50) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `tipe` enum('persentase','nominal','gratis_ongkir') NOT NULL,
  `nilai` decimal(10,2) NOT NULL,
  `minimum_pembelian` decimal(10,2) DEFAULT NULL,
  `tanggal_mulai` timestamp NOT NULL DEFAULT current_timestamp(),
  `tanggal_kedaluwarsa` datetime NOT NULL,
  `kuota` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `voucher`
--

INSERT INTO `voucher` (`id_voucher`, `kode_voucher`, `deskripsi`, `tipe`, `nilai`, `minimum_pembelian`, `tanggal_mulai`, `tanggal_kedaluwarsa`, `kuota`) VALUES
(1, 'HEMAT20K', 'Potongan harga Rp 20.000', 'nominal', 20000.00, 100000.00, '2025-10-21 03:17:55', '2025-12-31 23:59:59', 100),
(2, 'KIRIMGRATIS', 'Gratis ongkos kirim hingga Rp 15.000', 'gratis_ongkir', 15000.00, 50000.00, '2025-10-21 03:17:55', '2025-11-30 23:59:59', 200),
(3, 'DISKON10PERSEN', 'Diskon 10% untuk semua produk', 'persentase', 10.00, 80000.00, '2025-10-21 03:17:55', '2025-10-31 23:59:59', 150),
(4, 'PELANGGANBARU', 'Diskon Rp 25.000 untuk pesanan pertama', 'nominal', 25000.00, 50000.00, '2025-10-21 03:17:55', '2025-12-31 23:59:59', 500),
(5, 'BELI2GRATIS1', 'Promo Beli 2 Gratis 1 (T&C Apply)', 'nominal', 0.00, 150000.00, '2025-10-21 03:17:55', '2025-11-15 23:59:59', 50);

-- --------------------------------------------------------

--
-- Struktur dari tabel `wishlist`
--

CREATE TABLE `wishlist` (
  `id_konsumen` int(11) NOT NULL,
  `id_produk` int(11) NOT NULL,
  `tanggal_ditambahkan` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `wishlist`
--

INSERT INTO `wishlist` (`id_konsumen`, `id_produk`, `tanggal_ditambahkan`) VALUES
(1, 6, '2025-10-21 03:17:55'),
(1, 7, '2025-10-21 03:17:55'),
(2, 1, '2025-10-21 03:17:55'),
(3, 4, '2025-10-21 03:17:55'),
(3, 5, '2025-10-21 03:17:55'),
(4, 10, '2025-10-21 03:17:55'),
(5, 8, '2025-10-21 03:17:55'),
(6, 1, '2025-10-21 03:17:55');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id_admin`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indeks untuk tabel `alamat`
--
ALTER TABLE `alamat`
  ADD PRIMARY KEY (`id_alamat`),
  ADD UNIQUE KEY `id_penjual` (`id_penjual`);

--
-- Indeks untuk tabel `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD PRIMARY KEY (`id_pesanan`,`id_produk`),
  ADD KEY `id_produk` (`id_produk`);

--
-- Indeks untuk tabel `kategori_produk`
--
ALTER TABLE `kategori_produk`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indeks untuk tabel `konsumen`
--
ALTER TABLE `konsumen`
  ADD PRIMARY KEY (`id_konsumen`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indeks untuk tabel `kurir`
--
ALTER TABLE `kurir`
  ADD PRIMARY KEY (`id_kurir`);

--
-- Indeks untuk tabel `log_status_pesanan`
--
ALTER TABLE `log_status_pesanan`
  ADD PRIMARY KEY (`id_log`);

--
-- Indeks untuk tabel `penjual`
--
ALTER TABLE `penjual`
  ADD PRIMARY KEY (`id_penjual`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `id_admin_verifikator` (`id_admin_verifikator`);

--
-- Indeks untuk tabel `pesan`
--
ALTER TABLE `pesan`
  ADD PRIMARY KEY (`id_pesan`);

--
-- Indeks untuk tabel `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`id_pesanan`),
  ADD KEY `id_konsumen` (`id_konsumen`),
  ADD KEY `id_kurir` (`id_kurir`),
  ADD KEY `id_voucher` (`id_voucher`);

--
-- Indeks untuk tabel `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id_produk`),
  ADD KEY `id_penjual` (`id_penjual`),
  ADD KEY `id_kategori` (`id_kategori`);

--
-- Indeks untuk tabel `refund`
--
ALTER TABLE `refund`
  ADD PRIMARY KEY (`id_refund`),
  ADD UNIQUE KEY `id_pesanan` (`id_pesanan`),
  ADD KEY `id_admin_mediator` (`id_admin_mediator`);

--
-- Indeks untuk tabel `ulasan`
--
ALTER TABLE `ulasan`
  ADD PRIMARY KEY (`id_ulasan`),
  ADD KEY `id_konsumen` (`id_konsumen`),
  ADD KEY `id_produk` (`id_produk`);

--
-- Indeks untuk tabel `voucher`
--
ALTER TABLE `voucher`
  ADD PRIMARY KEY (`id_voucher`),
  ADD UNIQUE KEY `kode_voucher` (`kode_voucher`);

--
-- Indeks untuk tabel `wishlist`
--
ALTER TABLE `wishlist`
  ADD PRIMARY KEY (`id_konsumen`,`id_produk`),
  ADD KEY `id_produk` (`id_produk`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `admin`
--
ALTER TABLE `admin`
  MODIFY `id_admin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `alamat`
--
ALTER TABLE `alamat`
  MODIFY `id_alamat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `kategori_produk`
--
ALTER TABLE `kategori_produk`
  MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `konsumen`
--
ALTER TABLE `konsumen`
  MODIFY `id_konsumen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `kurir`
--
ALTER TABLE `kurir`
  MODIFY `id_kurir` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `log_status_pesanan`
--
ALTER TABLE `log_status_pesanan`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `penjual`
--
ALTER TABLE `penjual`
  MODIFY `id_penjual` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `pesan`
--
ALTER TABLE `pesan`
  MODIFY `id_pesan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `id_pesanan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `produk`
--
ALTER TABLE `produk`
  MODIFY `id_produk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `refund`
--
ALTER TABLE `refund`
  MODIFY `id_refund` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `ulasan`
--
ALTER TABLE `ulasan`
  MODIFY `id_ulasan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `voucher`
--
ALTER TABLE `voucher`
  MODIFY `id_voucher` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `alamat`
--
ALTER TABLE `alamat`
  ADD CONSTRAINT `alamat_ibfk_1` FOREIGN KEY (`id_penjual`) REFERENCES `penjual` (`id_penjual`);

--
-- Ketidakleluasaan untuk tabel `detail_pesanan`
--
ALTER TABLE `detail_pesanan`
  ADD CONSTRAINT `detail_pesanan_ibfk_1` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`),
  ADD CONSTRAINT `detail_pesanan_ibfk_2` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`);

--
-- Ketidakleluasaan untuk tabel `penjual`
--
ALTER TABLE `penjual`
  ADD CONSTRAINT `penjual_ibfk_1` FOREIGN KEY (`id_admin_verifikator`) REFERENCES `admin` (`id_admin`);

--
-- Ketidakleluasaan untuk tabel `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`id_konsumen`) REFERENCES `konsumen` (`id_konsumen`),
  ADD CONSTRAINT `pesanan_ibfk_2` FOREIGN KEY (`id_kurir`) REFERENCES `kurir` (`id_kurir`),
  ADD CONSTRAINT `pesanan_ibfk_3` FOREIGN KEY (`id_voucher`) REFERENCES `voucher` (`id_voucher`);

--
-- Ketidakleluasaan untuk tabel `produk`
--
ALTER TABLE `produk`
  ADD CONSTRAINT `produk_ibfk_1` FOREIGN KEY (`id_penjual`) REFERENCES `penjual` (`id_penjual`),
  ADD CONSTRAINT `produk_ibfk_2` FOREIGN KEY (`id_kategori`) REFERENCES `kategori_produk` (`id_kategori`);

--
-- Ketidakleluasaan untuk tabel `refund`
--
ALTER TABLE `refund`
  ADD CONSTRAINT `refund_ibfk_1` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`),
  ADD CONSTRAINT `refund_ibfk_2` FOREIGN KEY (`id_admin_mediator`) REFERENCES `admin` (`id_admin`);

--
-- Ketidakleluasaan untuk tabel `ulasan`
--
ALTER TABLE `ulasan`
  ADD CONSTRAINT `ulasan_ibfk_1` FOREIGN KEY (`id_konsumen`) REFERENCES `konsumen` (`id_konsumen`),
  ADD CONSTRAINT `ulasan_ibfk_2` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`);

--
-- Ketidakleluasaan untuk tabel `wishlist`
--
ALTER TABLE `wishlist`
  ADD CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`id_konsumen`) REFERENCES `konsumen` (`id_konsumen`),
  ADD CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
