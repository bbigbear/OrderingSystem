package controllers

type ManageController struct {
	BaseController
}

func (this *ManageController) Get() {

	this.TplName = "restaurant_manage.tpl"
}
