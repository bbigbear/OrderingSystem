package controllers

import (
	"OrderingSystem/models"
	"encoding/json"
	"fmt"
	"strconv"
	"strings"

	"time"

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
	//t := time.Now().Format("20060102150405")
	the_time, err := time.Parse("2006-01-02 15:04:05", time.Now().Format("2006-01-02 15:04:05"))
	if err != nil {
		fmt.Println("err!")
	}
	fmt.Println(the_time)
	this.TplName = "student_order.tpl"
}

func (this *OrderController) GetOrderData() {
	fmt.Println("获取订单信息")
	o := orm.NewOrm()
	var maps []orm.Params
	order := new(models.Order)
	query := o.QueryTable(order)
	sid := this.Input().Get("sid")
	fmt.Println("sid:", sid)
	//查询数据库
	num, err := query.Filter("Sid", sid).Values(&maps)
	if err != nil {
		log4go.Stdout("获取订单失败", err.Error())
		this.ajaxMsg("获取订单失败", MSG_ERR_Resources)
	}
	fmt.Println("get OrderInfo reslut num:", num)
	this.ajaxList("获取订单成功", 0, num, maps)
	return
}

func (this *OrderController) SureOrder() {
	//获取data
	price := this.Input().Get("price")
	fmt.Println("price:", price)
	name := this.Input().Get("name")
	fmt.Println("name:", name)
	this.Data["data"] = price
	this.TplName = "student_ordersure.tpl"
}

func (this *OrderController) AddOrder() {
	//订单
	fmt.Println("点击确认订单")
	o := orm.NewOrm()
	var os models.Os
	json.Unmarshal(this.Ctx.Input.RequestBody, &os)
	fmt.Println("order_info:", &os)
	//生成订单号  日期+随机四位
	t := time.Now().Format("20060102150405")
	r := this.GetRandomString(4)
	oid := fmt.Sprintf("%s%s", t, r)
	//fmt.Println(f)

	nameList := strings.Split(os.Name, "|")
	priceList := strings.Split(os.Price, "|")
	numList := strings.Split(os.Num, "|")
	l := len(nameList) - 1
	var sum = float64(0)
	for i := 0; i < l; i++ {
		var status models.OrderStauts
		status.Name = nameList[i]
		status.Oid = oid
		num, err := strconv.ParseInt(numList[i], 10, 64)
		if err != nil {
			fmt.Println("err!")
			this.ajaxMsg("num格式有误", MSG_ERR_Param)
		}
		status.Num = num
		price, err := strconv.ParseFloat(priceList[i], 64)
		if err != nil {
			fmt.Println("err!")
			this.ajaxMsg("price格式有误", MSG_ERR_Param)
		}
		status.Price = price
		insert_num, err := o.Insert(&status)
		if err != nil {
			fmt.Println("err!")
			this.ajaxMsg("插入失败", MSG_ERR_Resources)
		}
		fmt.Println("insert num", insert_num)

		sum += price * float64(num)
	}
	//rname,sname
	dr := new(models.DiningRoom)
	var dr_info models.DiningRoom
	err1 := o.QueryTable(dr).Filter("Id", os.Rid).One(&dr_info)
	if err1 != nil {
		this.ajaxMsg("rid格式有误", MSG_ERR_Param)
	}

	student := new(models.Student)
	var stu_info models.Student
	err2 := o.QueryTable(student).Filter("Id", os.Sid).One(&stu_info)
	if err2 != nil {
		this.ajaxMsg("sid格式有误", MSG_ERR_Param)
	}
	//获取
	var order models.Order
	order.Oid = oid
	order.Ostatus = "未取餐"
	order.Otime = time.Now()
	order.Otype = "午餐"
	order.Rid = os.Rid
	order.Rname = dr_info.Name
	order.Sid = os.Sid
	order.Sname = stu_info.Name
	order.Total = sum
	insert_order, err := o.Insert(&order)
	if err != nil {
		fmt.Println("err!")
		this.ajaxMsg("插入失败", MSG_ERR_Resources)
	}
	fmt.Println("insert order", insert_order)
	this.ajaxMsg("下订单成功", MSG_OK)
}

//订单详情
func (this *OrderController) GetOrderDetail() {
	fmt.Println("获取订单详情")
	o := orm.NewOrm()
	var maps []orm.Params
	order := new(models.Order)
	query := o.QueryTable(order)
	oid := this.Input().Get("oid")
	fmt.Println("oid:", oid)
	this.Data["oid"] = oid
	//查询数据库
	num, err := query.Filter("Oid", oid).Values(&maps)
	if err != nil {
		log4go.Stdout("获取订单失败", err.Error())
		this.ajaxMsg("获取订单失败", MSG_ERR_Resources)
	}
	fmt.Println("get OrderInfo reslut num:", num)
	this.Data["map"] = maps
	this.TplName = "student_orderdetail.tpl"
}

func (this *OrderController) GetOrderList() {
	fmt.Println("获取订单列表")
	o := orm.NewOrm()
	var maps []orm.Params
	order := new(models.OrderStauts)
	query := o.QueryTable(order)
	oid := this.Input().Get("oid")
	fmt.Println("oid:", oid)
	//查询数据库
	num, err := query.Filter("Oid", oid).Values(&maps)
	if err != nil {
		log4go.Stdout("获取订单失败", err.Error())
		this.ajaxMsg("获取订单失败", MSG_ERR_Resources)
	}
	fmt.Println("get OrderInfo reslut num:", num)
	this.ajaxList("获取订单成功", 0, num, maps)
	return
}
