package main

import (
	"github.com/gorilla/mux"
	"net/http"
)

func initBankBook(router *mux.Router) {
	router.HandleFunc("/api/viewAllBankBookSavings", viewAllBankBookSavings).Methods("POST", "OPTIONS")
	router.HandleFunc("/api/insertBankBookSaving", insertBankBookSaving).Methods("POST", "OPTIONS")
	router.HandleFunc("/api/cancelBankBookSaving", cancelBankBookSaving).Methods("POST", "OPTIONS")
	router.HandleFunc("/api/updateBankBookSaving", updateBankBookSaving).Methods("POST", "OPTIONS")
}

func viewAllBankBookSavings(w http.ResponseWriter, r *http.Request) {
	query(w, r, `SELECT m.*, date_format(m.req_date,'%Y-%m-%d') AS req_date, u.name AS updated_by
						FROM `+userDbReplaceStr+`.bank_book_ledger AS m
						LEFT JOIN `+userDB+`.user AS u ON m.req_user=u.id 
						WHERE m.status <> 0
						ORDER BY m.req_date DESC`)
}

func insertBankBookSaving(w http.ResponseWriter, r *http.Request) {
	execute(w, r, `INSERT INTO `+userDbReplaceStr+`.bank_book_ledger
			(bank_book_id, amount, rate, req_date, req_user, status, note) 
			VALUES(:bank_book_id, :amount, :rate, :req_date, :req_user, :status, :note)`)
}

func cancelBankBookSaving(w http.ResponseWriter, r *http.Request) {
	execute(w, r, `UPDATE `+userDbReplaceStr+`.bank_book_ledger SET status=4, req_user=:req_user where id=(:id)`)
}

func updateBankBookSaving(w http.ResponseWriter, r *http.Request) {
	execute(w, r, `UPDATE `+userDbReplaceStr+`.bank_book_ledger 
SET  amount=:amount, rate=:rate, req_date=:req_date, req_user=:req_user, note=:note
						where id=(:id)`)
}
