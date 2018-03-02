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

<script>
layui.use(['form','laydate','upload','jquery','layedit','element'], function(){
  var form = layui.form
  ,laydate=layui.laydate
  ,upload = layui.upload
  , $ = layui.jquery
  ,layedit=layui.layedit
  ,element=layui.element;
  
	//点击上传
	$('#add_time').on('click',function(){
		var data={
			'id':parseInt({{.id}}),
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
	  laydate.render({
	    elem: '#time'
	    ,type: 'time'
	    ,range: true
	  });
	  
});
</script>

</body>
</html>