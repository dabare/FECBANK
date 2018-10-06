package main

import (
	"net/http"
	//"io/ioutil"
	"log"
	"html/template"
	"database/sql"
	//_ "github.com/mattn/go-sqlite3"
	_ "github.com/mxk/go-sqlite/sqlite3"
	"strconv"
	"strings"
	"time"
	"os"
	"runtime"
	"os/exec"
	"fmt"
	"io/ioutil"
)

var errDefault = 0
var errTimeConversion = 3
var errMysqlDBname = 1
var errDBquery = 2
var errBrowser = 4
var errSevingHelper = 5

var dbName = "FEC"

var debugCount = 0

func debugMSG(msg string) {
	println(strconv.Itoa(debugCount) + " Done!")
	debugCount++
	println(msg)
}

func readFile(path string) string {
	s := ""

	out, _ := ioutil.ReadFile("./core/" + path)
	s = string(out)
	return s
	//return "./core/" + path
}

var homepage = true

type SiteData struct {
	Uname	string
	Uimg	string
	Utype	string
	NavColaps	bool
	Data interface{}
}

func NavColaps(w http.ResponseWriter, r *http.Request) bool {
	navColaps := false
	tmp , err := r.Cookie("navbar_expand")
	if(err!=nil){
		expiration := time.Now().Add(365 * 24 * time.Hour)
		cookie := http.Cookie{Name: "navbar_expand", Value: "false", Expires: expiration}
		http.SetCookie(w, &cookie)
	}else{
		if(tmp.Value == "true"){
			navColaps = true
		}
	}
	return navColaps
}

func showFile(w http.ResponseWriter, r *http.Request, file string, data interface{}) {
	fm := template.FuncMap{
		"dec": func(a int64) string {
			return int2floatStr(a)
		},
	}

	t := template.New("layout")
	var siteData = SiteData{}

	addUserInfo(w,r, &siteData)
	siteData.Data = data
	t, _ = t.Funcs(fm).Parse(readFile(file))
	t, _ = t.Funcs(fm).Parse(readFile("scripts.html"))
	t, _ = t.Funcs(fm).Parse(readFile("footer.html"))
	t, _ = t.Funcs(fm).Parse(readFile("navbar_left.html"))
	t, _ = t.Funcs(fm).Parse(readFile("navbar_top.html"))

	t.Execute(w, siteData)
}

func serveHelper(w http.ResponseWriter, r *http.Request, file string) {
	http.ServeFile(w, r, file)
	return
}

func checkErr(err error, typ int) {
	// Of course, this name isn't unique,
	// I usually use time.Now().Unix() or something
	// to get unique log names.

	if err == nil {
		return
	}
	switch typ {
	default:
		println("Error occured!, Please contact developer :)")
		t := time.Now().Format("01_02_2006_15.04.05")
		logFile, err := os.Create("./log/" + t + ".txt")
		log.SetOutput(logFile)
		log.Panic(err)
	}
}

func initDatabase() {
	executeDB(readFile("db.sql"))
}

func getResultDB(query string) *sql.Rows {
	debugMSG(query)
	database, _ := sql.Open("sqlite3", "./database/" + dbName + ".db")
	rows, err := database.Query(query)
	checkErr(err, errDBquery)

	err = database.Close()
	checkErr(err, errDBquery)
	return rows
}

func executeDB(exe string) {
	debugMSG(exe)
	database, _ := sql.Open("sqlite3", "./database/" + dbName + ".db")
	_, err := database.Exec(exe)
	checkErr(err, errDBquery)
	database.Close()
}

func insertData(table string, vals string) {
	executeDB("INSERT INTO " + table + " VALUES(" + vals + ")")
}

func deleteData(table string, id string) {
	executeDB("DELETE FROM " + table + " WHERE id = " + id)
}

func updateData(table string, id string, str string) {
	executeDB("UPDATE " + table + " SET " + str + " WHERE id=" + id)
}

func getNextID(table string) int64 {
	rows := getResultDB("select max(id) + 1 as newid from " + table)

	if rows == nil {
		return -1
	}

	rows.Next()

	var newid sql.NullInt64

	err := rows.Scan(&newid)
	checkErr(err, errDBquery)

	rows.Close()

	return newid.Int64
}

func checkUserValid(w http.ResponseWriter, r *http.Request) bool {
	return true
}

func addUserInfo(w http.ResponseWriter, r *http.Request,siteData *SiteData)  {
	siteData.Uname = "Nimeshi Wickramasinghe"
	siteData.Uimg = "img/a3.jpg"
	siteData.Utype = "Treasurere"
	siteData.NavColaps = NavColaps(w,r)
}

const (
	stdLongMonth = "January"
	stdMonth = "Jan"
	stdNumMonth = "1"
	stdZeroMonth = "01"
	stdLongWeekDay = "Monday"
	stdWeekDay = "Mon"
	stdDay = "2"
	stdUnderDay = "_2"
	stdZeroDay = "02"
	stdHour = "15"
	stdHour12 = "3"
	stdZeroHour12 = "03"
	stdMinute = "4"
	stdZeroMinute = "04"
	stdSecond = "5"
	stdZeroSecond = "05"
	stdLongYear = "2006"
	stdYear = "06"
	stdPM = "PM"
	stdpm = "pm"
	stdTZ = "MST"
	stdISO8601TZ = "Z0700"  // prints Z for UTC
	stdISO8601ColonTZ = "Z07:00" // prints Z for UTC
	stdNumTZ = "-0700"  // always numeric
	stdNumShortTZ = "-07"    // always numeric
	stdNumColonTZ = "-07:00" // always numeric
)

func startService() {
	//err := http.ListenAndServeTLS(":8080", "hostcert.pem", "hostkey.pem", nil)
	//err := http.ListenAndServe("localhost:8008", nil)
	//if err != nil {
	//	log.Fatal("ListenAndServe: ", err)
	//}

	s := &http.Server{
		Addr:           ":8008",
		Handler:        nil,
		ReadTimeout:    2 * time.Second,
		WriteTimeout:   2 * time.Second,
		MaxHeaderBytes: 1 << 20,
	}
	log.Fatal(s.ListenAndServe())

}

func openbrowser(url string) {
	var err error

	switch runtime.GOOS {
	case "linux":
		err = exec.Command("xdg-open", url).Start()
	case "windows":
		err = exec.Command("rundll32", "url.dll,FileProtocolHandler", url).Start()
	case "darwin":
		err = exec.Command("open", url).Start()
	default:
		err = fmt.Errorf("unsupported platform")
	}
	if err != nil {
		checkErr(err, errBrowser)
	}
}

func int2floatStr(in int64) string {
	val := in / 100
	diff := in - (val * 100)
	if (diff < 10) {
		return strconv.FormatInt(val, 10) + ".0" + strconv.FormatInt(diff, 10)
	} else {
		return strconv.FormatInt(val, 10) + "." + strconv.FormatInt(diff, 10)
	}
}

func strfloat2strint(in string) string {
	s := strings.Split(in, ".")
	val := s[0]
	if (len(s) == 1) {
		val += "00"
	} else if (len(s) == 2) {
		ss := strings.Split(s[1], "")

		if (len(ss) == 1) {
			val += ss[0] + "0"
		} else if (len(ss) > 1) {
			val += ss[0] + ss[1]
		} else {
			val += "00"
		}
	}
	return val
}

func index(w http.ResponseWriter, r *http.Request) {
	if(checkUserValid(w,r)){
		r.ParseForm()

		showFile(w, r, "index.html", "")
	}else {
		login(w,r)
	}
}

func members(w http.ResponseWriter, r *http.Request) {
	if(checkUserValid(w,r)){
		r.ParseForm()

		name := r.FormValue("name")
		debugMSG(name)dev


		showFile(w, r, "members.html", "")
	}else {
		login(w,r)
	}
}

func login(w http.ResponseWriter, r *http.Request) {
	if(checkUserValid(w,r)){
		index(w,r)
	}else {
		showFile(w, r, "login.html", "")
	}
}

func mainSearch(w http.ResponseWriter, r *http.Request) {
	if(checkUserValid(w,r)){
		r.ParseForm()

		showFile(w, r, "main_search.html", "")
	}else {
		login(w,r)
	}
}



func main() {
	initDatabase()

	http.HandleFunc("/login.html", login)
	http.HandleFunc("/index.html", index)
	http.HandleFunc("/members.html", members)
	http.HandleFunc("/main_search.html", mainSearch)

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if (r.URL.Path == "/") {
			http.Redirect(w, r, "index.html", http.StatusSeeOther)
		} else {
			serveHelper(w, r, "helper/" + r.URL.Path[1:])
		}
	})
	openbrowser("http://localhost:8008")
	startService()
}
