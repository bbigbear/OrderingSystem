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

type DiningRoomController struct {
	BaseController
}

func (this *DiningRoomController) Get() {
	o := orm.NewOrm()
	var maps []orm.Params
	canteen := new(models.Canteen)
	//获取campus
	campus := this.Input().Get("campus")
	if campus == "" {
		campus = "雁塔校区"
	}
	fmt.Println("campus:", campus)
	this.Data["campus"] = campus
	//查询数据库
	num, err := o.QueryTable(canteen).Filter("CampusName", campus).Values(&maps)
	if err != nil {
		log4go.Stdout("获取食堂失败", err.Error())
		this.ajaxMsg("获取食堂失败", MSG_ERR_Resources)
	}
	fmt.Println("get canteen reslut num:", num)
	this.Data["canteen_info"] = maps

	this.TplName = "dining_room.tpl"
}

func (this *DiningRoomController) AddRoom() {
	o := orm.NewOrm()
	var maps []orm.Params
	canteen := new(models.Canteen)
	//获取campus
	campus := this.Input().Get("campus")
	if campus == "" {
		campus = "雁塔校区"
	}
	fmt.Println("campus:", campus)
	//this.Data["campus"] = campus
	//查询食堂数据库
	num, err := o.QueryTable(canteen).Filter("CampusName", campus).Values(&maps)
	if err != nil {
		log4go.Stdout("获取食堂失败", err.Error())
		this.ajaxMsg("获取食堂失败", MSG_ERR_Resources)
	}
	fmt.Println("get canteen reslut num:", num)
	this.Data["canteen_info"] = maps
	//查询时段数据库
	var timemaps []orm.Params
	diningtime := new(models.DiningTime)

	num, err1 := o.QueryTable(diningtime).Values(&timemaps)
	if err1 != nil {
		log4go.Stdout("获取时段失败", err.Error())
		this.ajaxMsg("获取时段失败", MSG_ERR_Resources)
	}
	fmt.Println("get diningtime reslut num:", num)
	this.Data["time_info"] = timemaps

	this.TplName = "add_diningroom.tpl"
}

func (this *DiningRoomController) AddRoomAction() {
	fmt.Println("点击新增餐厅按钮")
	//定义
	o := orm.NewOrm()
	list := make(map[string]interface{})
	var diningroom models.DiningRoom
	json.Unmarshal(this.Ctx.Input.RequestBody, &diningroom)
	fmt.Println("diningroom_info:", &diningroom)
	//插入餐厅数据库
	num, err := o.Insert(&diningroom)
	if err != nil {
		log4go.Stdout("新增餐厅失败", err.Error())
		this.ajaxMsg("新增失败", MSG_ERR_Resources)
	}
	fmt.Println("自增Id(num)", num)
	//获取时段类型，存储到timeInterval

	Rid := diningroom.Id
	time := diningroom.Time
	timeList := strings.Split(time, ",")
	time_count := len(timeList) - 1
	for i := 0; i < time_count; i++ {
		//insert
		var ti models.TimeInterval
		var dt models.DiningTime
		diningtime := new(models.DiningTime)
		ti.Rid = Rid
		ti.Name = timeList[i]

		//先查询
		err := o.QueryTable(diningtime).Filter("Type", timeList[i]).One(&dt)
		if err != nil {
			log4go.Stdout("新增时段失败", err.Error())
			this.ajaxMsg("新增时段失败", MSG_ERR_Resources)
		}
		ti.Time = dt.Time

		num, err := o.Insert(&ti)
		if err != nil {
			log4go.Stdout("新增时段失败", err.Error())
			this.ajaxMsg("新增时段失败", MSG_ERR_Resources)
		}
		fmt.Println("新增时段Id(num)", num)
	}

	list["id"] = num
	this.ajaxList("新增成功", MSG_OK, 1, list)
	return
}

func (this *DiningRoomController) EditRoom() {
	o := orm.NewOrm()
	var maps []orm.Params
	diningroom := new(models.DiningRoom)

	id := this.Input().Get("id")
	fmt.Println("id:", id)

	num, err := o.QueryTable(diningroom).Filter("Id", id).Values(&maps)
	if err != nil {
		log4go.Stdout("编辑餐厅失败", err.Error())
		this.ajaxMsg("编辑失败", MSG_ERR_Resources)
	}
	fmt.Println("edit room reslut num:", num)
	this.Data["room_info"] = maps
	for _, m := range maps {
		this.Data["id"] = m["Id"]
		this.Data["n"] = m["Name"]
		this.Data["cn"] = m["CanteenName"]
		this.Data["t"] = m["Time"]
		this.Data["d"] = m["Detail"]
		this.Data["bp"] = m["BusinessPicPath"]
		this.Data["rp"] = m["RoomPicPath"]
		this.Data["s"] = m["Status"]
	}
	this.TplName = "edit_diningroom.tpl"
}

func (this *DiningRoomController) EditRoomAction() {
	fmt.Println("点击新增餐厅按钮")
	//定义
	o := orm.NewOrm()
	list := make(map[string]interface{})
	var diningroom models.DiningRoom
	json.Unmarshal(this.Ctx.Input.RequestBody, &diningroom)
	fmt.Println("diningroom_info:", &diningroom)
	//插入餐厅数据库
	num, err := o.Insert(&diningroom)
	if err != nil {
		log4go.Stdout("新增餐厅失败", err.Error())
		this.ajaxMsg("新增失败", MSG_ERR_Resources)
	}
	fmt.Println("自增Id(num)", num)

	list["id"] = num
	this.ajaxList("新增成功", MSG_OK, 1, list)
	return
}

func (this *DiningRoomController) GetRoomData() {
	fmt.Println("获取餐厅信息")
	o := orm.NewOrm()
	var maps []orm.Params
	diningroom := new(models.DiningRoom)

	//查询数据库
	num, err := o.QueryTable(diningroom).Values(&maps)
	if err != nil {
		log4go.Stdout("获取餐厅失败", err.Error())
		this.ajaxMsg("获取餐厅失败", MSG_ERR_Resources)
	}
	fmt.Println("get diningroom reslut num:", num)
	this.ajaxList("获取餐厅成功", 0, num, maps)
	return
}

func (this *DiningRoomController) DelRoom() {
	fmt.Println("点击删除餐厅按钮")
	//获取id
	id, err := this.GetInt("id")
	if err != nil {
		log4go.Stdout("删除餐厅id失败", err.Error())
		this.ajaxMsg("删除餐厅id失败", MSG_ERR_Param)
	}
	fmt.Println("删除餐厅id:", id)
	o := orm.NewOrm()
	diningroom := new(models.DiningRoom)
	num, err := o.QueryTable(diningroom).Filter("Id", id).Delete()
	if err != nil {
		log4go.Stdout("删除餐厅失败", err.Error())
		this.ajaxMsg("删除餐厅失败", MSG_ERR_Resources)
	}
	fmt.Println("del canteen reslut num:", num)
	//list["data"] = maps
	this.ajaxMsg("删除餐厅成功", MSG_OK)
	//补充删除联级下的数据，以免出现垃圾数据

	return
}

func (this *DiningRoomController) GetRoom() {
	fmt.Println("获取餐厅信息")
	o := orm.NewOrm()
	diningroom := new(models.DiningRoom)

	id := this.Input().Get("id")
	fmt.Println("id:", id)

	//查询数据库
	exist := o.QueryTable(diningroom).Filter("Id", id).Exist()
	if exist {
		this.ajaxMsg("获取餐厅成功", MSG_OK)
	} else {
		this.ajaxMsg("不存在该餐厅", MSG_ERR_Resources)
	}

	return
}

//新建供应时段
func (this *DiningRoomController) AddTimeAction() {
	fmt.Println("点击新增时段按钮")
	//定义
	o := orm.NewOrm()
	list := make(map[string]interface{})
	var timeInterval models.TimeInterval
	json.Unmarshal(this.Ctx.Input.RequestBody, &timeInterval)
	fmt.Println("timeInterval_info:", &timeInterval)
	//插入时段数据库
	num, err := o.Insert(&timeInterval)
	if err != nil {
		log4go.Stdout("新增时段失败", err.Error())
		this.ajaxMsg("新增失败", MSG_ERR_Resources)
	}
	fmt.Println("自增Id(num)", num)

	list["id"] = num
	this.ajaxList("新增成功", MSG_OK, 1, list)
	return
}
