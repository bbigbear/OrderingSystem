package routers

import (
	"OrderingSystem/controllers"

	"github.com/astaxie/beego"
)

func init() {
	beego.Router("/", &controllers.MainController{})
	beego.Router("/v1/canteen", &controllers.CanteenController{})
	beego.Router("/v1/canteen/add", &controllers.CanteenController{}, "*:AddCanteen")
	beego.Router("/v1/dining_room", &controllers.DiningRoomController{})
	beego.Router("/v1/dining_time", &controllers.DiningTimeController{})
	beego.Router("/v1/dining_time/add", &controllers.DiningTimeController{}, "*:AddTime")
}
