package controllers

import (
	"OrderingSystem/models"
	"fmt"

	_ "github.com/Go-SQL-Driver/MySQL"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/httplib"
	"github.com/astaxie/beego/orm"
	"github.com/tidwall/gjson"
)

type LoginController struct {
	BaseController
}

func (this *LoginController) Get() {

	//this.StartNotificationTask()
	//this.TplName = "index.tpl"
	skey := this.GetString("session")
	if skey != "" {
		fmt.Println("单点登录")
		n := this.SessionLogin(skey)
		fmt.Println("n:", n)
		if n == 1 {
			fmt.Println("进入首页")
			this.Redirect("/v1/canteen", 302)
		}
	}
	this.TplName = "login.tpl"
}

func (this *LoginController) LoginAction() {
	fmt.Println("点击登录按钮")

	list := make(map[string]interface{})
	role := this.Input().Get("role")
	uname := this.Input().Get("inputAccount")
	pwd := this.Input().Get("inputPassword")
	fmt.Println(role)
	if role == "school" {
		//		if beego.AppConfig.String("uname") == uname &&
		//			beego.AppConfig.String("pwd") == pwd {
		fmt.Println("登录成功")
		//this.SetSession("islogin", 1)
		token := beego.AppConfig.String("token")
		url := beego.AppConfig.String("login_url")
		req := httplib.Post(url)
		req.Header("Content-Type", "application/json")
		req.Header("token", token)
		req.Header("system", "perm")

		login := make(map[string]interface{})
		login["username"] = uname
		login["password"] = pwd
		req.JSONBody(login)

		str, err := req.String()
		if err != nil {
			fmt.Println("err", err.Error())
		}
		fmt.Println("str", str)
		code := gjson.Get(str, "code")
		if code.Exists() {
			this.ajaxMsg("账号密码错误", MSG_ERR_Param)
		} else {
			var login_info models.Login
			err := req.ToJSON(&login_info)
			if err != nil {
				fmt.Println(err)
				this.ajaxMsg("err to json", MSG_ERR)
			}
			fmt.Println(login_info.ReadName)
			if login_info.ReadName == "管理员" {
				//存session
				//this.SetSession("islogin", 1)
				this.ajaxMsg("登录成功", MSG_OK)
			} else {
				this.ajaxMsg("你无权登录", MSG_ERR_Verified)
			}
		}

		//		} else {
		//			fmt.Println("账户密码错误")
		//			this.ajaxMsg("账户密码错误", MSG_ERR)
		//		}
	} else if role == "room" {
		o := orm.NewOrm()
		r := new(models.DiningRoom)
		var room_info models.DiningRoom
		isExist := o.QueryTable(r).Filter("Phone", uname).Exist()
		if isExist {
			err := o.QueryTable(r).Filter("Phone", uname).One(&room_info)
			if err != nil {
				fmt.Println("err!")
			}
			if room_info.Pwd == pwd {
				list["id"] = room_info.Id
				//存session
				//this.SetSession("islogin", 1)
				this.ajaxList("登录成功", MSG_OK, 1, list)
			} else {
				this.ajaxMsg("密码错误", MSG_ERR)
			}

		} else {
			this.ajaxMsg("不存在该账号", MSG_ERR)
		}

	} else if role == "student" {
		o := orm.NewOrm()
		s := new(models.Student)
		var student_info models.Student
		isExist := o.QueryTable(s).Filter("Name", uname).Exist()
		if isExist {
			err := o.QueryTable(s).Filter("Name", uname).One(&student_info)
			if err != nil {
				fmt.Println("err!")
			}
			if student_info.Pwd == pwd {
				list["id"] = student_info.Sid
				//存session
				//this.SetSession("islogin", 1)
				this.ajaxList("登录成功", MSG_OK, 1, list)
			} else {
				this.ajaxMsg("密码错误", MSG_ERR)
			}
		} else {
			this.ajaxMsg("不存在该账号", MSG_ERR)
		}
	} else {
		this.ajaxMsg("请选择登陆类型", MSG_ERR)
	}

}

func (this *LoginController) Logout() {

	fmt.Println("点击推出按钮")
	this.DelSession("islogin")
	this.TplName = "login.tpl"

}
