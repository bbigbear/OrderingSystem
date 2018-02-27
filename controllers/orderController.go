package controllers

type OrderController struct {
	BaseController
}

func (this *OrderController) Get() {

	this.TplName = "student_index.tpl"
}

func (this *OrderController) GetOrder() {

	this.TplName = "student_order.tpl"
}
