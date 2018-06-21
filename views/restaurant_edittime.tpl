<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>编辑时段</title>
  <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <meta name="apple-mobile-web-app-status-bar-style" content="black"> 
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="format-detection" content="telephone=no">

  <link rel="stylesheet" href="/static/css/layui.css">

<style>
body{padding: 10px;}
</style>
</head>
<body>
<form class="layui-form layui-form-pane1" action="">
  <div class="layui-form-item">
	<div class="layui-inline">
      <label class="layui-form-label">经营时段</label>
      <div class="layui-input-inline">
        <input type="text" class="layui-input" id="time" placeholder=" - ">
      </div>
    </div>  
  </div>
  <div class="layui-form-item">
    <div class="layui-input-block">
      <button class="layui-btn" id="add_time">确认</button>
<!--	  <input type="hidden" id="pic_path">-->
      <button type="reset" class="layui-btn layui-btn-primary">取消</button>
    </div>
  </div>
</form>

<br><br><br>


<script src="/static/layui.js"></script>
<!-- <script src="../build/lay/dest/layui.all.js"></script> -->
<script src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>
<script src="https://cdn.bootcss.com/jquery-cookie/1.4.1/jquery.cookie.js"></script>
<script src="https://cdn.bootcss.com/Base64/1.0.1/base64.js"></script>
<script>
layui.use(['form','laydate','upload','jquery','layedit','element'], function(){
  var form = layui.form
  ,laydate=layui.laydate
  ,upload = layui.upload
  , $ = layui.jquery
  ,layedit=layui.layedit
  ,element=layui.element;
	$(function(){
		if($.cookie('user')!=1){
			window.location.href="/"
		}
	})  
	//点击上传
	$('#add_time').on('click',function(){
		var data={
			'id':parseInt(<<<.id>>>),
			'time':$("#time").val()
			};
		console.log(data)
		$.ajax({
			type:"POST",
			contentType:"application/json;charset=utf-8",
			url:"/v1/restaurant_manage/edittime_action",
			data:JSON.stringify(data),
			async:false,
			error:function(request){
				alert("post error")						
			},
			success:function(res){
				if(res.code==200){
					alert("更新成功")
					window.location.reload();					
				}else{
					alert("更新失败")
				}						
			}
		});
		return false;
	});

	//时间范围
	  var ins1=laydate.render({
	    elem: '#time'
	    ,type: 'time'
	    ,range: true
		,min: '<<<.time1>>>'
		,max: '<<<.time2>>>'
		,change: function(value, date, endDate){
		    //console.log(value); //得到日期生成的值，如：2017-08-18
		    //console.log(date); //得到日期时间对象：{year: 2017, month: 8, date: 18, hours: 0, minutes: 0, seconds: 0}
		    //console.log(endDate); //得结束的日期时间对象，开启范围选择（range: true）才会返回。对象成员同上。
			if ((date.hours==endDate.hours)&&((endDate.minutes)-(date.minutes))<30){
				//alert("营业区间不小于30分钟")
				//$("#time").attr("value","");
				//document.getElementById("time").value="";	
				ins1.hint("营业区间不小于30分钟");
			}else if((date.hours>endDate.hours)){
				ins1.hint("前一时间不能晚于后一时间");
			}else if((date.hours==endDate.hours)&&(date.minutes>endDate.minutes)){
				ins1.hint("前一时间不能晚于后一时间");
			}else if((date.hours==endDate.hours)&&(date.minutes==endDate.minutes)&&(date.seconds>endDate.seconds)){
				ins1.hint("前一时间不能晚于后一时间");
			}
		}
	  }); 
	  
});
</script>

</body>
</html>