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
	if this.GetSession("islogin") != 1 {
		fmt.Println("未登录")
		this.Redirect("/v1/login", 302)
	}
	fmt.Println("获取餐厅信息")
	//获取sid
	sid := this.Input().Get("sid")
	fmt.Println("sid:", sid)
	this.Data["sid"] = sid

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
	//获取正在点餐的rid
	ready := new(models.Ready)
	var ready_maps []orm.Params
	var list []int64
	ready_num, err := o.QueryTable(ready).Filter("Status", "正在点餐").Values(&ready_maps)
	if err != nil {
		fmt.Println("get rid in ready err!")
	}
	if ready_num != 0 {
		for _, m := range ready_maps {
			list = append(list, m["Rid"].(int64))
		}
		fmt.Println("rid list:", list)
		//查询数据库
		num, err := query.Filter("Id__in", list).Filter("status", "营业中").Values(&maps)
		if err != nil {
			log4go.Stdout("获取餐厅失败", err.Error())
			this.ajaxMsg("获取餐厅失败", MSG_ERR_Resources)
		}
		fmt.Println("get diningroom reslut num:", num)

	}
	this.Data["map"] = maps
	this.TplName = "student_index.tpl"
}
func (this *OrderController) GetRoomDetail() {
	if this.GetSession("islogin") != 1 {
		fmt.Println("未登录")
		this.Redirect("/v1/login", 302)
	}
	//获取rid
	rid := this.Input().Get("rid")
	fmt.Println("rid:", rid)
	this.Data["id"] = rid

	//获取sid
	sid := this.Input().Get("sid")
	fmt.Println("sid:", sid)
	this.Data["sid"] = sid

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
	//传入readyId
	this.Data["readyId"] = maps_ready.Id

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
	//只获取数量大于0的菜品
	num, err := o.QueryTable(rd).Filter("Tid", tid).Filter("Number__gt", 0).Values(&maps_rd)
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
	if this.GetSession("islogin") != 1 {
		fmt.Println("未登录")
		this.Redirect("/v1/login", 302)
	}
	//获取sid
	sid := this.Input().Get("sid")
	fmt.Println("sid:", sid)
	this.Data["sid"] = sid

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
	if this.GetSession("islogin") != 1 {
		fmt.Println("未登录")
		this.Redirect("/v1/login", 302)
	}
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
		//减少数量 同一时间段 一个卖家只能限制一个窗口点餐
		ready := new(models.Ready)
		ready_dish := new(models.ReadyDish)
		var ready_maps []orm.Params
		var dish_maps []orm.Params
		var dish models.ReadyDish
		ready_num, err := o.QueryTable(ready).Filter("Status", "正在点餐").Filter("Rid", os.Rid).Values(&ready_maps)
		if err != nil {
			fmt.Println("get tid from ready err!")
		}
		if ready_num == 1 {
			for _, m := range ready_maps {
				num, err := o.QueryTable(ready_dish).Filter("Tid", m["Tid"].(int64)).Filter("Dname", nameList[i]).Values(&dish_maps)
				if err != nil {
					fmt.Println("get ready ")
				}
				fmt.Println("get ready_dish num", num)
				for _, d := range dish_maps {
					dish.Id = d["Id"].(int64)
					dish.Number = int(d["Number"].(int64)) - int(status.Num)
					num, err := o.Update(&dish, "Number")
					if err != nil {
						fmt.Println("update ready_dish number err!")
					}
					fmt.Println("update num", num)
				}

			}
		}
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
	err2 := o.QueryTable(student).Filter("Sid", os.Sid).One(&stu_info)
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
	order.Readyid = os.Readyid
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
	if this.GetSession("islogin") != 1 {
		fmt.Println("未登录")
		this.Redirect("/v1/login", 302)
	}
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
