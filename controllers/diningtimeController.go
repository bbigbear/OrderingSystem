package controllers

import (
	"OrderingSystem/models"
	"encoding/json"
	"fmt"

	_ "github.com/Go-SQL-Driver/MySQL"
	"github.com/alecthomas/log4go"
	"github.com/astaxie/beego/orm"
)

type DiningTimeController struct {
	BaseController
}

func (this *DiningTimeController) Get() {
	if this.GetSession("islogin") != 1 {
		fmt.Println("未登录")
		this.Redirect("/v1/login", 302)
	}
	this.TplName = "dining_time.tpl"
}

func (this *DiningTimeController) GetTimeData() {
	fmt.Println("获取时段数据")
	o := orm.NewOrm()
	var maps []orm.Params
	diningtime := new(models.DiningTime)

	//查询数据库
	num, err := o.QueryTable(diningtime).Values(&maps)
	if err != nil {
		log4go.Stdout("获取食堂失败", err.Error())
		this.ajaxMsg("获取食堂失败", MSG_ERR_Resources)
	}
	fmt.Println("get diningtime reslut num:", num)
	this.ajaxList("获取菜品成功", 0, num, maps)
	return

}

func (this *DiningTimeController) AddTime() {
	if this.GetSession("islogin") != 1 {
		fmt.Println("未登录")
		this.Redirect("/v1/login", 302)
	}
	this.TplName = "add_diningtime.tpl"
}

func (this *DiningTimeController) AddTimeAction() {
	fmt.Println("点击添加时段按钮")
	o := orm.NewOrm()
	list := make(map[string]interface{})
	var time_info models.DiningTime
	json.Unmarshal(this.Ctx.Input.RequestBody, &time_info)
	fmt.Println("time_info:", &time_info)

	//插入数据库
	num, err := o.Insert(&time_info)
	if err != nil {
		log4go.Stdout("新增时段失败")
		this.ajaxMsg("新增失败", MSG_ERR_Resources)
	}
	fmt.Println("自增Id(num)", num)
	//this.ajaxMsg("新增成功", MSG_OK)
	list["id"] = num
	this.ajaxList("新增成功", MSG_OK, 1, list)
	return
}

func (this *DiningTimeController) DelTime() {
	fmt.Println("点击删除时段按钮")
	//获取id
	id, err := this.GetInt("id")
	if err != nil {
		log4go.Stdout("删除时段id失败", err.Error())
		this.ajaxMsg("删除时段id失败", MSG_ERR_Param)
	}
	fmt.Println("删除时段id:", id)
	o := orm.NewOrm()
	diningtime := new(models.DiningTime)
	num, err := o.QueryTable(diningtime).Filter("Id", id).Delete()
	if err != nil {
		log4go.Stdout("删除时段失败", err.Error())
		this.ajaxMsg("删除时段失败", MSG_ERR_Resources)
	}
	fmt.Println("del canteen reslut num:", num)
	//list["data"] = maps
	this.ajaxMsg("删除时段成功", MSG_OK)
	return

}
