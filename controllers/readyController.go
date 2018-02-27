package controllers

import (
	"OrderingSystem/models"
	"encoding/json"
	"fmt"

	_ "github.com/Go-SQL-Driver/MySQL"
	"github.com/alecthomas/log4go"
	"github.com/astaxie/beego/orm"
)

type ReadyController struct {
	BaseController
}

func (this *ReadyController) Get() {

	this.TplName = "restaurant_ready.tpl"
}

//模板
func (this *ReadyController) AddTemp() {

	this.TplName = "restaurant_ready.tpl"
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

	this.TplName = "restaurant_ready.tpl"
}

func (this *ReadyController) AddReadyDishAction() {
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
