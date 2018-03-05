package controllers

import (
	"OrderingSystem/models"
	"encoding/json"
	"fmt"
	"strings"

	_ "github.com/Go-SQL-Driver/MySQL"
	"github.com/alecthomas/log4go"
	"github.com/astaxie/beego/orm"
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
	fmt.Println("del canteen reslut num:", num)
	//list["data"] = maps
	this.Data["time"] = maps

	this.TplName = "restaurant_ready.tpl"
}

//模板
func (this *ReadyController) AddTemp() {
	//获取id
	id := this.Input().Get("id")
	fmt.Println("id:", id)
	this.Data["id"] = id
	//获取菜单类型
	o := orm.NewOrm()
	var maps_mt []orm.Params
	mt := new(models.MenuType)
	num1, err := o.QueryTable(mt).Filter("Rid", id).Values(&maps_mt)
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
	num, err := o.QueryTable(rd).Values(&maps_rd)
	if err != nil {
		log4go.Stdout("获取菜品失败", err.Error())
		this.ajaxMsg("获取菜品失败", MSG_ERR_Resources)
	}
	fmt.Println("get readydish reslut num:", num)
	this.Data["rd_info"] = maps_rd
	fmt.Println("rd_info:", maps_rd)

	this.TplName = "restaurant_addtemp.tpl"
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

	//rd := new(models.ReadyDish)
	//list := make(map[string]interface{})
	dname := this.Input().Get("dname")
	fmt.Println("add dname:", dname)
	nameList := strings.Split(dname, ",")
	fmt.Println("nameList:", nameList)
	name_len := len(nameList) - 1
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
		rd := new(models.ReadyDish)
		var rd_info models.ReadyDish
		rd_info.Dname = nameList[i]
		rd_info.Number = number
		rd_info.Mname = mname
		//查询是否重复
		count, err := o.QueryTable(rd).Filter("Dname", nameList[i]).Filter("Mname", mname).Count()
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
