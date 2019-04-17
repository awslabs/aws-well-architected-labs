//
// MIT No Attribution
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of this
// software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify,
// merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

package main

import (
	"database/sql"
	"flag"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
//	"log"
	"net/http"
)

type Log struct {
	ip   string `json:"ip"`
	time string `json:"time"`
}

var endpoint *string
var username *string
var password *string
var database *string
var imageurl *string
var db *sql.DB
var err error

func init(){
// These are example parameters - you must override them as appropriate
	endpoint = flag.String("endpoint", "resilieny.cx4u4wy0obxu.us-east-1.rds.amazonaws.com:3306", "RDS EndPoint")
	username = flag.String("username", "admin", "username for the database")
	password = flag.String("password", "foobar123", "password for the database")
	database = flag.String("database", "iptracker", "Initial database")
	imageurl = flag.String("imageurl", "https://s3.us-east-2.amazonaws.com/arc327-well-architected-for-reliability/Cirque_of_the_Towers.jpg", "Image (in S3 must be public read) for website")
	flag.Parse()
	connectionString := fmt.Sprintf("%s:%s@tcp(%s)/%s", *username, *password, *endpoint, *database)
	fmt.Print("Connecting to ", connectionString," ........")
	db, err = sql.Open("mysql", connectionString)
	if err != nil {
		panic(err.Error())
	}
}

func main() {
// Simply set up the handler and listen!
	http.HandleFunc("/", homeHandler)
	http.HandleFunc("/static/", staticHandler)
	panic(http.ListenAndServe(":80", nil))
	defer db.Close()
}

func homeHandler(w http.ResponseWriter, r *http.Request) {
// Insert a DB record and return the static HTML
	insertRecord(r.RemoteAddr)
	fmt.Fprintf(w, "<html><head><title>300 - Testing for Resiliency</title></head><body><h1>Reliability Lab 300 - Testing for Resiliency!</h1><img width=400 height =400 src=\"" + *imageurl + "\"></img><h2>Thank you for your visit.</h2></body></html>")
}

func staticHandler(w http.ResponseWriter, r *http.Request) {
	http.ServeFile(w, r, r.URL.Path[1:])
}

func insertRecord(host string) {
	stmt, err := db.Prepare("INSERT into hits SET ip=?")
        if err != nil {
		panic(err.Error())
	}
        stmt.Exec(host)

// Uncomment this to debug
//	results, err := db.Query("SELECT * from hits")
//	if err != nil {
//		panic(err.Error())
//	}
//
//	for results.Next() {
//		var entry Log
//		// for each row, scan the result into our tag composite object
//		err = results.Scan(&entry.ip, &entry.time)
//		if err != nil {
//			panic(err.Error()) // proper error handling instead of panic in your app
//		}
//		// and then print out the tag's Name attribute
//		log.Printf(entry.ip, entry.time)
//	}
//
	// defer the close till after the main function has finished
	// executing

}
