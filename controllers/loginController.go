package controllers

import (
	"OrderingSystem/models"
	"fmt"

	"github.com/astaxie/beego"
	"ogithub.com/astaxie/beego/orm"
	_ "github.com/Go-SQL-Driver/MySQL"
)

type LoginController struct {
	BaseController
}

func (this *LoginController) Get() {

	//this.StartNotificationTask()
	//this.TplName = "index.tpl"
	this.TplName = "login.tpl"
}

func (this *LoginController) LoginAction() {

	fmt.Println("点击登录按钮")
	role := this.Input().Get("role")
	uname := this.Input().Get("inputAccount")
	pwd := this.Input().Get("inputPassword")
	if role == "school" {
		if beego.AppConfig.String("uname") == uname &&
			beego.AppConfig.String("pwd") == pwd {
			fmt.Println("登录成功")
			//存session
			//this.SetSession("islogin", 1)
			this.ajaxMsg("登录成功", MSG_OK)
		} else {
			fmt.Println("账户密码错误")
			this.ajaxMsg("账户密码错误", MSG_ERR)
		}
	} else if role == "room" {
		r := new(models.DiningRoom)
		o:=orm.

	} else if role == "student" {

	}

}

func (this *LoginController) Logout() {

	fmt.Println("点击推出按钮")
	this.DelSession("islogin")
	this.TplName = "login.tpl"

}
