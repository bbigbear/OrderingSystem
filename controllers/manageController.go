package controllers

import (
	"OrderingSystem/models"
	"encoding/json"
	"fmt"

	_ "github.com/Go-SQL-Driver/MySQL"
	"github.com/alecthomas/log4go"
	"github.com/astaxie/beego/orm"
)

type ManageController struct {
	BaseController
}

//加载管理界面
func (this *ManageController) Get() {

	this.TplName = "restaurant_manage.tpl"
}

//新建菜品类型
func (this *ManageController) AddDishType() {

	this.TplName = "restaurant_manage.tpl"
}

func (this *ManageController) AddDishTypeAction() {

	fmt.Println("点击添加菜品类型按钮")
	o := orm.NewOrm()
	list := make(map[string]interface{})
	var dt_info models.DishType
	json.Unmarshal(this.Ctx.Input.RequestBody, &dt_info)
	fmt.Println("dt_info:", &dt_info)

	//插入数据库
	num, err := o.Insert(&dt_info)
	if err != nil {
		log4go.Stdout("新增菜品类型失败")
		this.ajaxMsg("新增失败", MSG_ERR_Resources)
	}
	fmt.Println("自增Id(num)", num)
	list["id"] = num
	this.ajaxList("新增成功", MSG_OK, 1, list)
	//this.ajaxMsg("新增成功", MSG_OK)
	return
}

func (this *ManageController) DelDishType() {

	fmt.Println("点击删除菜品类型按钮")
	//获取id
	id, err := this.GetInt("id")
	if err != nil {
		log4go.Stdout("获取id失败", err.Error())
		this.ajaxMsg("获取菜品类型id失败", MSG_ERR_Param)
	}
	fmt.Println("删除食堂id:", id)
	o := orm.NewOrm()
	dt := new(models.DishType)
	num, err := o.QueryTable(dt).Filter("Id", id).Delete()
	if err != nil {
		log4go.Stdout("删除菜品类型失败", err.Error())
		this.ajaxMsg("删除菜品类型失败", MSG_ERR_Resources)
	}
	fmt.Println("del canteen reslut num:", num)
	//list["data"] = maps
	this.ajaxMsg("删除菜品类型成功", MSG_OK)
	return
}

//新建菜单类型
func (this *ManageController) AddMenuType() {

	this.TplName = "restaurant_manage.tpl"
}

func (this *ManageController) AddMenuTypeAction() {

	fmt.Println("点击添加菜单类型按钮")
	o := orm.NewOrm()
	list := make(map[string]interface{})
	var mt_info models.MenuType
	json.Unmarshal(this.Ctx.Input.RequestBody, &mt_info)
	fmt.Println("mt_info:", &mt_info)

	//插入数据库
	num, err := o.Insert(&mt_info)
	if err != nil {
		log4go.Stdout("新增菜单类型失败")
		this.ajaxMsg("新增失败", MSG_ERR_Resources)
	}
	fmt.Println("自增Id(num)", num)
	list["id"] = num
	this.ajaxList("新增成功", MSG_OK, 1, list)
	//this.ajaxMsg("新增成功", MSG_OK)
	return
}

func (this *ManageController) DelMenuType() {

	fmt.Println("点击删除菜单类型按钮")
	//获取id
	id, err := this.GetInt("id")
	if err != nil {
		log4go.Stdout("获取菜单类型id失败", err.Error())
		this.ajaxMsg("获取菜单类型id失败", MSG_ERR_Param)
	}
	fmt.Println("删除菜单类型id:", id)
	o := orm.NewOrm()
	mt := new(models.MenuType)
	num, err := o.QueryTable(mt).Filter("Id", id).Delete()
	if err != nil {
		log4go.Stdout("删除菜单类型失败", err.Error())
		this.ajaxMsg("删除菜单类型失败", MSG_ERR_Resources)
	}
	fmt.Println("del canteen reslut num:", num)
	//list["data"] = maps
	this.ajaxMsg("删除菜单类型成功", MSG_OK)
	return
}

//获取时间区间
func (this *ManageController) GetTimeInterval() {
	fmt.Println("获取时间类型")
	//获取id
	id, err := this.GetInt("id")
	if err != nil {
		log4go.Stdout("获取餐厅id失败", err.Error())
		this.ajaxMsg("获取餐厅id失败", MSG_ERR_Param)
	}
	fmt.Println("餐厅id:", id)
	o := orm.NewOrm()
	var maps []orm.Params
	timeInterval := new(models.TimeInterval)
	num, err := o.QueryTable(timeInterval).Filter("Id", id).Values(&maps)
	if err != nil {
		log4go.Stdout("获取时间类型失败", err.Error())
		this.ajaxMsg("获取时间类型失败", MSG_ERR_Resources)
	}
	fmt.Println("del canteen reslut num:", num)
	//list["data"] = maps
	this.Data["time_info"] = maps
	this.TplName = "restaurant_manage.tpl"

}
