-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 03, 2025 at 04:10 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `kueinaja_rev`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id_admin` int(11) NOT NULL,
  `nama_admin` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id_admin`, `nama_admin`, `email`, `password`) VALUES
(1, 'Budi Santoso', 'admin.budi@kueinaja.com', 'rahasia123'),
(2, 'Sari Wulandari', 'admin.sari@kueinaja.com', 'rahasia456');

-- --------------------------------------------------------

--
-- Table structure for table `kategori_produk`
--

CREATE TABLE `kategori_produk` (
  `id_kategori` int(11) NOT NULL,
  `nama_kategori` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kategori_produk`
--

INSERT INTO `kategori_produk` (`id_kategori`, `nama_kategori`, `deskripsi`) VALUES
(1, 'Kue Kering Klasik', 'Aneka kue kering tradisional tahan lama'),
(2, 'Kue Basah & Cake', 'Brownies, bolu, dan kue basah lainnya'),
(3, 'Paket Hampers', 'Paket bingkisan untuk hari raya');

-- --------------------------------------------------------

--
-- Table structure for table `konsumen`
--

CREATE TABLE `konsumen` (
  `id_konsumen` int(11) NOT NULL,
  `nama_lengkap` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `alamat_lengkap` text DEFAULT NULL,
  `no_telepon` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `konsumen`
--

INSERT INTO `konsumen` (`id_konsumen`, `nama_lengkap`, `email`, `alamat_lengkap`, `no_telepon`) VALUES
(1, 'Siti Aminah', 'siti.a@gmail.com', 'Jl. Merpati No. 10, Jakarta', '081234567890'),
(2, 'Rudi Hermawan', 'rudi.h@yahoo.com', 'Jl. Kenari No. 5, Bandung', '081298765432'),
(3, 'Linda Kusuma', 'linda.k@gmail.com', 'Komp. Gading Asri Blok B, Surabaya', '081345678901');

-- --------------------------------------------------------

--
-- Table structure for table `kurir`
--

CREATE TABLE `kurir` (
  `id_kurir` int(11) NOT NULL,
  `nama_kurir` varchar(100) NOT NULL,
  `jenis_layanan` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kurir`
--

INSERT INTO `kurir` (`id_kurir`, `nama_kurir`, `jenis_layanan`) VALUES
(1, 'JNE', 'Reguler'),
(2, 'GoSend', 'Instant (Sameday)'),
(3, 'SiCepat', 'Express');

-- --------------------------------------------------------

--
-- Table structure for table `penjual`
--

CREATE TABLE `penjual` (
  `id_penjual` int(11) NOT NULL,
  `id_admin` int(11) DEFAULT NULL,
  `nama_toko` varchar(100) NOT NULL,
  `nama_pemilik` varchar(100) DEFAULT NULL,
  `alamat_toko` text DEFAULT NULL,
  `status_verifikasi` enum('Pending','Verified') DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `penjual`
--

INSERT INTO `penjual` (`id_penjual`, `id_admin`, `nama_toko`, `nama_pemilik`, `alamat_toko`, `status_verifikasi`) VALUES
(1, 1, 'Rara Bakery', 'Rara Sekar', 'Jl. Ahmad Yani No. 12, Jakarta', 'Verified'),
(2, 1, 'Dapur Mama', 'Mama Dedeh', 'Jl. Asia Afrika No. 88, Bandung', 'Verified');

-- --------------------------------------------------------

--
-- Table structure for table `pesanan`
--

CREATE TABLE `pesanan` (
  `id_pesanan` int(11) NOT NULL,
  `id_konsumen` int(11) NOT NULL,
  `id_produk` int(11) NOT NULL,
  `id_kurir` int(11) NOT NULL,
  `tanggal_pesanan` date DEFAULT NULL,
  `jumlah_beli` int(11) NOT NULL,
  `total_harga` decimal(12,2) DEFAULT NULL,
  `status` enum('Diproses','Dikirim','Selesai') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pesanan`
--

INSERT INTO `pesanan` (`id_pesanan`, `id_konsumen`, `id_produk`, `id_kurir`, `tanggal_pesanan`, `jumlah_beli`, `total_harga`, `status`) VALUES
(1, 1, 1, 1, '2025-11-01', 2, 170000.00, 'Selesai'),
(2, 2, 5, 2, '2025-11-02', 1, 65000.00, 'Dikirim'),
(3, 1, 6, 1, '2025-11-03', 1, 150000.00, 'Diproses'),
(4, 3, 4, 3, '2025-11-05', 2, 500000.00, 'Diproses');

-- --------------------------------------------------------

--
-- Table structure for table `produk`
--

CREATE TABLE `produk` (
  `id_produk` int(11) NOT NULL,
  `id_penjual` int(11) NOT NULL,
  `id_kategori` int(11) NOT NULL,
  `nama_produk` varchar(100) NOT NULL,
  `deskripsi_produk` text DEFAULT NULL,
  `harga` decimal(10,2) NOT NULL,
  `stok` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `produk`
--

INSERT INTO `produk` (`id_produk`, `id_penjual`, `id_kategori`, `nama_produk`, `deskripsi_produk`, `harga`, `stok`) VALUES
(1, 1, 1, 'Nastar Premium Wisman', 'Nastar nanas asli dengan butter wisman', 90000.00, 100),
(2, 1, 1, 'Kastengel Keju Edam', 'Renyah dengan taburan keju edam melimpah', 95000.00, 50),
(3, 1, 1, 'Putri Salju Mete', 'Lumer di mulut dengan kacang mete', 75000.00, 60),
(4, 1, 3, 'Hampers Idul Fitri A', 'Paket isi Nastar, Kastengel, dan Putri Salju', 250000.00, 10),
(5, 2, 2, 'Fudgy Brownies Sekat', 'Brownies coklat leleh ukuran 20x20', 65000.00, 30),
(6, 2, 2, 'Lapis Legit Prunes', 'Lapis legit basah dengan toping prunes', 150000.00, 15),
(7, 2, 1, 'Lidah Kucing Rainbow', 'Kue lidah kucing warna-warni', 55000.00, 45),
(8, 2, 2, 'Japanese Cheese Cake', 'Bolu keju super lembut ala Jepang', 80000.00, 20),
(9, 1, 2, 'Bolu Gulung Meranti', NULL, 60000.00, 25);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_kataloglengkap`
-- (See below for the actual view)
--
CREATE TABLE `view_kataloglengkap` (
`id_produk` int(11)
,`nama_produk` varchar(100)
,`harga` decimal(10,2)
,`stok` int(11)
,`nama_kategori` varchar(100)
,`nama_toko` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_laporanpenjualan`
-- (See below for the actual view)
--
CREATE TABLE `view_laporanpenjualan` (
`tanggal_pesanan` date
,`nama_produk` varchar(100)
,`jumlah_beli` int(11)
,`total_harga` decimal(12,2)
);

-- --------------------------------------------------------

--
-- Structure for view `view_kataloglengkap`
--
DROP TABLE IF EXISTS `view_kataloglengkap`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_kataloglengkap`  AS SELECT `p`.`id_produk` AS `id_produk`, `p`.`nama_produk` AS `nama_produk`, `p`.`harga` AS `harga`, `p`.`stok` AS `stok`, `k`.`nama_kategori` AS `nama_kategori`, `t`.`nama_toko` AS `nama_toko` FROM ((`produk` `p` join `kategori_produk` `k` on(`p`.`id_kategori` = `k`.`id_kategori`)) join `penjual` `t` on(`p`.`id_penjual` = `t`.`id_penjual`)) ;

-- --------------------------------------------------------

--
-- Structure for view `view_laporanpenjualan`
--
DROP TABLE IF EXISTS `view_laporanpenjualan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_laporanpenjualan`  AS SELECT `pe`.`tanggal_pesanan` AS `tanggal_pesanan`, `pr`.`nama_produk` AS `nama_produk`, `pe`.`jumlah_beli` AS `jumlah_beli`, `pe`.`total_harga` AS `total_harga` FROM (`pesanan` `pe` join `produk` `pr` on(`pe`.`id_produk` = `pr`.`id_produk`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id_admin`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `kategori_produk`
--
ALTER TABLE `kategori_produk`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indexes for table `konsumen`
--
ALTER TABLE `konsumen`
  ADD PRIMARY KEY (`id_konsumen`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `kurir`
--
ALTER TABLE `kurir`
  ADD PRIMARY KEY (`id_kurir`);

--
-- Indexes for table `penjual`
--
ALTER TABLE `penjual`
  ADD PRIMARY KEY (`id_penjual`),
  ADD KEY `id_admin` (`id_admin`);

--
-- Indexes for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD PRIMARY KEY (`id_pesanan`),
  ADD KEY `id_konsumen` (`id_konsumen`),
  ADD KEY `id_produk` (`id_produk`),
  ADD KEY `id_kurir` (`id_kurir`);

--
-- Indexes for table `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id_produk`),
  ADD KEY `id_penjual` (`id_penjual`),
  ADD KEY `id_kategori` (`id_kategori`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id_admin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `kategori_produk`
--
ALTER TABLE `kategori_produk`
  MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `konsumen`
--
ALTER TABLE `konsumen`
  MODIFY `id_konsumen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `kurir`
--
ALTER TABLE `kurir`
  MODIFY `id_kurir` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `penjual`
--
ALTER TABLE `penjual`
  MODIFY `id_penjual` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `pesanan`
--
ALTER TABLE `pesanan`
  MODIFY `id_pesanan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `produk`
--
ALTER TABLE `produk`
  MODIFY `id_produk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `penjual`
--
ALTER TABLE `penjual`
  ADD CONSTRAINT `penjual_ibfk_1` FOREIGN KEY (`id_admin`) REFERENCES `admin` (`id_admin`);

--
-- Constraints for table `pesanan`
--
ALTER TABLE `pesanan`
  ADD CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`id_konsumen`) REFERENCES `konsumen` (`id_konsumen`),
  ADD CONSTRAINT `pesanan_ibfk_2` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`),
  ADD CONSTRAINT `pesanan_ibfk_3` FOREIGN KEY (`id_kurir`) REFERENCES `kurir` (`id_kurir`);

--
-- Constraints for table `produk`
--
ALTER TABLE `produk`
  ADD CONSTRAINT `produk_ibfk_1` FOREIGN KEY (`id_penjual`) REFERENCES `penjual` (`id_penjual`),
  ADD CONSTRAINT `produk_ibfk_2` FOREIGN KEY (`id_kategori`) REFERENCES `kategori_produk` (`id_kategori`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
