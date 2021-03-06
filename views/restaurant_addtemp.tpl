<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>新增模板</title>
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
    <label class="layui-form-label">*模板名称</label>
    <div class="layui-input-block">
	<input type="text" name="Name" id="name" placeholder="请输入模板名称" autocomplete="off" class="layui-input">
    </div>
  </div>
  <div class="layui-form-item">
    <div class="layui-input-block">
      <button class="layui-btn" id="add">确认</button>
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
	$('#add').on('click',function(){
		var name=$("#name").val()
		if(name==""){
			alert("模板名称不能为空")
		}else{
			var data={
			'rid':parseInt(<<<.id>>>),
			'name':$("#name").val()
			};
			$.ajax({
				type:"POST",
				contentType:"application/json;charset=utf-8",
				url:"/v1/restaurant_ready/addtempready_action",
				data:JSON.stringify(data),
				async:false,
				error:function(request){
					alert("post error")						
				},
				success:function(res){
					if(res.code==200){
						alert("新增成功")
						//layer.close(index);
						//window.location.reload();			
						parent.layer.closeAll();
						parent.location.reload();								
					}else{
						alert("新增失败")
					}						
				}
			});
		}		
		return false;
	});
});
</script>

</body>
</html>