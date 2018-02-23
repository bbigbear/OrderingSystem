package models

type DiningRoom struct {
	Id              int64
	Name            string
	CanteenName     string `orm:"index"`
	Time            string
	Detail          string
	BusinessPicPath string
	RoomPicPath     string
}
