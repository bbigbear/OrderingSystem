package routers

import (
	"OrderingSystem/controllers"

	"github.com/astaxie/beego"
)

func init() {
	beego.Router("/", &controllers.MainController{})
	beego.Router("/login", &controllers.LoginController{})
	beego.Router("/login_action", &controllers.LoginController{}, "post:LoginAction")
	//get img
	beego.Router("/v1/put_img", &controllers.BaseController{}, "*:PutFileImg")

	beego.Router("/v1/canteen", &controllers.CanteenController{})
	beego.Router("/v1/canteen/add", &controllers.CanteenController{}, "*:AddCanteen")
	beego.Router("/v1/canteen/add_action", &controllers.CanteenController{}, "post:AddCanteenAction")
	beego.Router("/v1/canteen/del", &controllers.CanteenController{}, "post:DelCanteen")

	beego.Router("/v1/dining_room", &controllers.DiningRoomController{})
	beego.Router("/v1/dining_room/add", &controllers.DiningRoomController{}, "*:AddRoom")
	beego.Router("/v1/dining_room/add_action", &controllers.DiningRoomController{}, "post:AddRoomAction")
	beego.Router("/v1/dining_room/getdata", &controllers.DiningRoomController{}, "*:GetRoomData")
	beego.Router("/v1/dining_room/edit", &controllers.DiningRoomController{}, "*:EditRoom")
	beego.Router("/v1/dining_room/edit_action", &controllers.DiningRoomController{}, "post:EditRoomAction")
	beego.Router("/v1/dining_room/del", &controllers.DiningRoomController{}, "post:DelRoom")
	beego.Router("/v1/dining_room/stop", &controllers.DiningRoomController{}, "post:StopRoom")
	beego.Router("/v1/dining_room/getroom", &controllers.DiningRoomController{}, "post:GetRoom")

	beego.Router("/v1/dining_time", &controllers.DiningTimeController{})
	beego.Router("/v1/dining_time/add", &controllers.DiningTimeController{}, "*:AddTime")
	beego.Router("/v1/dining_time/add_action", &controllers.DiningTimeController{}, "post:AddTimeAction")
	beego.Router("/v1/dining_time/getdata", &controllers.DiningTimeController{}, "*:GetTimeData")
	beego.Router("/v1/dining_time/del", &controllers.DiningTimeController{}, "post:DelTime")

	beego.Router("/v1/restaurant_dish", &controllers.DishController{})
	beego.Router("/v1/restaurant_dish/add", &controllers.DishController{}, "*:AddDish")
	beego.Router("/v1/restaurant_dish/add_action", &controllers.DishController{}, "post:AddDishAction")
	beego.Router("/v1/restaurant_dish/getdata", &controllers.DishController{}, "*:GetDishData")
	beego.Router("/v1/restaurant_dish/edit", &controllers.DishController{}, "*:EditDish")
	beego.Router("/v1/restaurant_dish/edit_action", &controllers.DishController{}, "post:EditDishAction")
	beego.Router("/v1/restaurant_dish/del", &controllers.DishController{}, "post:DelDish")
	beego.Router("/v1/restaurant_dish/delmulti", &controllers.DishController{}, "post:DelMultiData")

	beego.Router("/v1/restaurant_manage", &controllers.ManageController{})
	beego.Router("/v1/restaurant_manage/adddishtype", &controllers.ManageController{}, "*:AddDishType")
	beego.Router("/v1/restaurant_manage/adddishtype_action", &controllers.ManageController{}, "post:AddDishTypeAction")
	beego.Router("/v1/restaurant_manage/deldishtype", &controllers.ManageController{}, "post:DelDishType")
	beego.Router("/v1/restaurant_manage/addmenutype", &controllers.ManageController{}, "*:AddMenuType")
	beego.Router("/v1/restaurant_manage/addmenutype_action", &controllers.ManageController{}, "post:AddMenuTypeAction")
	beego.Router("/v1/restaurant_manage/delmenutype", &controllers.ManageController{}, "post:DelMenuType")
	beego.Router("/v1/restaurant_manage/gettimedata", &controllers.ManageController{}, "*:GetTimeInterval")
	beego.Router("/v1/restaurant_manage/edittime", &controllers.ManageController{}, "*:EditTimeInterval")
	beego.Router("/v1/restaurant_manage/edittime_action", &controllers.ManageController{}, "post:EditTimeIntervalAction")

	beego.Router("/v1/restaurant_ready", &controllers.ReadyController{})
	beego.Router("/v1/restaurant_ready/del", &controllers.ReadyController{}, "post:DelReady")
	beego.Router("/v1/restaurant_ready/getorder", &controllers.ReadyController{}, "*:GetOrder")
	beego.Router("/v1/restaurant_ready/getorder_action", &controllers.ReadyController{}, "*:GetOrderAction")
	beego.Router("/v1/restaurant_ready/addtempready", &controllers.ReadyController{}, "*:AddTempReady")
	beego.Router("/v1/restaurant_ready/addtempready_action", &controllers.ReadyController{}, "post:AddTempReadyAction")
	beego.Router("/v1/restaurant_ready/gettempdata", &controllers.ReadyController{}, "*:GetTempData")
	beego.Router("/v1/restaurant_ready/deltemp", &controllers.ReadyController{}, "*:DelTemp")
	beego.Router("/v1/restaurant_ready/edittemp", &controllers.ReadyController{}, "*:EditTemp")
	beego.Router("/v1/restaurant_ready/addreadydish", &controllers.ReadyController{}, "*:AddReadyDish")
	beego.Router("/v1/restaurant_ready/AddMultiReadyDish", &controllers.ReadyController{}, "*:AddMultiReadyDish")
	beego.Router("/v1/restaurant_ready/addready_action", &controllers.ReadyController{}, "post:AddReadyAction")
	beego.Router("/v1/restaurant_ready/getreadydishdata", &controllers.ReadyController{}, "*:GetReadyDishData")

	beego.Router("/v1/student_index", &controllers.OrderController{})
	beego.Router("/v1/student_index/getroomdetail", &controllers.OrderController{}, "*:GetRoomDetail")
	beego.Router("/v1/student_order", &controllers.OrderController{}, "*:GetOrder")
	beego.Router("/v1/student_order/getdata", &controllers.OrderController{}, "*:GetOrderData")
	beego.Router("/v1/student_ordersure", &controllers.OrderController{}, "*:SureOrder")
	beego.Router("/v1/student_addorder", &controllers.OrderController{}, "post:AddOrder")
	beego.Router("/v1/student_orderdetail", &controllers.OrderController{}, "*:GetOrderDetail")
	beego.Router("/v1/student_orderdetail/getlist", &controllers.OrderController{}, "*:GetOrderList")

}
