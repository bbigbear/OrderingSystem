package controllers

import (
	"fmt"
	//"github.com/astaxie/beego"
)

type MainController struct {
	BaseController
}

func (c *MainController) Get() {
	skey := c.GetString("session")
	if skey != "" {
		fmt.Println("单点登录")
		n := c.SessionLogin(skey)
		fmt.Println("n:", n)
		if n == 1 {
			fmt.Println("进入首页")
			c.Redirect("/", 302)
		}
	}
	//websocket.Handler(Echo)
	c.TplName = "login.tpl"
	//	c.TplName = "dining_room.tpl"
	//	c.TplName = "dining_time.tpl"

}
