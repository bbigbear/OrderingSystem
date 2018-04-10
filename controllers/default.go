package controllers

import (
	//"fmt"

	"github.com/astaxie/beego"
)

type MainController struct {
	beego.Controller
}

func (c *MainController) Get() {
	//websocket.Handler(Echo)
	c.TplName = "login.tpl"
	//	c.TplName = "dining_room.tpl"
	//	c.TplName = "dining_time.tpl"

}
