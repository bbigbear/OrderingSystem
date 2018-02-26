package controllers

type ReadyController struct {
	BaseController
}

func (this *ReadyController) Get() {

	this.TplName = "restaurant_ready.tpl"
}
