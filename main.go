package main

import (
	_ "OrderingSystem/routers"

	"OrderingSystem/models"
	"fmt"

	_ "github.com/Go-SQL-Driver/MySQL"
	"github.com/alecthomas/log4go"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

func init() {
	DBConnection()
	RegisterModel()
	//初始化日志
	log4go.LoadConfiguration("log4go.xml")
	log4go.Info("log4go init ok")

	beego.SetStaticPath("/upload", "images")
	//定时
	//controllers.TimeTask()

}

func main() {
	orm.Debug = true
	orm.RunSyncdb("default", false, true)
	beego.Run()

}
func DBConnection() {
	fmt.Println("初始化数据库")
	orm.RegisterDriver("mysql", orm.DRMySQL)
	orm.RegisterDataBase("default", "mysql", "root:qwe!23@/ordering_system?charset=utf8&loc=Local")
}

func RegisterModel() {
	fmt.Println("注册数据库模型")
	orm.RegisterModel(new(models.Canteen), new(models.DiningTime), new(models.DiningRoom), new(models.TimeInterval), new(models.DishType), new(models.Dish), new(models.MenuType), new(models.ReadyDish), new(models.TempReady), new(models.Ready), new(models.Order), new(models.OrderStauts), new(models.Student))
	//orm.RegisterModel(new(models.))
	//orm.RegisterModel(new(models.OrderTime))
}
