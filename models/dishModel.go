package models

type Dish struct {
	Id          int64
	Name        string
	DishType    string
	Detail      string
	DishPicPath string
	Rname       string `orm:"index"`
	Number      int64
}
