package controllers

type DiningRoomController struct {
	BaseController
}

func (this *DiningRoomController) Get() {
	this.TplName = "dining_room.tpl"
}
