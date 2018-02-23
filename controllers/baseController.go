package controllers

import (
	"MenuPj/models"
	"fmt"
	"log"
	"strconv"
	"time"

	_ "github.com/Go-SQL-Driver/MySQL"
	"github.com/astaxie/beego/orm"

	"github.com/alecthomas/log4go"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/toolbox"
)

const (
	MSG_OK            = 200
	MSG_ERR_Param     = 400
	MSG_ERR_Verified  = 401
	MSG_ERR_Authority = 403
	MSG_ERR_Resources = 404
	MSG_ERR           = 500
)

type BaseController struct {
	beego.Controller
}

//ajax返回
func (this *BaseController) ajaxMsg(msg interface{}, msgno int) {
	out := make(map[string]interface{})
	out["code"] = msgno
	out["message"] = msg
	this.Data["json"] = out
	this.ServeJSON()
	this.StopRun()
}

//ajax返回 列表
func (this *BaseController) ajaxList(msg interface{}, msgno int, count int64, data interface{}) {
	out := make(map[string]interface{})
	out["code"] = msgno
	out["message"] = msg
	out["count"] = count
	out["data"] = data
	this.Data["json"] = out
	this.ServeJSON()
	this.StopRun()
}

// 通过两重循环过滤重复元素
func (this *BaseController) RemoveRepBySlice(slc []string) []string {
	result := []string{} // 存放结果
	for i := range slc {
		flag := true
		for j := range result {
			if slc[i] == result[j] {
				flag = false // 存在重复元素，标识为false
				break
			}
		}
		if flag { // 标识为false，不添加进结果
			result = append(result, slc[i])
		}
	}
	return result
}

// 图片接口
func (this *BaseController) PutFileImg() {
	h, err := this.GetFiles("file")
	fmt.Println("文件名称", h[0].Filename)
	fmt.Println("文件大小", h[0].Size)
	if err != nil {
		log.Fatal("getfile err ", err)
		this.ajaxMsg(h[0].Filename+"图片上传失败", MSG_ERR_Resources)
	}
	//	defer f.Close()
	path := "static/upload/" + h[0].Filename
	this.SaveToFile("file", path) // 保存位置在 static/upload, 没有文件夹要先创建
	list := make(map[string]interface{})
	list["src"] = path
	list["name"] = h[0].Filename
	list["size"] = h[0].Size
	this.ajaxList("图片上传成功", MSG_OK, 1, list)
}

//将时间化为秒
func (this *BaseController) GetSecs(ordertime string) int64 {
	var s int64
	t, err := time.ParseInLocation("2006-01-02 15:04:05", ordertime, time.Local)
	if err == nil {
		s = t.Unix()
		return s
	} else {
		return -1
	}
}

//获取相差时间
func (this *BaseController) GetMinuteDiffer(server_time, mqtime string) int64 {
	var minute int64
	t1, err := time.ParseInLocation("2006-01-02 15:04:05", server_time, time.Local)
	t2, err := time.ParseInLocation("2006-01-02 15:04:05", mqtime, time.Local)
	if err == nil {
		diff := t1.Unix() - t2.Unix()
		minute = diff / 60
		return minute
	} else {
		return -1
	}
}

func TimeTask() {
	//定期上架
	fmt.Println("定时执行")
	//ordertime
	o := orm.NewOrm()
	ot := new(models.OrderTime)
	var maps []orm.Params
	var dish_info models.Dish
	tk1 := toolbox.NewTask("tk1", "0/1 * * * * *", func() error {
		//fmt.Println("tk1")
		nt := time.Now().Format("2016-01-02 15:04:05")
		s, err := time.ParseInLocation("2006-01-02 15:04:05", nt, time.Local)
		if err != nil {
			log4go.Stdout("转化秒数失败", err.Error())
		}
		//最终秒数
		result_s := s.Unix()
		num, err := o.QueryTable(ot).Filter("Secs__exact", result_s).Values(&maps)
		if err != nil {
			log4go.Stdout("获取上架时间失败", err.Error())
		}
		fmt.Println("判断是否存在相同的时间t_num:", num)
		if num != 0 {
			for _, m := range maps {
				did, err := strconv.ParseInt(fmt.Sprint(m["Did"]), 10, 64)
				if err != nil {
					log4go.Stdout("时间转int64失败", err.Error())
				}
				dish_info.Id = did
			}
			dish_info.Status = 0
			dish_info.Time = nt
			_, err := o.Update(&dish_info)
			if err != nil {
				log4go.Stdout("上架更新失败", err.Error())
			}
		}
		return nil
	})
	toolbox.AddTask("tk1", tk1)
	toolbox.StartTask()

}
