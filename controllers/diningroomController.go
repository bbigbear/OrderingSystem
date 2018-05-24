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

	//校区
	c := new(models.Campus)
	var maps_campus []orm.Params
	num1, err := o.QueryTable(c).Values(&maps_campus)
	if err != nil {
		log4go.Stdout("获取食堂失败", err.Error())
		this.ajaxMsg("获取食堂失败", MSG_ERR_Resources)
	}
	fmt.Println("get campus reslut num:", num1)
	this.Data["campus_info"] = maps_campus

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
	//num, err := o.QueryTable(canteen).Filter("CampusName", campus).Values(&maps)
	num, err := o.QueryTable(canteen).Values(&maps)
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
	if diningroom.Phone == "" {
		this.ajaxMsg("手机号不能为空", MSG_ERR_Resources)
	}
	isExist := o.QueryTable(diningroom).Filter("Phone", diningroom.Phone).Exist()
	if isExist {
		this.ajaxMsg("该手机号已存在", MSG_ERR_Resources)
	}
	diningroom.Pwd = "123456"
	diningroom.Rid = this.GetRandomString(6)
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
		this.Data["phone"] = m["Phone"]
	}
	//查询食堂数据库
	canteen := new(models.Canteen)
	c_num, err := o.QueryTable(canteen).Values(&maps)
	if err != nil {
		log4go.Stdout("获取食堂失败", err.Error())
		this.ajaxMsg("获取食堂失败", MSG_ERR_Resources)
	}
	fmt.Println("get canteen reslut num:", c_num)
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

	this.TplName = "edit_diningroom.tpl"
}

func (this *DiningRoomController) EditRoomAction() {
	fmt.Println("点击更新餐厅按钮")
	//定义
	o := orm.NewOrm()
	//list := make(map[string]interface{})
	var diningroom models.DiningRoom
	var diningroom1 models.DiningRoom
	//	dr:=new(models.DiningRoom)
	json.Unmarshal(this.Ctx.Input.RequestBody, &diningroom)
	fmt.Println("diningroom_info:", &diningroom)

	//先查询再更新
	dr := new(models.DiningRoom)
	err := o.QueryTable(dr).Filter("Id", diningroom.Id).One(&diningroom1)
	if err != nil {
		fmt.Println("err!")
	}
	//获取经营时间类型
	diningroom1.Id = diningroom.Id
	diningroom1.CampusName = diningroom.CampusName
	diningroom1.CanteenName = diningroom.CanteenName
	diningroom1.Detail = diningroom.Detail
	diningroom1.Name = diningroom.Name
	diningroom1.Phone = diningroom.Phone
	diningroom1.RoomPicPath = diningroom.RoomPicPath
	diningroom1.Time = diningroom.Time
	fmt.Println("diningroom1_info:", &diningroom1)
	num, err := o.Update(&diningroom1)
	if err != nil {
		fmt.Println("err!")
	}
	if num == 0 {
		this.ajaxMsg("更新失败", MSG_ERR_Resources)
	}

	//获取时段类型，存储到timeInterval

	Rid := diningroom.Id
	ti := new(models.TimeInterval)
	exist := o.QueryTable(ti).Filter("Rid", Rid).Exist()
	if exist {
		num, err := o.QueryTable(ti).Filter("Rid", Rid).Delete()
		if err != nil {
			fmt.Println("delet err!")
		}
		fmt.Println("delet num", num)
	}

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
	this.ajaxMsg("更新成功", MSG_OK)
	return
}

func (this *DiningRoomController) GetRoomData() {
	fmt.Println("获取餐厅信息")
	o := orm.NewOrm()
	var maps []orm.Params
	diningroom := new(models.DiningRoom)
	query := o.QueryTable(diningroom)
	filters := make([]interface{}, 0)
	//食堂
	cname := this.Input().Get("cname")
	if cname != "" {
		filters = append(filters, "CampusName", cname)
	}
	fmt.Println("get cname:", cname)
	//餐厅
	rname := this.Input().Get("rname")
	if rname != "" {
		filters = append(filters, "CanteenName", rname)
	}
	fmt.Println("get rname:", rname)
	//状态
	status := this.Input().Get("status")
	if status != "" {
		filters = append(filters, "Status", status)
	}

	if len(filters) > 0 {
		l := len(filters)
		for k := 0; k < l; k += 2 {
			query = query.Filter(filters[k].(string), filters[k+1])
		}
	}

	//查询数据库
	num, err := query.Values(&maps)
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

func (this *DiningRoomController) StopRoom() {
	fmt.Println("点击修改状态餐厅按钮")
	//获取id
	id, err := this.GetInt("id")
	if err != nil {
		log4go.Stdout("修改状态id失败", err.Error())
		this.ajaxMsg("修改状态id失败", MSG_ERR_Param)
	}
	fmt.Println("修改状态id:", id)
	//获取status
	status := this.GetString("status")
	fmt.Println("status is", status)
	o := orm.NewOrm()
	//diningroom := new(models.DiningRoom)
	var d models.DiningRoom
	d.Id = int64(id)

	d.Status = status
	num, err := o.Update(&d, "Status")
	if err != nil {
		log4go.Stdout("修改状态失败", err.Error())
		this.ajaxMsg("修改状态失败", MSG_ERR_Resources)
	}
	if num == 0 {
		this.ajaxMsg("修改状态失败", MSG_ERR_Resources)
	}
	fmt.Println("del canteen reslut num:", num)
	//list["data"] = maps
	this.ajaxMsg("修改状态成功", MSG_OK)
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
