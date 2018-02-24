package controllers

import (
	"OrderingSystem/models"
	"encoding/json"
	"fmt"

	_ "github.com/Go-SQL-Driver/MySQL"
	"github.com/alecthomas/log4go"
	"github.com/astaxie/beego/orm"
)

type CanteenController struct {
	BaseController
}

func (this *CanteenController) Get() {
	o := orm.NewOrm()
	var maps []orm.Params
	canteen := new(models.Canteen)
	//获取campus
	campus := this.Input().Get("campus")
	if campus == "" {
		campus = "雁塔校区"
	}
	fmt.Println("campus:", campus)
	//查询数据库
	num, err := o.QueryTable(canteen).Filter("CampusName", campus).Values(&maps)
	if err != nil {
		log4go.Stdout("获取食堂失败", err.Error())
		this.ajaxMsg("获取食堂失败", MSG_ERR_Resources)
	}
	fmt.Println("get canteen reslut num:", num)
	this.Data["canteen_info"] = maps

	this.TplName = "canteen.tpl"
}

func (this *CanteenController) AddCanteen() {
	fmt.Println("加载添加食堂按钮")
	//获取校区
	campus := this.Input().Get("campus")
	fmt.Println("campus:", campus)
	this.Data["campus_name"] = campus

	this.TplName = "add_canteen.tpl"
}

func (this *CanteenController) AddCanteenAction() {
	fmt.Println("点击添加食堂按钮")
	o := orm.NewOrm()
	var canteen_info models.Canteen
	json.Unmarshal(this.Ctx.Input.RequestBody, &canteen_info)
	fmt.Println("canteen_info:", &canteen_info)

	//插入数据库
	num, err := o.Insert(&canteen_info)
	if err != nil {
		log4go.Stdout("新增食堂失败")
		this.ajaxMsg("新增失败", MSG_ERR_Resources)
	}
	fmt.Println("自增Id(num)", num)
	this.ajaxMsg("新增成功", MSG_OK)
	return
}

func (this *CanteenController) DelCanteen() {
	fmt.Println("点击删除食堂按钮")
	//获取id
	id, err := this.GetInt("id")
	if err != nil {
		log4go.Stdout("获取食堂id失败", err.Error())
		this.ajaxMsg("获取食堂id失败", MSG_ERR_Param)
	}
	fmt.Println("删除食堂id:", id)
	o := orm.NewOrm()
	canteen := new(models.Canteen)
	num, err := o.QueryTable(canteen).Filter("Id", id).Delete()
	if err != nil {
		log4go.Stdout("删除食堂失败", err.Error())
		this.ajaxMsg("删除食堂失败", MSG_ERR_Resources)
	}
	fmt.Println("del canteen reslut num:", num)
	//list["data"] = maps
	this.ajaxMsg("删除食堂成功", MSG_OK)
	return

}
