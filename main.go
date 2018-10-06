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
	"io"
)

var errDefault = 0
var errTimeConversion = 3
var errMysqlDBname = 1
var errDBquery = 2
var errBrowser = 4
var errSevingHelper = 5
var errFileUpload = 6

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
	Uid 	int64
	Utype	string
	NavColaps	bool
	Data interface{}
}

func setCookie(w http.ResponseWriter,Name string, Value string)  {
	expiration := time.Now().Add(365 * 24 * time.Hour)
	cookie := http.Cookie{Name: Name, Value: Value, Expires: expiration}
	http.SetCookie(w, &cookie)
}

func NavColaps(w http.ResponseWriter, r *http.Request) bool {
	navColaps := false
	tmp , err := r.Cookie("navbar_expand")
	if(err!=nil){
		setCookie(w,"navbar_expand","false")
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
	panic(err)
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

	setCookie(w,"uid","1")
	siteData.Uid = 1
	siteData.Uname = "Nimeshi Wickramasinghe"
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

type MemberData struct {
	Id 	int64
	Pos 	string
	Email 	string
	Pass 	string
	Name 	string
	Note 	string
	Tel 	string
	Adrs 	string
	Nic 	string
	Act 	bool
	Dob 	string
	Age 	int
	Image	string
	ActPan 	bool //current active pannel
}

type MembersData struct {
	NextId	int64
	Members []MemberData
}

func members(w http.ResponseWriter, r *http.Request) {
	if(checkUserValid(w,r)){
		membersData := MembersData{getNextID("user"),nil}

		rows := getResultDB("SELECT * FROM user ORDER BY name ASC")
		ActPan := true
		for rows.Next(){
			tmp := MemberData{}

			var Id 		sql.NullInt64
			var Pos 	sql.NullString
			var Email 	sql.NullString
			var Pass 	sql.NullString
			var Name 	sql.NullString
			var Note 	sql.NullString
			var Tel 	sql.NullString
			var Adrs 	sql.NullString
			var Nic 	sql.NullString
			var Act 	sql.NullString
			var Dob 	sql.RawBytes

			err := rows.Scan(&Id, &Pos, &Email, &Pass, &Name, &Note, &Tel, &Adrs, &Nic, &Act, &Dob)
			checkErr(err, errDBquery)

			tmp.Id = Id.Int64
			tmp.Pos = Pos.String
			tmp.Email = Email.String
			tmp.Pass = Pass.String
			tmp.Name = Name.String
			tmp.Note = Note.String
			tmp.Tel = Tel.String
			tmp.Adrs = Adrs.String
			tmp.Nic = Nic.String
			tmp.Act = false
			if Act.String == "Active" {
				tmp.Act = true
			}
			tmp.Dob = string(Dob)

			i, _ := strconv.Atoi(strings.Split(tmp.Dob, "/")[2])

			tmp.Age =time.Now().Year() - i

			tmp.Image = "./users/u"+strconv.FormatInt(tmp.Id,10)+".jpg"
			if _, err := os.Stat("./helper/users/u"+strconv.FormatInt(tmp.Id,10)+".jpg"); os.IsNotExist(err) {
				// path/to/whatever does not exist
				tmp.Image = "./users/u-1.jpg"
			}
			tmp.ActPan = ActPan
			ActPan = false

			membersData.Members = append(membersData.Members, tmp)
		}

		showFile(w, r, "members.html", membersData)
	}else {
		login(w,r)
	}
}

func newMember(w http.ResponseWriter, r *http.Request) {
	if(r.Method == "POST"){
		r.ParseMultipartForm(32 << 20)

		name := r.FormValue("name")
		debugMSG(name)

		file, _, err := r.FormFile("uploadfile")
		if err == nil {
			f, err := os.OpenFile("./helper/users/"+"u"+r.FormValue("id")+".jpg", os.O_WRONLY|os.O_CREATE, 0666)
			checkErr(err, errFileUpload)

			defer f.Close()
			io.Copy(f, file)
			defer file.Close()
		}
		insertData("user",r.FormValue("id") + ", '"+r.FormValue("pos")+"', '"+r.FormValue("email")+"', '"+r.FormValue("pass")+"', '"+r.FormValue("name")+"', '"+r.FormValue("note")+"', '"+r.FormValue("tel")+"', '"+r.FormValue("adrs")+"', '"+r.FormValue("nic")+"', '"+r.FormValue("act")+"', '"+r.FormValue("dob")+"'")
	}
	http.Redirect(w, r, "members.html", http.StatusSeeOther)
}

func updateMember(w http.ResponseWriter, r *http.Request) {
	if(r.Method == "POST"){
		r.ParseMultipartForm(32 << 20)

		name := r.FormValue("name")
		debugMSG(name)

		file, _, err := r.FormFile("uploadfile")
		if err == nil {
			f, err := os.OpenFile("./helper/users/"+"u"+r.FormValue("id")+".jpg", os.O_WRONLY|os.O_CREATE, 0666)
			checkErr(err, errFileUpload)

			defer f.Close()
			io.Copy(f, file)
			defer file.Close()
		}
		updateData("user",r.FormValue("id"),"pos='"+r.FormValue("pos")+"', email='"+r.FormValue("email")+"', name='"+r.FormValue("name")+"', note='"+r.FormValue("note")+"', tel='"+r.FormValue("tel")+"', adrs='"+r.FormValue("adrs")+"', nic='"+r.FormValue("nic")+"', act='"+r.FormValue("act")+"', dob='"+r.FormValue("dob")+"'")

		if(len(r.FormValue("pass")) != 0){
			updateData("user",r.FormValue("id"),"pass='"+r.FormValue("pass")+"'")
		}
	}
	http.Redirect(w, r, "members.html", http.StatusSeeOther)
}

func login(w http.ResponseWriter, r *http.Request) {
	if(checkUserValid(w,r)){
		index(w,r)
	}else {
		showFile(w, r, "login.html","")
	}
}

func test(w http.ResponseWriter, r *http.Request) {
	showFile(w, r, "test.html", "")
}

func mainSearch(w http.ResponseWriter, r *http.Request) {
	if(checkUserValid(w,r)){
		r.ParseForm()

		showFile(w, r, "main_search.html", "")
	}else {
		login(w,r)
	}
}

func upload(w http.ResponseWriter, r *http.Request) {
	fmt.Println("method:", r.Method)

	r.ParseMultipartForm(32 << 20)

	name := r.FormValue("name")
	debugMSG(name)

	file, handler, err := r.FormFile("uploadfile")
	if err != nil {
		fmt.Println(err)
		return
	}
	defer file.Close()
	fmt.Fprintf(w, "%v", handler.Header)
	f, err := os.OpenFile("./helper/users/"+handler.Filename, os.O_WRONLY|os.O_CREATE, 0666)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer f.Close()
	io.Copy(f, file)
}

func main() {
	initDatabase()

	http.HandleFunc("/test.html", test)
	http.HandleFunc("/login.html", login)
	http.HandleFunc("/index.html", index)

	http.HandleFunc("/members.html", members)
	http.HandleFunc("/newMember.html", newMember)
	http.HandleFunc("/updateMember.html", updateMember)

	http.HandleFunc("/main_search.html", mainSearch)
	http.HandleFunc("/upload", upload)

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
