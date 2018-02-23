package controllers

type CanteenController struct {
	BaseController
}

func (this *CanteenController) Get() {
	this.TplName = "canteen.tpl"
}
func (this *CanteenController) AddCanteen() {
	this.TplName = "add_canteen.tpl"
}
