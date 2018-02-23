package controllers

import (
	"github.com/astaxie/beego"
)

type MainController struct {
	beego.Controller
}

func (c *MainController) Get() {
	c.TplName = "index.tpl"
	//	c.TplName = "dining_room.tpl"
	//	c.TplName = "dining_time.tpl"
}
