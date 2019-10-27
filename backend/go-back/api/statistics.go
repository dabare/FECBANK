package main

import (
	"github.com/gorilla/mux"
	"net/http"
)

func initStatistics(router *mux.Router) {
	router.HandleFunc("/api/getStatistics", getStatistics).Methods("POST", "OPTIONS")
	router.HandleFunc("/api/getTop5Savers", getTop5Savers).Methods("POST", "OPTIONS")
}

func getStatistics(w http.ResponseWriter, r *http.Request) {
	query(w, r, `SELECT * FROM `+userDbReplaceStr+`.statistics`)
}
func getTop5Savers(w http.ResponseWriter, r *http.Request) {
	query(w, r, `SELECT * FROM `+userDbReplaceStr+`.member_savings_top_5`)
}
