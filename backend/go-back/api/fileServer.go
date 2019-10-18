package main

import (
	"fmt"
	"github.com/gorilla/mux"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"
)

func initFileServer(router *mux.Router) {
	router.HandleFunc("/file-api/view/{url:[^ ]*}", fileApiView)
	router.HandleFunc("/file-api/list/{url:[^ ]*}", fileApiList)
	router.HandleFunc("/file-api/delete/{url:[^ ]*}", fileApiDelete)
	router.HandleFunc("/file-api/create/{url:[^ ]*}", fileApiCreate)
}

func fileApiView(w http.ResponseWriter, r *http.Request) {
	_, status := checkJWT(w, r)

	if status != http.StatusOK {
		log.Println("AUTHENTICATION FAILED")
		http.Error(w, `{ "error":"AUTHENTICATION FAILED"}`, http.StatusUnauthorized)
		return
	}

	path := r.URL.Path[1:]
	path = strings.Replace(string(path), "file-api/view", fileServerDir, 1)

	data, err := ioutil.ReadFile(path)

	if err == nil {
		w.Write(data)
	} else {
		w.WriteHeader(404)
		w.Write([]byte("404 Something went wrong - " + http.StatusText(404)))
	}
}

func fileApiList(w http.ResponseWriter, r *http.Request) {
	_, status := checkJWT(w, r)

	if status != http.StatusOK {
		log.Println("AUTHENTICATION FAILED")
		http.Error(w, `{ "error":"AUTHENTICATION FAILED"}`, http.StatusUnauthorized)
		return
	}

	path := r.URL.Path[1:]
	path = strings.Replace(string(path), "file-api/list", fileServerDir, 1)

	files, err := ioutil.ReadDir(path)
	if err != nil {
		log.Println(err)
		http.Error(w, `{ "error":"`+strings.ToUpper(err.Error())+`"}`, http.StatusInternalServerError)
		return
	}
	str := `"files":[`
	for i, f := range files {
		if i != 0 {
			str += ","
		}
		str += `{"name":"`
		str += f.Name()
		str += `","size":`
		str += fmt.Sprintf(`"%d"`, f.Size())
		str += `}`
	}
	str += "]"
	Respond(w, str)
}

func fileApiDelete(w http.ResponseWriter, r *http.Request) {
	_, status := checkJWT(w, r)

	if status != http.StatusOK {
		log.Println("AUTHENTICATION FAILED")
		http.Error(w, `{ "error":"AUTHENTICATION FAILED"}`, http.StatusUnauthorized)
		return
	}

	path := r.URL.Path[1:]
	path = strings.Replace(string(path), "file-api/delete", fileServerDir, 1)

	err := os.Remove(path)
	if err != nil {
		log.Println(err)
		http.Error(w, `{ "error":"`+strings.ToUpper(err.Error())+`"}`, http.StatusInternalServerError)
		return
	}

	Respond(w, `{"filesAffected":1}`)
}

func fileApiCreate(w http.ResponseWriter, r *http.Request) {
	_, status := checkJWT(w, r)

	if status != http.StatusOK {
		log.Println("AUTHENTICATION FAILED")
		http.Error(w, `{ "error":"AUTHENTICATION FAILED"}`, http.StatusUnauthorized)
		return
	}

	path := r.URL.Path[1:]
	path = strings.Replace(string(path), "file-api/create", fileServerDir, 1)

	err := os.MkdirAll(path, 0777)
	err = os.Remove(path)

	// check if file exists
	_, err = os.Stat(path)

	// create file if not exists
	if os.IsNotExist(err) {
		file, err := os.Create(path)
		defer file.Close()
		if err != nil {
			log.Println(err)
			http.Error(w, `{ "error":"`+strings.ToUpper(err.Error())+`"}`, http.StatusInternalServerError)
			return
		}
	}

	// open file using READ & WRITE permission
	file, err := os.OpenFile(path, os.O_RDWR, 0644)
	defer file.Close()
	if err != nil {
		log.Println(err)
		http.Error(w, `{ "error":"`+strings.ToUpper(err.Error())+`"}`, http.StatusInternalServerError)
		return
	}

	bodyBytes, err := ioutil.ReadAll(r.Body)
	if err != nil {
		log.Fatal(err)
	}
	bodyString := string(bodyBytes)

	// write some text line-by-line to file
	_, err = file.WriteString(bodyString)
	if err != nil {
		log.Println(err)
		http.Error(w, `{ "error":"`+strings.ToUpper(err.Error())+`"}`, http.StatusInternalServerError)
		return
	}

	// save changes
	err = file.Sync()
	if err != nil {
		log.Println(err)
		http.Error(w, `{ "error":"`+strings.ToUpper(err.Error())+`"}`, http.StatusInternalServerError)
		return
	}

	Respond(w, `{"filesAffected":1}`)
}
