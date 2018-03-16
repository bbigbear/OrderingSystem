package models

type Order struct {
	Id      int64
	Ostatus string
	Oid     string
	Sid     int64
	Sname   string
	Rid     int64
	Otype   string
	Otime   string
	Rname   string
	Total   float64
}
