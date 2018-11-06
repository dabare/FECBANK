package main

import (
	"net/http"
	//"io/ioutil"
	"log"
	"html/template"
	"database/sql"
	//_ "github.com/mattn/go-sqlite3"
	//_ "github.com/mxk/go-sqlite/sqlite3"
	_ "github.com/go-sql-driver/mysql"
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
var errFileDelete = 7

var cookieUserId = "asdhfdbcfjksdfyfedefrw"

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

type UserData struct {
	Uname	string
	Uid 	string
	Utype	string
	Uimage	string
	NavColaps	bool
}

type SiteData struct {
	UserData UserData
	Data interface{}
}

func Date(year, month, day int) time.Time {
	return time.Date(year, time.Month(month), day, 0, 0, 0, 0, time.UTC)
}

func daysUptoNowMysql(from string) int {
	//YYYY-MM-DD
	gotDate:= strings.Split(from, "-")
	y,_ := strconv.Atoi(gotDate[0])
	m,_ := strconv.Atoi(gotDate[1])
	d,_ := strconv.Atoi(gotDate[2])

	return int(time.Now().Sub(Date(y,m,d)).Hours()/24)
}

func getTodayToWeb() string{
	currentTime := time.Now()
	//MM/DD/YYY
	return currentTime.Format("01/02/2006")
}

func convertDateWeb2MySQL(date string) string {
	gotDate:= strings.Split(date, "/")
	return gotDate[2] + "-" + gotDate[0] + "-" + gotDate[1]
}

func convertDateMYSQL2Web(date string) string {
	gotDate:= strings.Split(date, "-")
	return gotDate[1] + "/" + gotDate[2] + "/" + gotDate[0]
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
	//panic(err)
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

	database, _ := sql.Open("mysql", "root:aelo@tcp(127.0.0.1:3306)/"+dbName)

	//database, _ := sql.Open("sqlite3", "./database/" + dbName + ".db")

	rows, err := database.Query(query)
	checkErr(err, errDBquery)

	err = database.Close()
	checkErr(err, errDBquery)
	return rows
}

func executeDB(exe string) {
	debugMSG(exe)
	database, _ := sql.Open("mysql", "root:aelo@tcp(127.0.0.1:3306)/"+dbName)

	//database, _ := sql.Open("sqlite3", "./database/" + dbName + ".db")
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
	ret := false
	tmp , err := r.Cookie(cookieUserId)
	if(err==nil){
		rows := getResultDB("select name  from user WHERE id=" + tmp.Value)
		for rows.Next(){
			ret = true
		}
		rows.Close()
	}

	return ret
}

func addUserInfo(w http.ResponseWriter, r *http.Request,siteData *SiteData)  {
	siteData.UserData.Uid = "-1"
	siteData.UserData.Uname = ""
	siteData.UserData.Utype = ""
	siteData.UserData.NavColaps = NavColaps(w,r)

	if(checkUserValid(w,r)){
		tmp , err := r.Cookie(cookieUserId)
		if(err==nil){
			rows := getResultDB("SELECT user.name, userType.typ FROM user LEFT JOIN userType ON user.userType_id = userType.id WHERE user.id=" + tmp.Value)

			var name sql.NullString
			var typ sql.NullString

			for rows.Next(){
				err := rows.Scan(&name, &typ)
				checkErr(err, errDBquery)
			}

			rows.Close()

			siteData.UserData.Uid = tmp.Value
			siteData.UserData.Uname = name.String
			siteData.UserData.Utype = typ.String

			siteData.UserData.Uimage = "./users/u"+tmp.Value+".jpg"
			if _, err := os.Stat("./helper/users/u"+tmp.Value+".jpg"); os.IsNotExist(err) {
				// path/to/whatever does not exist
				siteData.UserData.Uimage = "./users/u-1.jpg"
			}

		}else {
		}
	}else {
	}
}

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

func int2Str(in int64) string {
	return strconv.FormatInt(in, 10)
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

type MemberType struct {
	Id	int64
	Typ 	string
	Dlt	bool
}

func getMemberTypes()[]MemberType{
	var ret	[]MemberType
	sqlStr := `SELECT userType.id, userType.typ, tmp2.count FROM
	(SELECT COUNT(id) AS count, userType_id FROM
	(SELECT user.id, userType.id AS userType_id, userType.typ FROM user
	LEFT JOIN userType ON user.userType_id = userType.id
	UNION
	SELECT user.id, userType.id AS userType_id, userType.typ FROM user
	RIGHT JOIN userType ON user.userType_id = userType.id
	) AS tmp
	GROUP BY userType_id) AS tmp2
	LEFT JOIN userType
	ON userType.id = tmp2.userType_id`

	rows := getResultDB(sqlStr)

	for rows.Next(){
		tmp := MemberType{}

		var Id 		sql.NullInt64
		var Typ 	sql.NullString
		var Count	sql.NullInt64

		err := rows.Scan(&Id, &Typ, &Count)
		checkErr(err, errDBquery)

		tmp.Id = Id.Int64
		tmp.Typ = Typ.String
		tmp.Dlt = true
		if Count.Int64>0{
			tmp.Dlt = false
		}
		ret = append(ret,tmp)
	}
	rows.Close()
	return ret
}

type SettingsData struct {
	NewType 	int64
	Types		[]MemberType
}

func settings(w http.ResponseWriter, r *http.Request) {
	if(checkUserValid(w,r)){
		settingsData := SettingsData{getNextID("userType"),getMemberTypes()}
		showFile(w, r, "settings.html", settingsData)
	}else {
		login(w,r)
	}
}

func newMemberType(w http.ResponseWriter, r *http.Request) {
	if(r.Method == "POST"){
		r.ParseMultipartForm(32 << 20)
		insertData("userType",r.FormValue("id") +", '"+r.FormValue("typ")+"'")
	}
	http.Redirect(w, r, "settings.html", http.StatusSeeOther)
}

func updateMemberType(w http.ResponseWriter, r *http.Request) {
	if(r.Method == "POST"){
		r.ParseMultipartForm(32 << 20)
		if(r.FormValue("action") == "save"){
			updateData("userType",r.FormValue("id"),"typ='"+r.FormValue("typ")+"'")
		}else if(r.FormValue("action") == "delete"){
			deleteData("userType",r.FormValue("id"))
		}

	}
	http.Redirect(w, r, "settings.html", http.StatusSeeOther)
}

type MemberData struct {
	Id 	int64
	UserType_id 	int64
	Status 	string
	Email 	string
	Pass 	string
	Name 	string
	Note 	string
	Tel 	string
	Adrs 	string
	Nic 	string
	Act 	bool
	Dob 	string
	Member_since	string
	Typ	string
	Age 	int
	Image	string
	ActPan 	bool //current active pannel
	Dlt 	bool
}

type MembersData struct {
	NextId	int64
	Today	string
	Members []MemberData
	MemberTypes []MemberType
}

func isMemberDeletable(id string) bool {
	ret := true
	rows := getResultDB("SELECT COUNT(id) FROM deposit WHERE user_id="+id+" OR fec_id="+id+" OR updated_id="+id)
	var count sql.NullInt64
	for rows.Next(){
		err := rows.Scan(&count)
		checkErr(err, errDBquery)
	}
	if count.Int64 > 0{
		ret =false
	}
	rows.Close()
	return ret
}

func members(w http.ResponseWriter, r *http.Request) {
	if(checkUserValid(w,r)){
		membersData := MembersData{getNextID("user"),getTodayToWeb(), nil,getMemberTypes()}

		rows := getResultDB("SELECT user.*, userType.typ FROM user LEFT JOIN userType ON user.userType_id = userType.id")
		ActPan := true
		for rows.Next(){
			tmp := MemberData{}

			var Id 		sql.NullInt64
			var UserType_id 	sql.NullInt64
			var Status 	sql.NullString
			var Email 	sql.NullString
			var Pass 	sql.NullString
			var Name 	sql.NullString
			var Note 	sql.NullString
			var Tel 	sql.NullString
			var Adrs 	sql.NullString
			var Nic 	sql.NullString
			var Act 	sql.NullString
			var Dob 	sql.RawBytes
			var Member_since sql.RawBytes
			var Typ		sql.NullString

			err := rows.Scan(&Id, &UserType_id, &Status, &Email, &Pass, &Name, &Note, &Tel, &Adrs, &Nic, &Act, &Dob, &Member_since, &Typ)
			checkErr(err, errDBquery)

			tmp.Id = Id.Int64
			tmp.Status = Status.String
			tmp.Email = Email.String
			tmp.Pass = Pass.String
			tmp.Name = Name.String
			tmp.Note = Note.String
			tmp.Tel = Tel.String
			tmp.Adrs = Adrs.String
			tmp.Nic = Nic.String
			tmp.Act = false
			tmp.UserType_id = UserType_id.Int64
			if Act.String == "Active" {
				tmp.Act = true
			}
			tmp.Dob = convertDateMYSQL2Web(string(Dob))
			tmp.Member_since = convertDateMYSQL2Web(string(Member_since))
			tmp.Typ = Typ.String
			i, _ := strconv.Atoi(strings.Split(tmp.Dob, "/")[2])

			tmp.Age =time.Now().Year() - i

			tmp.Image = "./users/u"+strconv.FormatInt(tmp.Id,10)+".jpg"
			if _, err := os.Stat("./helper/users/u"+strconv.FormatInt(tmp.Id,10)+".jpg"); os.IsNotExist(err) {
				// path/to/whatever does not exist
				tmp.Image = "./users/u-1.jpg"
			}
			tmp.ActPan = ActPan
			ActPan = false
			tmp.Dlt = isMemberDeletable(int2Str(tmp.Id))
			membersData.Members = append(membersData.Members, tmp)
		}
		rows.Close()
		showFile(w, r, "members.html", membersData)
	}else {
		login(w,r)
	}
}

func newMember(w http.ResponseWriter, r *http.Request) {
	if(r.Method == "POST"){
		r.ParseMultipartForm(32 << 20)

		file, _, err := r.FormFile("uploadfile")
		if err == nil {
			f, err := os.OpenFile("./helper/users/"+"u"+r.FormValue("id")+".jpg", os.O_WRONLY|os.O_CREATE, 0666)
			checkErr(err, errFileUpload)

			defer f.Close()
			io.Copy(f, file)
			defer file.Close()
		}

		insertData("user",r.FormValue("id") + ", "+r.FormValue("userType_id")+" , '"+r.FormValue("status")+"', '"+r.FormValue("email")+"', '"+r.FormValue("pass")+"', '"+r.FormValue("name")+"', '"+r.FormValue("note")+"', '"+r.FormValue("tel")+"', '"+r.FormValue("adrs")+"', '"+r.FormValue("nic")+"', '"+r.FormValue("act")+"', '"+convertDateWeb2MySQL(r.FormValue("dob"))+"', '"+convertDateWeb2MySQL(r.FormValue("member_since"))+"'")
	}
	http.Redirect(w, r, "members.html", http.StatusSeeOther)
}

func updateMember(w http.ResponseWriter, r *http.Request) {
	if(r.Method == "POST"){
		r.ParseMultipartForm(32 << 20)

		if(r.FormValue("action") == "save"){
			file, _, err := r.FormFile("uploadfile")
			if err == nil {
				f, err := os.OpenFile("./helper/users/"+"u"+r.FormValue("id")+".jpg", os.O_WRONLY|os.O_CREATE, 0666)
				checkErr(err, errFileUpload)

				defer f.Close()
				io.Copy(f, file)
				defer file.Close()
			}
			updateData("user",r.FormValue("id"),"userType_id="+r.FormValue("userType_id")+", status='"+r.FormValue("status")+"', email='"+r.FormValue("email")+"', name='"+r.FormValue("name")+"', note='"+r.FormValue("note")+"', tel='"+r.FormValue("tel")+"', adrs='"+r.FormValue("adrs")+"', nic='"+r.FormValue("nic")+"', act='"+r.FormValue("act")+"', dob='"+convertDateWeb2MySQL(r.FormValue("dob"))+"', member_since='"+convertDateWeb2MySQL(r.FormValue("member_since"))+"'")

			if(len(r.FormValue("pass")) != 0){
				updateData("user",r.FormValue("id"),"pass='"+r.FormValue("pass")+"'")
			}
		}else if(r.FormValue("action") == "delete"){
			deleteData("user",r.FormValue("id"))

			_ = os.Remove("./helper/users/"+"u"+r.FormValue("id")+".jpg")

		}



	}
	http.Redirect(w, r, "members.html", http.StatusSeeOther)
}

type savingsDeposit struct {
	Id 	int64
	Dte	string
	User_id	int64
	User	string
	FEC_id	int64
	FEC	string
	Amount	string
	Interest	string
	Updated_id	int64
	Updated	string
	CurrentInterest	string
	Total	string
}

type depositsMember struct {
	Id	int64
	Name	string
}

func getDepositMembers(typ string) []depositsMember {
	var sqlStr string
	switch typ {
	case "ALL":
		sqlStr="SELECT user.id, user.name FROM user LEFT JOIN userType ON user.userType_id = userType.id"
		break
	case "FEC":
		sqlStr="SELECT user.id, user.name FROM user LEFT JOIN userType ON user.userType_id = userType.id WHERE userType.typ!='Customer'"
		break
	}
	var ret []depositsMember
	rows := getResultDB(sqlStr)

	for rows.Next(){
		tmp := depositsMember{}

		var Id 		sql.NullInt64
		var Name 	sql.NullString

		err := rows.Scan(&Id, &Name)
		checkErr(err, errDBquery)

		tmp.Id = Id.Int64
		tmp.Name = Name.String

		ret = append(ret,tmp)
	}
	rows.Close()
	return ret

}

type SavingsDepositsData struct {
	NextId	int64
	Today	string
	Deposits	[]savingsDeposit
	FECMembers []depositsMember
	AllMembers	[]depositsMember
}

func savingsDeposits(w http.ResponseWriter, r *http.Request) {
	if(checkUserValid(w,r)){
		savingsDepositsData := SavingsDepositsData{getNextID("deposit"), getTodayToWeb(),nil,getDepositMembers("FEC"),getDepositMembers("ALL")}

		sqlStr := `SELECT tmp1.*, user.name AS updated
			FROM
			    (SELECT tmp.* , user.name AS fec
			    FROM
				(SELECT deposit.*, user.name AS user FROM deposit
				LEFT JOIN user
				ON deposit.user_id=user.id) AS tmp
			    LEFT JOIN user
			    ON tmp.fec_id=user.id) as tmp1
			LEFT JOIN user
			ON tmp1.updated_id=user.id`

		rows := getResultDB(sqlStr)

		for rows.Next(){
			tmp := savingsDeposit{}

			var Id 		sql.NullInt64
			var Dte 	sql.RawBytes
			var User_id 	sql.NullInt64
			var Fec_id 	sql.NullInt64
			var Amount 	sql.NullInt64
			var Interest 	sql.NullInt64
			var Updated_id 	sql.NullInt64
			var User	sql.NullString
			var Fec		sql.NullString
			var Updated	sql.NullString


			err := rows.Scan(&Id, &Dte, &User_id,&Fec_id, &Amount, &Interest, &Updated_id, &User, &Fec, &Updated)
			checkErr(err, errDBquery)

			tmp.Id = Id.Int64
			tmp.Dte = convertDateMYSQL2Web(string(Dte))
			tmp.User_id=User_id.Int64
			tmp.FEC_id=Fec_id.Int64
			tmp.Amount=int2floatStr(Amount.Int64)
			tmp.Interest=int2floatStr(Interest.Int64)
			tmp.Updated_id=Updated_id.Int64
			tmp.User=User.String
			tmp.FEC=Fec.String
			tmp.Updated=Updated.String

			//calculation
			interest := int64(daysUptoNowMysql(string(Dte))) * Amount.Int64 * Interest.Int64 / 3650000
			println(interest)
			tmp.CurrentInterest=int2floatStr(interest)
			tmp.Total=int2floatStr(Amount.Int64 + interest)
			savingsDepositsData.Deposits = append(savingsDepositsData.Deposits, tmp)
		}
		rows.Close()

		showFile(w, r, "savingsDeposits.html", savingsDepositsData)
	}else {
		login(w,r)
	}
}

func newSavingsDeposit(w http.ResponseWriter, r *http.Request) {
	if(r.Method == "POST"){
		r.ParseMultipartForm(32 << 20)
		insertData("deposit",r.FormValue("id") + ", '"+convertDateWeb2MySQL(r.FormValue("dte"))+"' , "+r.FormValue("user_id")+", "+r.FormValue("fec_id")+", "+strfloat2strint(r.FormValue("amount"))+", "+strfloat2strint(r.FormValue("interest"))+", "+r.FormValue("updated_id"))
	}
	http.Redirect(w, r, "savingsDeposits.html", http.StatusSeeOther)
}

func updateSavingsDeposit(w http.ResponseWriter, r *http.Request) {
	if(r.Method == "POST"){
		r.ParseMultipartForm(32 << 20)

		if(r.FormValue("action") == "save"){
			updateData("deposit",r.FormValue("id"),"dte='"+convertDateWeb2MySQL(r.FormValue("dte"))+"', user_id="+r.FormValue("user_id")+", fec_id="+r.FormValue("fec_id")+", amount="+strfloat2strint(r.FormValue("amount"))+", interest="+strfloat2strint(r.FormValue("interest"))+", updated_id="+r.FormValue("updated_id"))
		}else if(r.FormValue("action") == "delete"){
			deleteData("deposit",r.FormValue("id"))
		}

	}
	http.Redirect(w, r, "savingsDeposits.html", http.StatusSeeOther)
}

func banks(w http.ResponseWriter, r *http.Request) {
	if(checkUserValid(w,r)){

		showFile(w, r, "banks.html", "")
	}else {
		login(w,r)
	}
}

func login(w http.ResponseWriter, r *http.Request) {
	if(checkUserValid(w,r)){
		http.Redirect(w, r, "index.html", http.StatusSeeOther)
	}else if(r.Method == "POST"){
		r.ParseMultipartForm(32 << 20)

		sqlStr := "SELECT id FROM user WHERE email='"+r.FormValue("email")+"' AND pass='"+r.FormValue("pass")+"'"

		rows := getResultDB(sqlStr)

		for rows.Next(){

			var Id 		sql.NullInt64

			err := rows.Scan(&Id, )
			checkErr(err, errDBquery)

			setCookie(w,cookieUserId,strconv.Itoa(int(Id.Int64)))
		}
		rows.Close()



		http.Redirect(w, r, "index.html", http.StatusSeeOther)
	}else {
		showFile(w, r, "login.html","")
	}
}

func logout(w http.ResponseWriter, r *http.Request) {
	setCookie(w,cookieUserId,"-1")
	http.Redirect(w, r, "login.html", http.StatusSeeOther)
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


func main() {
	//initDatabase()
	http.HandleFunc("/test.html", test)
	http.HandleFunc("/login.html", login)
	http.HandleFunc("/logout.html", logout)
	http.HandleFunc("/index.html", index)

	http.HandleFunc("/settings.html", settings)
	http.HandleFunc("/newMemberType.html", newMemberType)
	http.HandleFunc("/updateMemberType.html", updateMemberType)

	http.HandleFunc("/members.html", members)
	http.HandleFunc("/newMember.html", newMember)
	http.HandleFunc("/updateMember.html", updateMember)

	http.HandleFunc("/savingsDeposits.html", savingsDeposits)
	http.HandleFunc("/newSavingsDeposit.html", newSavingsDeposit)
	http.HandleFunc("/updateSavingsDeposit.html", updateSavingsDeposit)

	http.HandleFunc("/banks.html", banks)


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
