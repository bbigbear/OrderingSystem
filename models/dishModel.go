package models

type Dish struct {
	Id          int64
	Rid         int64
	Name        string
	DishType    string
	Detail      string
	DishPicPath string
	Rname       string `orm:"index"`
	Price       float64
}
