package models

type Dish struct {
	Id          int64
	Name        string
	Type        string
	Detail      string
	DishPicPath string
	Rname       string `orm:"index"`
}
