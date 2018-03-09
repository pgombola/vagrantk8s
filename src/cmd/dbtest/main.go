package main

import (
	"database/sql"
	"log"
	"os"
	"os/signal"
	"time"

	// Import postgres driver.
	_ "github.com/lib/pq"
)

func main() {
	log.Println("starting app")

	conn := `user=root
		host=cockroachdb-public
		port=26257
		sslcert=/cockroach-certs/client.root.crt
		sslkey=/cockroach-certs/client.root.key`

	// url := fmt.Sprintf("postgresql://root@cockroachdb-public:26257?sslcert=/cockroach-certs/client.root.crt")
	db, err := sql.Open("postgres", conn)
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

	doneCh := make(chan os.Signal, 1)
	signal.Notify(doneCh, os.Interrupt, os.Kill)
	log.Println("app started")
	select {
	case sig := <-doneCh:
		log.Printf("exiting app with %v\n", sig)
	}
}
