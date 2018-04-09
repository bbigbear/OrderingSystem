package models

import (
	"time"
)

type Order struct {
	Id      int64
	Ostatus string
	Oid     string
	Sid     string
	Sname   string
	Rid     int64
	Otype   string
	Otime   time.Time
	Rname   string
	Total   float64
	Readyid int64
}
