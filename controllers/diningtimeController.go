package controllers

type DiningTimeController struct {
	BaseController
}

func (this *DiningTimeController) Get() {
	this.TplName = "dining_time.tpl"
}

func (this *DiningTimeController) AddTime() {
	this.TplName = "add_diningtime.tpl"
}
