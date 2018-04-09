package controllers

import (
	"OrderingSystem/models"
	"encoding/json"
	"fmt"
	"strconv"
	"strings"

	_ "github.com/Go-SQL-Driver/MySQL"
	"github.com/alecthomas/log4go"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/toolbox"
)

type ReadyController struct {
	BaseController
}

func (this *ReadyController) Get() {
	//获取name
	id := this.Input().Get("id")
	fmt.Println("id:", id)
	this.Data["id"] = id

	o := orm.NewOrm()
	var maps []orm.Params
	timeInterval := new(models.TimeInterval)
	num, err := o.QueryTable(timeInterval).Filter("Rid", id).Values(&maps)
	if err != nil {
		log4go.Stdout("获取时间类型失败", err.Error())
		this.ajaxMsg("获取时间类型失败", MSG_ERR_Resources)
	}
	fmt.Println("get time reslut num:", num)
	//list["data"] = maps
	this.Data["time"] = maps

	//获取模板下拉列表
	var temp_maps []orm.Params
	temp := new(models.TempReady)
	num1, err := o.QueryTable(temp).Filter("Rid", id).Values(&temp_maps)
	if err != nil {
		log4go.Stdout("获取模板类型失败", err.Error())
		this.ajaxMsg("获取模板类型失败", MSG_ERR_Resources)
	}
	fmt.Println("get temp reslut num:", num1)
	this.Data["temp"] = temp_maps
	//时间种类获取
	var maps_ti []orm.Params
	ti := new(models.TimeInterval)
	num2, err := o.QueryTable(ti).Filter("Rid", id).Values(&maps_ti)
	if err != nil {
		log4go.Stdout("获取时间类型失败", err.Error())
		this.ajaxMsg("获取时间类型失败", MSG_ERR_Resources)
	}
	fmt.Println("get dishType result num:", num2)
	this.Data["maps_ti"] = maps_ti
	//获取备份内容
	var maps_ready []orm.Params
	var new_maps_ready []map[string]interface{}
	ready := new(models.Ready)
	num3, err := o.QueryTable(ready).Filter("Rid", id).Values(&maps_ready)
	if err != nil {
		log4go.Stdout("获取备份失败", err.Error())
		this.ajaxMsg("获取备份失败", MSG_ERR_Resources)
	}
	fmt.Println("get ready result num:", num3)

	l := len(maps_ready) - 1
	//fmt.Println("maps_ready:", l, maps_ready)
	//倒叙map
	for i := l; i >= 0; i-- {
		new_maps_ready = append(new_maps_ready, maps_ready[i])
	}
	this.Data["maps_ready"] = new_maps_ready

	//获取备份食材
	var maps_rd []orm.Params
	readydish := new(models.ReadyDish)
	num4, err := o.QueryTable(readydish).Values(&maps_rd)
	if err != nil {
		log4go.Stdout("获取备份食材失败", err.Error())
		this.ajaxMsg("获取备份食材失败", MSG_ERR_Resources)
	}
	fmt.Println("get readydish result num:", num4)
	this.Data["maps_rd"] = maps_rd
	this.TplName = "restaurant_ready.tpl"
}

//新增模板
func (this *ReadyController) AddTempReady() {
	//获取id
	id := this.Input().Get("id")
	fmt.Println("id:", id)
	this.Data["id"] = id

	this.TplName = "restaurant_addtemp.tpl"
}

func (this *ReadyController) AddTempReadyAction() {
	fmt.Println("点击新增模板按钮")
	//定义
	o := orm.NewOrm()
	list := make(map[string]interface{})
	var temp models.TempReady
	json.Unmarshal(this.Ctx.Input.RequestBody, &temp)
	fmt.Println("temp_info:", &temp)
	//插入模板数据库
	num, err := o.Insert(&temp)
	if err != nil {
		log4go.Stdout("新增模板失败", err.Error())
		this.ajaxMsg("新增失败", MSG_ERR_Resources)
	}
	fmt.Println("自增Id(num)", num)

	list["id"] = num
	this.ajaxList("新增成功", MSG_OK, 1, list)
	return
}

//获取模板信息
func (this *ReadyController) GetTempData() {
	fmt.Println("获取模板信息")
	o := orm.NewOrm()
	var maps []orm.Params
	temp := new(models.TempReady)
	query := o.QueryTable(temp)
	id := this.Input().Get("id")
	fmt.Println("id:", id)
	//查询数据库
	num, err := query.Filter("Rid", id).Values(&maps)
	if err != nil {
		log4go.Stdout("获取模板失败", err.Error())
		this.ajaxMsg("获取模板失败", MSG_ERR_Resources)
	}
	fmt.Println("get temp reslut num:", num)
	this.ajaxList("获取模板成功", 0, num, maps)
	return
}

//删除模板信息
func (this *ReadyController) DelTemp() {
	fmt.Println("点击删除模板按钮")
	//获取id
	id, err := this.GetInt("id")
	if err != nil {
		log4go.Stdout("删除模板id失败", err.Error())
		this.ajaxMsg("删除模板id失败", MSG_ERR_Param)
	}
	fmt.Println("删除模板id:", id)
	o := orm.NewOrm()
	temp := new(models.TempReady)
	num, err := o.QueryTable(temp).Filter("Id", id).Delete()
	if err != nil {
		log4go.Stdout("删除模板失败", err.Error())
		this.ajaxMsg("删除模板失败", MSG_ERR_Resources)
	}
	fmt.Println("del temp reslut num:", num)
	//list["data"] = maps
	this.ajaxMsg("删除模板成功", MSG_OK)
	return
}

//删除备餐记录
func (this *ReadyController) DelReady() {
	fmt.Println("点击删除")
	//获取id
	id, err := this.GetInt("id")
	if err != nil {
		log4go.Stdout("删除菜品id失败", err.Error())
		this.ajaxMsg("删除菜品id失败", MSG_ERR_Param)
	}
	fmt.Println("删除备餐记录id:", id)
	o := orm.NewOrm()
	ready := new(models.Ready)
	num, err := o.QueryTable(ready).Filter("Id", id).Delete()
	if err != nil {
		log4go.Stdout("删除备餐失败", err.Error())
		this.ajaxMsg("删除备餐失败", MSG_ERR_Resources)
	}
	fmt.Println("del canteen reslut num:", num)
	//list["data"] = maps
	this.ajaxMsg("删除备餐记录成功", MSG_OK)
	return
}

//
func (this *ReadyController) GetOrder() {
	fmt.Println("查看订单")
	//获取id
	readyid := this.Input().Get("readyid")
	fmt.Println("readyid:", readyid)
	this.Data["readyid"] = readyid

	this.TplName = "restaurant_getorder.tpl"
}

//查看订单
func (this *ReadyController) GetOrderAction() {
	fmt.Println("查看订单")
	o := orm.NewOrm()
	var maps []orm.Params
	order := new(models.Order)
	query := o.QueryTable(order)
	readyid := this.Input().Get("readyid")
	fmt.Println("readyid:", readyid)
	//查询数据库
	num, err := query.Filter("Readyid", readyid).Values(&maps)
	if err != nil {
		log4go.Stdout("获取订单失败", err.Error())
		this.ajaxMsg("获取订单失败", MSG_ERR_Resources)
	}
	fmt.Println("get OrderInfo reslut num:", num)
	this.ajaxList("获取订单成功", 0, num, maps)
	return
}

//编辑模板
func (this *ReadyController) EditTemp() {
	//获取rid
	rid := this.Input().Get("rid")
	fmt.Println("rid:", rid)
	this.Data["id"] = rid
	//获取tid
	id := this.Input().Get("id")
	fmt.Println("tid:", id)
	this.Data["tid"] = id

	//获取菜单类型
	o := orm.NewOrm()
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

	//获取每个菜单下的菜品
	var maps_rd []orm.Params
	rd := new(models.ReadyDish)
	//
	num, err := o.QueryTable(rd).Filter("Tid", id).Values(&maps_rd)
	if err != nil {
		log4go.Stdout("获取菜品失败", err.Error())
		this.ajaxMsg("获取菜品失败", MSG_ERR_Resources)
	}
	fmt.Println("get readydish reslut num:", num)
	this.Data["rd_info"] = maps_rd
	fmt.Println("rd_info:", maps_rd)

	this.TplName = "restaurant_edittemp.tpl"
}

func (this *ReadyController) AddTempAction() {
	fmt.Println("点击添加模板按钮")
	o := orm.NewOrm()
	list := make(map[string]interface{})
	var temp_info models.TempReady
	json.Unmarshal(this.Ctx.Input.RequestBody, &temp_info)
	fmt.Println("temp_info:", &temp_info)

	//插入数据库
	num, err := o.Insert(&temp_info)
	if err != nil {
		log4go.Stdout("新增模板失败")
		this.ajaxMsg("新增失败", MSG_ERR_Resources)
	}
	fmt.Println("自增Id(num)", num)
	list["id"] = num
	this.ajaxList("新增成功", MSG_OK, 1, list)
	//this.ajaxMsg("新增成功", MSG_OK)
	return

}

//为模板添加菜品
func (this *ReadyController) AddReadyDish() {
	//获取id
	id := this.Input().Get("id")
	fmt.Println("id:", id)
	this.Data["id"] = id
	//获取mname
	mname := this.Input().Get("mname")
	fmt.Println("mname:", mname)
	this.Data["mname"] = mname
	//获取tid
	tid := this.Input().Get("tid")
	fmt.Println("tid:", tid)
	this.Data["tid"] = tid

	//种类获取
	o := orm.NewOrm()
	var maps []orm.Params
	dishtype := new(models.DishType)
	num, err := o.QueryTable(dishtype).Filter("Rid", id).Values(&maps)
	if err != nil {
		log4go.Stdout("获取菜品种类失败", err.Error())
		this.ajaxMsg("获取菜品总类失败", MSG_ERR_Resources)
	}
	fmt.Println("get dishType result num:", num)
	this.Data["map"] = maps

	this.TplName = "restaurant_choosedish.tpl"
}

//批量添加
func (this *ReadyController) AddMultiReadyDish() {
	fmt.Println("添加准备菜品数据")

	//获取rid
	tid := this.Input().Get("tid")
	fmt.Println("tid:", tid)
	this.Data["tid"] = tid
	//string转为int64
	t, err := strconv.ParseInt(tid, 10, 64)
	if err != nil {
		log4go.Stdout("获取tid失败", err.Error())
		this.ajaxMsg("tid必须为string类型", MSG_ERR_Param)
	}
	//rd := new(models.ReadyDish)
	//list := make(map[string]interface{})
	dname := this.Input().Get("dname")
	fmt.Println("add dname:", dname)
	nameList := strings.Split(dname, ",")
	fmt.Println("nameList:", nameList)
	name_len := len(nameList) - 1
	//pic
	pic := this.Input().Get("pic")
	fmt.Println("add pic:", pic)
	picList := strings.Split(dname, ",")
	fmt.Println("picList:", picList)
	//pic_len := len(picList) - 1
	//price
	price := this.Input().Get("price")
	fmt.Println("add price:", price)
	priceList := strings.Split(price, ",")
	fmt.Println("priceList:", priceList)
	//price_len := len(priceList) - 1
	//get number
	number, err := this.GetInt("number")
	if err != nil {
		log4go.Stdout("获取number失败", err.Error())
		this.ajaxMsg("number必须为int类型", MSG_ERR_Param)
	}
	fmt.Println("number:", number)
	//get mname
	mname := this.Input().Get("mname")
	fmt.Println("add mname:", mname)
	o := orm.NewOrm()
	for i := 0; i < name_len; i++ {
		p, err := strconv.ParseFloat(priceList[i], 64)
		if err != nil {
			log4go.Stdout("string 转 float64 失败", err.Error())
		}
		rd := new(models.ReadyDish)
		var rd_info models.ReadyDish
		rd_info.Tid = t
		rd_info.Dname = nameList[i]
		rd_info.Pic = picList[i]
		rd_info.Price = p
		rd_info.Number = number
		rd_info.Mname = mname
		//查询是否重复
		count, err := o.QueryTable(rd).Filter("Dname", nameList[i]).Filter("Mname", mname).Filter("Tid", tid).Count()
		if err != nil {
			log4go.Stdout("查询菜品失败", err.Error())
		}
		if count == 0 {
			num, err := o.Insert(&rd_info)
			if err != nil {
				log4go.Stdout("添加菜品失败", err.Error())
				this.ajaxMsg("添加失败", MSG_ERR_Resources)
			}
			fmt.Println("自增Id(num)", num)
		} else {
			fmt.Println("存在相同的菜品:", nameList[i])
		}
	}
	//list["data"] = maps
	this.ajaxMsg("添加菜品成功", MSG_OK)
	return
}

func (this *ReadyController) AddReadyDishAction1() {
	fmt.Println("点击添加菜品按钮")
	o := orm.NewOrm()
	list := make(map[string]interface{})
	var rd_ifno models.ReadyDish
	json.Unmarshal(this.Ctx.Input.RequestBody, &rd_ifno)
	fmt.Println("rd_ifno:", &rd_ifno)

	//插入数据库
	num, err := o.Insert(&rd_ifno)
	if err != nil {
		log4go.Stdout("新增菜品失败")
		this.ajaxMsg("新增失败", MSG_ERR_Resources)
	}
	fmt.Println("自增Id(num)", num)
	list["id"] = num
	this.ajaxList("新增成功", MSG_OK, 1, list)
	//this.ajaxMsg("新增成功", MSG_OK)
	return
}

//添加备餐
func (this *ReadyController) AddReadyAction() {
	//记得备餐名字不能相同
	fmt.Println("点击备餐按钮")
	//定义
	o := orm.NewOrm()
	list := make(map[string]interface{})
	var ready models.Ready
	json.Unmarshal(this.Ctx.Input.RequestBody, &ready)
	fmt.Println("ready_info:", &ready)
	//获取tid
	tr := new(models.TempReady)
	var temp models.TempReady
	err := o.QueryTable(tr).Filter("Name", ready.Tname).One(&temp)
	if err == orm.ErrMultiRows {
		// 多条的时候报错
		fmt.Printf("Returned Multi Rows Not One")
	}
	if err == orm.ErrNoRows {
		// 没有找到记录
		fmt.Printf("Not row found")
	}
	ready.Tid = temp.Id
	//插入备餐数据库
	num, err := o.Insert(&ready)
	if err != nil {
		log4go.Stdout("新增备餐失败", err.Error())
		this.ajaxMsg("新增失败", MSG_ERR_Resources)
	}
	fmt.Println("自增Id(num)", num)
	//开启定时
	this.StartReadyTask(ready.Time, ready.Date, strconv.FormatInt(num, 10))

	list["id"] = num
	this.ajaxList("新增成功", MSG_OK, 1, list)
	return
}

//获取模板信息
func (this *ReadyController) GetReadyDishData() {
	fmt.Println("获取备份食材信息")
	o := orm.NewOrm()
	var maps []orm.Params
	rd := new(models.ReadyDish)
	query := o.QueryTable(rd)
	id := this.Input().Get("id")
	fmt.Println("id:", id)
	//查询数据库
	num, err := query.Filter("Tid", id).Values(&maps)
	if err != nil {
		log4go.Stdout("获取备份食材失败", err.Error())
		this.ajaxMsg("获取备份食材失败", MSG_ERR_Resources)
	}
	fmt.Println("get readydish reslut num:", num)
	this.ajaxList("获取备份食材成功", 0, num, maps)
	return
}

//定时
func (this *ReadyController) StartReadyTask(times string, date string, tk string) {
	fmt.Println("定时执行")
	//times date
	//去空格
	times = strings.Replace(times, " ", "", -1)
	time_list := strings.Split(times, "-")
	fmt.Println("time_list:", time_list)

	left_time := strings.Split(time_list[0], ":")
	right_time := strings.Split(time_list[1], ":")
	date_list := strings.Split(date, "-")
	fmt.Println("time:", left_time, right_time)

	var t, t1 string
	t = fmt.Sprintf("%s %s %s %s %s *", left_time[2], left_time[1], left_time[0], date_list[2], date_list[1])
	t1 = fmt.Sprintf("%s %s %s %s %s *", right_time[2], right_time[1], right_time[0], date_list[2], date_list[1])
	fmt.Println("t:", t)

	id, err := strconv.ParseInt(tk, 10, 64)
	if err != nil {
		fmt.Println("get id err")
	}
	//ready model
	o := orm.NewOrm()
	var ready models.Ready

	tk1 := toolbox.NewTask("start"+tk, t, func() error {
		fmt.Println("开启任务修改状态", t)
		//		nt := time.Now().Format("2016-01-02 15:04:05")
		ready.Id = id
		ready.Status = "正在点餐"
		num, err := o.Update(&ready, "Status")
		if err != nil {
			fmt.Println("跟新失败")
		}
		fmt.Println("更新成功", num)
		return nil
	})
	tk2 := toolbox.NewTask("stop"+tk, t1, func() error {
		//fmt.Println("tk1")
		fmt.Println("开启任务修改状态", t1)
		ready.Id = id
		ready.Status = "已完成"
		num, err := o.Update(&ready, "Status")
		if err != nil {
			fmt.Println("跟新失败")
		}
		fmt.Println("更新成功", num)
		//删除任务
		toolbox.DeleteTask("start" + tk)
		toolbox.DeleteTask("stop" + tk)
		return nil
	})
	toolbox.AddTask("start"+tk, tk1)
	toolbox.AddTask("stop"+tk, tk2)
	toolbox.StartTask()

}
