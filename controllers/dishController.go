package controllers

import (
	"OrderingSystem/models"
	"encoding/json"
	"fmt"

	_ "github.com/Go-SQL-Driver/MySQL"
	"github.com/alecthomas/log4go"
	"github.com/astaxie/beego/orm"
)

type DishController struct {
	BaseController
}

func (this *DishController) Get() {
	//获取name
	id := this.Input().Get("id")
	fmt.Println("id:", id)
	this.Data["id"] = id

	this.TplName = "restaurant_dish.tpl"
}

func (this *DishController) AddDish() {

	//获取name
	id := this.Input().Get("id")
	fmt.Println("id:", id)

	//种类获取
	o := orm.NewOrm()
	var maps []orm.Params
	dishtype := new(models.DishType)
	num, err := o.QueryTable(dishtype).Filter("Id", id).Values(&maps)
	if err != nil {
		log4go.Stdout("获取菜品种类失败", err.Error())
		this.ajaxMsg("获取菜品总类失败", MSG_ERR_Resources)
	}
	fmt.Println("get dishType result num:", num)
	this.Data["map"] = maps
	this.Data["id"] = id
	this.TplName = "restaurant_adddish.tpl"
}

func (this *DishController) AddDishAction() {
	fmt.Println("点击新增菜品按钮")
	//定义
	o := orm.NewOrm()
	list := make(map[string]interface{})
	var dish models.Dish
	json.Unmarshal(this.Ctx.Input.RequestBody, &dish)
	fmt.Println("dish_info:", &dish)
	//插入餐厅数据库
	num, err := o.Insert(&dish)
	if err != nil {
		log4go.Stdout("新增菜品失败", err.Error())
		this.ajaxMsg("新增失败", MSG_ERR_Resources)
	}
	fmt.Println("自增Id(num)", num)

	list["id"] = num
	this.ajaxList("新增成功", MSG_OK, 1, list)
	return
}

func (this *DishController) EditDish() {
	o := orm.NewOrm()
	var maps []orm.Params
	dish := new(models.Dish)

	id := this.Input().Get("id")
	fmt.Println("id:", id)

	num, err := o.QueryTable(dish).Filter("Id", id).Values(&maps)
	if err != nil {
		log4go.Stdout("编辑菜品失败", err.Error())
		this.ajaxMsg("编辑失败", MSG_ERR_Resources)
	}
	fmt.Println("edit dish reslut num:", num)
	this.Data["dish_info"] = maps
	for _, m := range maps {
		this.Data["id"] = m["Id"]
		this.Data["n"] = m["Name"]
		this.Data["rn"] = m["Rname"]
		this.Data["t"] = m["Type"]
		this.Data["d"] = m["Detail"]
		this.Data["dp"] = m["DishPicPath"]
	}
	this.TplName = "restaurant_editdish.tpl"
}

func (this *DishController) EditDishAction() {
	fmt.Println("更新菜品编辑")
	o := orm.NewOrm()
	var dish_info models.Dish
	json.Unmarshal(this.Ctx.Input.RequestBody, &dish_info)
	fmt.Println("dish_info:", &dish_info)
	num, err := o.Update(&dish_info)
	fmt.Println("updata dish reslut num:", num)
	if err != nil {
		log4go.Stdout("更新菜品失败", err.Error())
		this.ajaxMsg("更新失败", MSG_ERR_Resources)
	}
	if num == 0 {
		this.ajaxMsg("更新失败", MSG_ERR_Param)
	}
	this.ajaxMsg("修改成功", MSG_OK)
	return
}

func (this *DishController) GetDishData() {
	fmt.Println("获取菜品信息")
	o := orm.NewOrm()
	var maps []orm.Params
	dish := new(models.Dish)
	id := this.Input().Get("id")
	fmt.Println("id:", id)
	//查询数据库
	num, err := o.QueryTable(dish).Filter("Id", id).Values(&maps)
	if err != nil {
		log4go.Stdout("获取菜品失败", err.Error())
		this.ajaxMsg("获取菜品失败", MSG_ERR_Resources)
	}
	fmt.Println("get diningroom reslut num:", num)
	this.ajaxList("获取菜品成功", 0, num, maps)
	return
}

func (this *DishController) DelDish() {
	fmt.Println("点击删除菜品按钮")
	//获取id
	id, err := this.GetInt("id")
	if err != nil {
		log4go.Stdout("删除菜品id失败", err.Error())
		this.ajaxMsg("删除菜品id失败", MSG_ERR_Param)
	}
	fmt.Println("删除菜品id:", id)
	o := orm.NewOrm()
	dish := new(models.Dish)
	num, err := o.QueryTable(dish).Filter("Id", id).Delete()
	if err != nil {
		log4go.Stdout("删除菜品失败", err.Error())
		this.ajaxMsg("删除菜品失败", MSG_ERR_Resources)
	}
	fmt.Println("del canteen reslut num:", num)
	//list["data"] = maps
	this.ajaxMsg("删除菜品成功", MSG_OK)
	return
}
