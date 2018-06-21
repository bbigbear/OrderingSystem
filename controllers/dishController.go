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
)

type DishController struct {
	BaseController
}

func (this *DishController) Get() {
	//获取id
	id := this.Input().Get("id")
	fmt.Println("id:", id)
	this.Data["id"] = id

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
	num, err := o.QueryTable(dishtype).Filter("Rid", id).Values(&maps)
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
	//rid
	rid := this.Input().Get("rid")
	fmt.Println("rid:", rid)
	this.Data["rid"] = rid
	//菜品类型获取
	var maps_dt []orm.Params
	dishtype := new(models.DishType)
	num1, err := o.QueryTable(dishtype).Filter("Rid", rid).Values(&maps_dt)
	if err != nil {
		log4go.Stdout("获取菜品种类失败", err.Error())
		this.ajaxMsg("获取菜品总类失败", MSG_ERR_Resources)
	}
	fmt.Println("get dishType result num:", num1)
	fmt.Println("get dishType result maps_dt:", maps_dt)
	this.Data["map_dt"] = maps_dt

	num, err := o.QueryTable(dish).Filter("Id", id).Values(&maps)
	if err != nil {
		log4go.Stdout("编辑菜品失败", err.Error())
		this.ajaxMsg("编辑失败", MSG_ERR_Resources)
	}
	fmt.Println("edit dish reslut num:", num)
	this.Data["dish_info"] = maps
	for _, m := range maps {
		this.Data["id"] = m["Id"]
		this.Data["p"] = m["Price"]
		this.Data["n"] = m["Name"]
		this.Data["rn"] = m["Rname"]
		this.Data["t"] = m["DishType"]
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
	query := o.QueryTable(dish)
	filters := make([]interface{}, 0)
	id := this.Input().Get("id")
	fmt.Println("id:", id)
	//获取菜品类型
	dt := this.Input().Get("dt")
	if dt != "" {
		filters = append(filters, "DishType", dt)
	}
	fmt.Println("get dishtype:", dt)
	if len(filters) > 0 {
		l := len(filters)
		for k := 0; k < l; k += 2 {
			query = query.Filter(filters[k].(string), filters[k+1])
		}
	}
	//查询数据库
	num, err := query.Filter("Rid", id).Values(&maps)
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

//批量删除
func (this *DishController) DelMultiData() {
	fmt.Println("删除菜品数据")
	o := orm.NewOrm()
	dish := new(models.Dish)
	//list := make(map[string]interface{})
	id := this.Input().Get("id")
	fmt.Println("del id:", id)
	idList := strings.Split(id, ",")
	fmt.Println("idList:", idList)
	id_len := len(idList) - 1
	var idIntList []int64
	for i := 0; i < id_len; i++ {
		idd, err := strconv.ParseInt(idList[i], 10, 64)
		if err != nil {
			log4go.Stdout("delmulti string转int 失败", err.Error())
		}
		idIntList = append(idIntList, idd)
	}
	fmt.Println("idIntList:", idIntList)
	num, err := o.QueryTable(dish).Filter("Id__in", idIntList).Delete()
	if err != nil {
		log4go.Stdout("删除菜品失败", err.Error())
		this.ajaxMsg("删除菜品失败", MSG_ERR_Resources)
	}
	fmt.Println("del multidish reslut num:", num)
	if num == 0 {
		this.ajaxMsg("删除菜品失败", MSG_ERR_Param)
	}
	//list["data"] = maps
	this.ajaxMsg("删除菜品成功", MSG_OK)
	return
}
