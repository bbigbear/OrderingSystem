package routers

import (
	"OrderingSystem/controllers"

	"github.com/astaxie/beego"
)

func init() {
	beego.Router("/", &controllers.MainController{})
	//get img
	beego.Router("/v1/put_img", &controllers.BaseController{}, "*:PutFileImg")

	beego.Router("/v1/canteen", &controllers.CanteenController{})
	beego.Router("/v1/canteen/add", &controllers.CanteenController{}, "*:AddCanteen")
	beego.Router("/v1/canteen/add_action", &controllers.CanteenController{}, "*:AddCanteenAction")
	beego.Router("/v1/canteen/del", &controllers.CanteenController{}, "*:DelCanteen")

	beego.Router("/v1/dining_room", &controllers.DiningRoomController{})
	beego.Router("/v1/dining_room/add", &controllers.DiningRoomController{}, "*:AddRoom")
	beego.Router("/v1/dining_room/add_action", &controllers.DiningRoomController{}, "*:AddRoomAction")
	beego.Router("/v1/dining_room/getdata", &controllers.DiningRoomController{}, "*:GetRoomData")
	beego.Router("/v1/dining_room/edit", &controllers.DiningRoomController{}, "*:EditRoom")
	beego.Router("/v1/dining_room/del", &controllers.DiningRoomController{}, "*:DelRoom")
	beego.Router("/v1/dining_room/getroom", &controllers.DiningRoomController{}, "*:GetRoom")

	beego.Router("/v1/dining_time", &controllers.DiningTimeController{})
	beego.Router("/v1/dining_time/add", &controllers.DiningTimeController{}, "*:AddTime")
	beego.Router("/v1/dining_time/add_action", &controllers.DiningTimeController{}, "*:AddTimeAction")
	beego.Router("/v1/dining_time/getdata", &controllers.DiningTimeController{}, "*:GetTimeData")
	beego.Router("/v1/dining_time/del", &controllers.DiningTimeController{}, "*:DelTime")

	beego.Router("/v1/restaurant_dish", &controllers.DishController{})
	beego.Router("/v1/restaurant_manage", &controllers.ManageController{})
	beego.Router("/v1/restaurant_ready", &controllers.ReadyController{})
}
