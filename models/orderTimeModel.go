package models

type OrderTime struct {
	Id   int64
	Did  int64
	Secs int64 `orm:"index"`
}
