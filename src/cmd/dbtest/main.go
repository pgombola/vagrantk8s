package main

import (
	"database/sql"
	"fmt"
	"log"
	"time"

	// Import postgres driver.
	_ "github.com/lib/pq"
)

func main() {
	log.Println("starting app")

	url := fmt.Sprintf("postgresql://root@cockroachdb-public:26257")
	db, err := sql.Open("postgres", url)
	if err != nil {
		log.Fatal(err)
	}

	var dbErr error
	maxAttempts := 20
	for attempts := 1; attempts <= maxAttempts; attempts++ {
		dbErr = db.Ping()
		if dbErr == nil {
			break
		}
		log.Println(dbErr)
		time.Sleep(time.Duration(attempts) * time.Second)
	}
	if dbErr != nil {
		log.Fatal(dbErr)
	}

	log.Println("app started")
}
