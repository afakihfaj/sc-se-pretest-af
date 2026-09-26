package main

import (
	"fmt"
	"sync"
	"time"
)

type JobResult struct {
	ID       int
	Input    int
	Output   int
	WorkerID int
	Duration time.Duration
}

func worker(id int, jobs <-chan int, results chan<- JobResult, wg *sync.WaitGroup) {
	defer wg.Done()

	for num := range jobs {
		startTime := time.Now()

		// Simulalasi proses komputasi/I/O (misal: angka kuadrat)
		time.Sleep(100 * time.Millisecond)
		processedValue := num * num

		// Kirim Hasil ke channel result
		results <- JobResult{
			ID:       num,
			Input:    num,
			Output:   processedValue,
			WorkerID: id,
			Duration: time.Since(startTime),
		}

	}
}

func main() {
	// 1. Data slice awal yang akan diproses
	numbers := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	totalJobs := len(numbers)
	numWorkers := 3 // Menggunakan 3 worker goroutine

	//2. Stup Channel (Buffered channel untuk mencegah blocking berlebih)
	jobs := make(chan int, totalJobs)
	results := make(chan JobResult, totalJobs)

	// 3. Setup WaitGroup untuk memantau selesainya seluruh worker
	var wg sync.WaitGroup

	// Menjalankan worker goroutine
	for w := 1; w <= numWorkers; w++ {
		wg.Add(1)
		go worker(w, jobs, results, &wg)
	}
	
	// Mengirim data slice ke antrean channel jobs
	for _, n := range numbers {
		jobs <- n
	}
	close(jobs) // Tutup channel jobs setelah semua data masuk

	// Goroutine terpisah untuk menunggu semua worker selesai, lalu menutup results channel.
	go func() {
		wg.Wait()
		close(results)
	}()

	// 4. Membaca dan menampilkan hasil dari channel results
	fmt.Println("=== HASIL PEMROSESAN GOROUTINE & WORKER POOL ===")
	for res := range results {
		fmt.Printf("Worker %d memproses input %d -> Hasil: %d (waktu: %v)\n",
			res.WorkerID, res.Input, res.Output, res.Duration)
	}
	fmt.Println("Semua data berhasil diproses secara konkuren tanpa race condition")
}
