# Software Engineer Pre-Test Submission

Repositori ini berisi penyelesaian tugas technical pre-test yang mencakup 4 bagian: Frontend, Backend Concurrency, Database Design & Query, serta Algorithm.

---

### Daftar Isi
- [Part 1 - Frontend (Knight Move Chessboard)](#part-1---frontend-knight-move-chessboard)
- [Part 2 - Backend (Concurrency & Worker Pool)](#part-2---backend-concurrency--worker-pool)
- [Part 3 - Database (Library Management System)](#part-3---database-library-management-system)
- [Part 4 - Algorithm & Logic (Find Max-Min)](#part-4---algorithm--logic-find-max-min)

---

### Part 1 - Frontend (Knight Move Chessboard)
Simulasi papan catur interaktif berukuran 8x8 yang menghitung dan menandai kemungkinan langkah sah bidak kuda (*Knight*) berdasarkan koordinat petak yang diklik.

* **Lokasi Folder:** `1-frontend-test/`
* **Tech Stack:** HTML5, CSS Grid, Vanilla JavaScript
* **Cara Menjalankan:** Buka file `1-frontend/index.html` langsung pada browser.

---

### Part 2 - Backend (Concurrency & Worker Pool)
Pemrosesan data secara konkuren menggunakan pola Worker Pool, Goroutines, dan Channels di Golang dengan sinkronisasi alur via `sync.WaitGroup`.

* **Lokasi Folder:** `2-backend-test/`
* **Tech Stack:** Go (Golang)
* ````markdown
* **Cara Menjalankan:**
```bash
cd 2-backend-test
go run backend-test.go

---

### Part 3 - Database (Library Management System)
Perancangan skema database relasional untuk sistem perpustakaan yang mencakup DDL, DML, relasi data antar-entitas, serta kueri analitis.

* **Lokasi Folder:** `3-sql/`
* **Tech Stack:** MySQL / MariaDB
* **Cara Menjalankan:** Jalankan script `3-sql/database-test-query.sql` ssecara berurutan (DDL -> DML -> Query Soal) pada MySQL/MariaDB client (DBeaver, phpMyAdmin, MySQL Workbench, atau CLI).

#### Entity Relationship Diagram (ERD)
![ERD Diagram](./3-sql/database-test-erd.png)

---

### Part 4 - Algorithm & Logic (Find Max-Min)
Penyelesaian algoritma pencarian nilai maksimum dan minimum dalam array secara efisien menggunakan pendekatan traversal linear / windowing.

* **Lokasi Folder:** `4-algorithm/`
* **File:** `4-algorithm/findMaxInMin.txt`
