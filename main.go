package main

import (
	"OrderingSystem/models"
	_ "OrderingSystem/routers"
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
	host := beego.AppConfig.String("host")
	db := beego.AppConfig.String("database")
	user := beego.AppConfig.String("user")
	passwd := beego.AppConfig.String("passwd")
	maxOpenConns, err := beego.AppConfig.Int("MaxOpenConns")
	if err != nil {
		fmt.Println("MaxOpenConns is nil", err)
	}
	maxIdleConns, err := beego.AppConfig.Int("MaxIdleConns")
	if err != nil {
		fmt.Println("MaxIdleConns is nil", err)
	}
	sql := fmt.Sprintf("%s:%s@tcp(%s)/%s?charset=utf8&loc=Local", user, passwd, host, db)
	orm.RegisterDataBase("default", "mysql", sql, maxIdleConns, maxOpenConns)
	//orm.RegisterDataBase("default", "mysql", "root:qwe!23@/ordering_system?charset=utf8&loc=Local")
}

func RegisterModel() {
	fmt.Println("注册数据库模型")
	orm.RegisterModel(new(models.Campus), new(models.Canteen), new(models.DiningTime), new(models.DiningRoom), new(models.TimeInterval), new(models.DishType), new(models.Dish), new(models.MenuType), new(models.ReadyDish), new(models.TempReady), new(models.Ready), new(models.Order), new(models.OrderStauts), new(models.Student))
	//orm.RegisterModel(new(models.))
	//orm.RegisterModel(new(models.OrderTime))
}
