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

type ManageController struct {
	BaseController
}

//加载管理界面
func (this *ManageController) Get() {
	if this.GetSession("islogin") != 1 {
		fmt.Println("未登录")
		this.Redirect("/v1/login", 302)
	}
	//获取name
	id := this.Input().Get("id")
	fmt.Println("id:", id)
	this.Data["id"] = id

	//获取菜品库类型
	//查询数据库
	o := orm.NewOrm()
	var maps []orm.Params
	dt := new(models.DishType)
	num, err := o.QueryTable(dt).Filter("Rid", id).Values(&maps)
	if err != nil {
		log4go.Stdout("获取菜品类型失败", err.Error())
		this.ajaxMsg("获取菜品类型失败", MSG_ERR_Resources)
	}
	fmt.Println("get dishtype reslut num:", num)
	this.Data["dt_info"] = maps
	//获取菜单类型
	var maps_mt []orm.Params
	mt := new(models.MenuType)
	num1, err := o.QueryTable(mt).Filter("Rid", id).Values(&maps_mt)
	if err != nil {
		log4go.Stdout("获取菜单类型失败", err.Error())
		this.ajaxMsg("获取菜单类型失败", MSG_ERR_Resources)
	}
	fmt.Println("get menutype reslut num:", num1)
	this.Data["mt_info"] = maps_mt
	//获取窗口信息
	var maps_room models.DiningRoom
	room := new(models.DiningRoom)
	err1 := o.QueryTable(room).One(&maps_room)
	if err1 != nil {
		fmt.Println("get room detail err!")
	}
	this.Data["mid"] = maps_room.Id
	this.Data["n"] = maps_room.Name
	this.Data["cn"] = maps_room.CanteenName
	this.Data["t"] = maps_room.Time
	this.Data["d"] = maps_room.Detail
	this.Data["bp"] = maps_room.BusinessPicPath
	this.Data["rp"] = maps_room.RoomPicPath
	this.Data["s"] = maps_room.Status
	this.Data["phone"] = maps_room.Phone
	this.Data["cam"] = maps_room.CampusName
	//this.Data["room_pic"] = maps_room.RoomPicPath
	//this.Data["detail"] = maps_room.Detail
	this.TplName = "restaurant_manage.tpl"
}

//新建菜品类型
func (this *ManageController) AddDishType() {
	if this.GetSession("islogin") != 1 {
		fmt.Println("未登录")
		this.Redirect("/v1/login", 302)
	}
	//获取rid
	id := this.Input().Get("id")
	fmt.Println("id:", id)
	this.Data["id"] = id

	this.TplName = "restaurant_adddishtype.tpl"
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
	if this.GetSession("islogin") != 1 {
		fmt.Println("未登录")
		this.Redirect("/v1/login", 302)
	}
	//获取rid
	id := this.Input().Get("id")
	fmt.Println("id:", id)
	this.Data["id"] = id

	this.TplName = "restaurant_addmenutype.tpl"
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
	num, err := o.QueryTable(timeInterval).Filter("Rid", id).Values(&maps)
	if err != nil {
		log4go.Stdout("获取时间类型失败", err.Error())
		this.ajaxMsg("获取时间类型失败", MSG_ERR_Resources)
	}
	fmt.Println("del canteen reslut num:", num)

	//list["data"] = maps
	//this.Data["time_info"] = maps
	//	this.TplName = "restaurant_manage.tpl"
	this.ajaxList("获取菜品成功", 0, num, maps)
	return

}

//
func (this *ManageController) EditTimeInterval() {
	if this.GetSession("islogin") != 1 {
		fmt.Println("未登录")
		this.Redirect("/v1/login", 302)
	}
	//获取name
	id := this.Input().Get("id")
	fmt.Println("id:", id)
	this.Data["id"] = id

	//获取timeinterid
	o := orm.NewOrm()
	ti := new(models.TimeInterval)
	var ti_info models.TimeInterval
	err := o.QueryTable(ti).Filter("Id", id).One(&ti_info)
	if err != nil {
		fmt.Println("err")
	}
	//获取时间

	dt := new(models.DiningTime)
	var dtinfo models.DiningTime
	err1 := o.QueryTable(dt).Filter("Type", ti_info.Name).One(&dtinfo)
	if err1 != nil {
		fmt.Println("err1!")
	}
	times := strings.Replace(dtinfo.Time, " ", "", -1)
	time_list := strings.Split(times, "-")
	fmt.Println("time_list:", time_list)
	this.Data["time1"] = time_list[0]
	this.Data["time2"] = time_list[1]

	this.TplName = "restaurant_edittime.tpl"
}

func (this *ManageController) EditTimeIntervalAction() {
	fmt.Println("点击更新时段按钮")
	o := orm.NewOrm()
	var time_info models.TimeInterval
	json.Unmarshal(this.Ctx.Input.RequestBody, &time_info)
	fmt.Println("time_info:", &time_info)

	//更新数据库,只更新time
	num, err := o.Update(&time_info, "Time")
	fmt.Println("updata time reslut num:", num)
	if err != nil {
		log4go.Stdout("更新时段失败")
		this.ajaxMsg("更新失败", MSG_ERR_Resources)
	}
	if num == 0 {
		this.ajaxMsg("更新失败", MSG_ERR_Param)
	}
	this.ajaxMsg("修改成功", MSG_OK)
	return
}
