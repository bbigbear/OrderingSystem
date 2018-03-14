package controllers

import (
	"OrderingSystem/models"
	"fmt"

	_ "github.com/Go-SQL-Driver/MySQL"
	"github.com/alecthomas/log4go"
	"github.com/astaxie/beego/orm"
)

type OrderController struct {
	BaseController
}

func (this *OrderController) Get() {

	fmt.Println("获取餐厅信息")
	o := orm.NewOrm()
	var maps []orm.Params
	diningroom := new(models.DiningRoom)
	query := o.QueryTable(diningroom)
	filters := make([]interface{}, 0)
	//食堂
	cname := this.Input().Get("cname")
	if cname != "" {
		filters = append(filters, "CanteenName", cname)
	}
	fmt.Println("get cname:", cname)
	//餐厅
	rname := this.Input().Get("rname")
	if rname != "" {
		filters = append(filters, "Name", rname)
	}
	fmt.Println("get rname:", rname)
	if len(filters) > 0 {
		l := len(filters)
		for k := 0; k < l; k += 2 {
			query = query.Filter(filters[k].(string), filters[k+1])
		}
	}

	//查询数据库
	num, err := query.Filter("status", "营业中").Values(&maps)
	if err != nil {
		log4go.Stdout("获取餐厅失败", err.Error())
		this.ajaxMsg("获取餐厅失败", MSG_ERR_Resources)
	}
	fmt.Println("get diningroom reslut num:", num)
	this.Data["map"] = maps
	this.TplName = "student_index.tpl"
}
func (this *OrderController) GetRoomDetail() {

	//获取rid
	rid := this.Input().Get("rid")
	fmt.Println("rid:", rid)
	this.Data["id"] = rid

	//获取ready
	o := orm.NewOrm()
	var maps_ready models.Ready
	ready := new(models.Ready)
	err := o.QueryTable(ready).Filter("Rid", rid).Filter("Status", "正在点餐").One(&maps_ready)
	if err != nil {
		log4go.Stdout("获取准备菜单失败", err.Error())
		this.ajaxMsg("获取准备菜单失败", MSG_ERR_Resources)
	}
	tid := maps_ready.Tid

	//获取菜单类型
	var maps_mt []orm.Params
	mt := new(models.MenuType)
	num1, err := o.QueryTable(mt).Filter("Rid", rid).Values(&maps_mt)
	if err != nil {
		log4go.Stdout("获取菜单类型失败", err.Error())
		this.ajaxMsg("获取菜单类型失败", MSG_ERR_Resources)
	}
	fmt.Println("get menutype reslut num:", num1)
	this.Data["mt_info"] = maps_mt
	fmt.Println("mt_info:", maps_mt)

	//获取ready dish
	var maps_rd []orm.Params
	rd := new(models.ReadyDish)
	//
	num, err := o.QueryTable(rd).Filter("Tid", tid).Values(&maps_rd)
	if err != nil {
		log4go.Stdout("获取菜品失败", err.Error())
		this.ajaxMsg("获取菜品失败", MSG_ERR_Resources)
	}
	fmt.Println("get readydish reslut num:", num)
	this.Data["rd_info"] = maps_rd
	fmt.Println("rd_info:", maps_rd)
	this.TplName = "student_roomdetail.tpl"
}

func (this *OrderController) GetOrder() {

	this.TplName = "student_order.tpl"
}
