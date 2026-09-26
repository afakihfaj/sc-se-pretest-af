-- ========================================================
-- 1. DDL: SKEMA DATABASE (SIPERPUS)
-- ========================================================

CREATE TABLE kategori (
    id_kategori INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori VARCHAR(100) NOT NULL
);

CREATE TABLE buku (
    id_buku INT AUTO_INCREMENT PRIMARY KEY,
    id_kategori INT NOT NULL,
    judul VARCHAR(255) NOT NULL,
    pengarang VARCHAR(150) NOT NULL,
    penerbit VARCHAR(150) NOT NULL,
    isbn VARCHAR(50) NOT NULL,
    tahun_terbit INT NOT NULL,
    jumlah_tersedia INT NOT NULL DEFAULT 1,
    FOREIGN KEY (id_kategori) REFERENCES kategori(id_kategori) ON DELETE CASCADE
);

CREATE TABLE user (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(150) NOT NULL,
    alamat TEXT NOT NULL,
    no_ktp VARCHAR(20) NOT NULL UNIQUE,
    no_hp VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE peminjaman (
    id_peminjaman INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_buku INT NOT NULL,
    tanggal_pinjam DATE NOT NULL,
    tanggal_jatuh_tempo DATE NOT NULL,
    tanggal_kembali DATE,
    FOREIGN KEY (id_user) REFERENCES user(id_user) ON DELETE CASCADE,
    FOREIGN KEY (id_buku) REFERENCES buku(id_buku) ON DELETE CASCADE
);

-- ========================================================
-- 2. DML: INITIAL DATA SEEDING
-- ========================================================

-- Insert 5 Kategori
INSERT INTO kategori (nama_kategori) VALUES
('Teknologi'),
('Sains'),
('Fiksi'),
('Sejarah'),
('Bisnis');

-- Insert 5 User
INSERT INTO user (nama, alamat, no_ktp, no_hp, email) VALUES
('User 1', 'Jl. Sudirman No. 1', '3501010001', '081234567891', 'user1@mail.com'),
('User 2', 'Jl. Thamrin No. 2', '3501010002', '081234567892', 'user2@mail.com'),
('User 3', 'Jl. Gatot Subroto No. 3', '3501010003', '081234567893', 'user3@mail.com'),
('User 4', 'Jl. Asia Afrika No. 4', '3501010004', '081234567894', 'user4@mail.com'),
('User 5', 'Jl. Rasuna Said No. 5', '3501010005', '081234567895', 'user5@mail.com');

-- Insert 10 Buku
INSERT INTO buku (id_kategori, judul, pengarang, penerbit, isbn, tahun_terbit, jumlah_tersedia) VALUES
(1, 'Buku 1', 'Author A', 'Publisher X', '978-001', 2020, 5),
(1, 'Buku 2', 'Author B', 'Publisher X', '978-002', 2021, 3),
(2, 'Buku 3', 'Author C', 'Publisher Y', '978-003', 2019, 4),
(2, 'Buku 4', 'Author D', 'Publisher Y', '978-004', 2022, 2),
(3, 'Buku 5', 'Author E', 'Publisher Z', '978-005', 2018, 6),
(3, 'Buku 6', 'Author F', 'Publisher Z', '978-006', 2023, 1),
(4, 'Buku 7', 'Author G', 'Publisher W', '978-007', 2020, 5),
(4, 'Buku 8', 'Author H', 'Publisher W', '978-008', 2021, 3),
(5, 'Buku 9', 'Author I', 'Publisher V', '978-009', 2017, 2),
(5, 'Buku 10', 'Author J', 'Publisher V', '978-010', 2024, 7);

-- Insert 9 Data Peminjaman
-- User 1 pinjam Buku 1, 2, 3 (Tepat waktu)
-- User 2 pinjam Buku 4, 5, 6 (Tepat waktu)
-- User 3 pinjam Buku 7, 8, 9 (Buku 7 & 8 tepat waktu, Buku 9 telat 5 hari)
INSERT INTO peminjaman (id_user, id_buku, tanggal_pinjam, tanggal_jatuh_tempo, tanggal_kembali) VALUES
(1, 1, '2026-09-01', '2026-09-08', '2026-09-07'),
(1, 2, '2026-09-02', '2026-09-09', '2026-09-08'),
(1, 3, '2026-09-03', '2026-09-10', '2026-09-09'),
(2, 4, '2026-09-05', '2026-09-12', '2026-09-11'),
(2, 5, '2026-09-06', '2026-09-13', '2026-09-12'),
(2, 6, '2026-09-07', '2026-09-14', '2026-09-13'),
(3, 7, '2026-09-01', '2026-09-08', '2026-09-08'),
(3, 8, '2026-09-02', '2026-09-09', '2026-09-09'),
(3, 9, '2026-09-05', '2026-09-12', '2026-09-17'); -- Terlambat 5 hari (12 Sep -> 17 Sep)


-- ========================================================
-- 3. JAWABAN QUERY TUGAS
-- ========================================================

-- Soal 2: Tampilkan daftar buku yang tidak pernah dipinjam oleh siapapun
-- Expected Output: Buku 10
SELECT 
    b.judul AS Buku
FROM buku b
LEFT JOIN peminjaman p ON b.id_buku = p.id_buku
WHERE p.id_peminjaman IS NULL;


-- Soal 3: Tampilkan user yang pernah mengembalikan buku terlambat beserta dendanya
-- Denda = Rp1.000 / hari keterlambatan
-- Expected Output: User 3 | Rp5000
SELECT 
    u.nama AS User,
    CONCAT('Rp', SUM(DATEDIFF(p.tanggal_kembali, p.tanggal_jatuh_tempo) * 1000)) AS Denda
FROM user u
JOIN peminjaman p ON u.id_user = p.id_user
WHERE p.tanggal_kembali > p.tanggal_jatuh_tempo
GROUP BY u.id_user, u.nama;


-- Soal 4: Tampilkan user dengan daftar buku yang dipinjamnya
-- Expected Output: Urutan buku descending (Buku 3, Buku 2, Buku 1, dst.)
SELECT 
    ROW_NUMBER() OVER (ORDER BY u.id_user) AS No,
    u.nama AS User,
    GROUP_CONCAT(b.judul ORDER BY b.id_buku DESC SEPARATOR ', ') AS Buku
FROM user u
JOIN peminjaman p ON u.id_user = p.id_user
JOIN buku b ON p.id_buku = b.id_buku
GROUP BY u.id_user, u.nama
ORDER BY u.id_user ASC;