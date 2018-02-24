package controllers

import (
	"OrderingSystem/models"
	"encoding/json"
	"fmt"

	_ "github.com/Go-SQL-Driver/MySQL"
	"github.com/alecthomas/log4go"
	"github.com/astaxie/beego/orm"
)

type DiningRoomController struct {
	BaseController
}

func (this *DiningRoomController) Get() {
	o := orm.NewOrm()
	var maps []orm.Params
	canteen := new(models.Canteen)
	//获取campus
	campus := this.Input().Get("campus")
	if campus == "" {
		campus = "雁塔校区"
	}
	fmt.Println("campus:", campus)
	this.Data["campus"] = campus
	//查询数据库
	num, err := o.QueryTable(canteen).Filter("CampusName", campus).Values(&maps)
	if err != nil {
		log4go.Stdout("获取食堂失败", err.Error())
		this.ajaxMsg("获取食堂失败", MSG_ERR_Resources)
	}
	fmt.Println("get canteen reslut num:", num)
	this.Data["canteen_info"] = maps

	this.TplName = "dining_room.tpl"
}

func (this *DiningRoomController) AddRoom() {
	o := orm.NewOrm()
	var maps []orm.Params
	canteen := new(models.Canteen)
	//获取campus
	campus := this.Input().Get("campus")
	if campus == "" {
		campus = "雁塔校区"
	}
	fmt.Println("campus:", campus)
	//this.Data["campus"] = campus
	//查询食堂数据库
	num, err := o.QueryTable(canteen).Filter("CampusName", campus).Values(&maps)
	if err != nil {
		log4go.Stdout("获取食堂失败", err.Error())
		this.ajaxMsg("获取食堂失败", MSG_ERR_Resources)
	}
	fmt.Println("get canteen reslut num:", num)
	this.Data["canteen_info"] = maps
	//查询时段数据库
	var timemaps []orm.Params
	diningtime := new(models.DiningTime)

	num, err1 := o.QueryTable(diningtime).Values(&timemaps)
	if err1 != nil {
		log4go.Stdout("获取时段失败", err.Error())
		this.ajaxMsg("获取时段失败", MSG_ERR_Resources)
	}
	fmt.Println("get diningtime reslut num:", num)
	this.Data["time_info"] = timemaps

	this.TplName = "add_diningroom.tpl"
}

func (this *DiningRoomController) AddRoomAction() {
	fmt.Println("点击新增餐厅按钮")
	//定义
	o := orm.NewOrm()
	list := make(map[string]interface{})
	var diningroom models.DiningRoom
	json.Unmarshal(this.Ctx.Input.RequestBody, &diningroom)
	fmt.Println("diningroom_info:", &diningroom)
	//插入餐厅数据库
	num, err := o.Insert(&diningroom)
	if err != nil {
		log4go.Stdout("新增餐厅失败", err.Error())
		this.ajaxMsg("新增失败", MSG_ERR_Resources)
	}
	fmt.Println("自增Id(num)", num)

	list["id"] = num
	this.ajaxList("新增成功", MSG_OK, 1, list)
	return
}
