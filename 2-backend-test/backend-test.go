package main

import (
	"fmt"
	"sync"
)

// worker menerima potongan (chunk) slice dan menghitung sum bilangan genap saja
func worker(id int, chunk []int, ch chan<- int64, wg *sync.WaitGroup) {
	defer wg.Done()

	var partialSum int64 = 0
	for _, num := range chunk {
		// Filter hanya bilangan genap
		if num%2 == 0 {
			partialSum += int64(num)
		}
	}

	fmt.Printf("[Worker %d] Memproses %d angka, sum genap lokal: %d\n", id, len(chunk), partialSum)

	// Kirim hasil perhitungan parsial ke channel
	ch <- partialSum
}

func main() {
	// 1. Buat slice integer berukuran besar (misal: 1.000.000 angka dari 1 sampai 1.000.000)
	const totalData = 1000000
	numbers := make([]int, totalData)
	for i := 0; i < totalData; i++ {
		numbers[i] = i + 1
	}

	// 2. Tentukan jumlah worker (misalnya 4 worker sesuai soal)
	numWorkers := 4
	chunkSize := (len(numbers) + numWorkers - 1) / numWorkers

	// Channel untuk mengumpulkan hasil sum parsial dari tiap worker
	sumChannel := make(chan int64, numWorkers)
	var wg sync.WaitGroup

	// 3. Bagi slice ke worker dan jalankan secara konkuren
	for i := 0; i < numWorkers; i++ {
		start := i * chunkSize
		end := start + chunkSize
		if start >= len(numbers) {
			break
		}
		if end > len(numbers) {
			end = len(numbers)
		}

		chunk := numbers[start:end]

		wg.Add(1)
		go worker(i+1, chunk, sumChannel, &wg)
	}

	// 4. Goroutine terpisah untuk menutup channel setelah seluruh worker selesai
	go func() {
		wg.Wait()
		close(sumChannel)
	}()

	// 5. Kumpulkan total sum dari channel tanpa race condition
	var totalSum int64 = 0
	for partial := range sumChannel {
		totalSum += partial
	}

	fmt.Println("--------------------------------------------------")
	fmt.Printf("Total Sum Bilangan Genap (1 s/d %d) = %d\n", totalData, totalSum)
	fmt.Println("--------------------------------------------------")
}
