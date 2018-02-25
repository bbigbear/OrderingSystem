package controllers

type RestaurantController struct {
	BaseController
}

func (this *RestaurantController) Get() {

	this.TplName = "restaurant.tpl"
}
