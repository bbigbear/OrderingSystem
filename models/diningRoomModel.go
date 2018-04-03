package models

type DiningRoom struct {
	Id              int64
	Rid             string
	Name            string
	Phone           string
	CanteenName     string `orm:"index"`
	Time            string
	Detail          string
	BusinessPicPath string
	RoomPicPath     string
	Status          string `orm:"index"`
	Pwd             string
}
