package main

const defaultDB = "fecbank"
const userDB = "user"
const userDbReplaceStr = "@--DB-NAME--@"
const driverName = "mysql"

//const dataSourceName = "root:1234@tcp(localhost:3306)/"

//const dataSourceName = "aelo:qwertyui@tcp(prod-1.c8ai14fix4em.ap-southeast-1.rds.amazonaws.com)/"
const dataSourceName = "k123456789123456:qwertyui@tcp(devmysql.cbq5miudf693.us-east-2.rds.amazonaws.com)/"
const maxOpenCon = 10
const maxIdleCon = 10
const port = ":7654"
const jwtTokenValidMunites = 60

const fileServerDir = "./files"
