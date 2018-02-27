<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title>智慧校园订餐系统</title>
<link rel="stylesheet" href="/static/css/layui.css">
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
  <div class="layui-header">
    <div class="layui-logo">订餐系统</div>   
  </div>
  
  <div>
    <!-- 内容主体区域 -->
    <div style="padding: 15px;padding-left: 50px;">
		<a href="/v1/canteen" class="layui-btn">学校管理员</a>
	</div>
	<div style="padding: 15px;padding-left: 50px;">
		<a id="room" class="layui-btn">餐厅管理员</a>	
		<input type="text" name="Name" id="name" placeholder="请输入餐厅名称" style="height:32px;margin-left:10px;">				
	</div>
	<div style="padding: 15px;padding-left: 50px;">
		<a href="/v1/student_index" class="layui-btn">学生</a>	
	</div>
  </div>
  
</div>
<script src="/static/layui.js"></script>
<!--<script src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>-->
<script>
	//JavaScript代码区域
	layui.use(['element','layer','jquery','table'], function(){
	  var element = layui.element
		,layer=layui.layer
		,$=layui.jquery
		,table=layui.table;
		
		$('#room').on('click', function(){            
			var name=$("#name").val();
			if(name==""){
				layer.msg("请输入餐厅名称");
			}else{				
				var jsData={'name':name}
				$.post('/v1/dining_room/getroom', jsData, function (out) {
	                if (out.code == 200) {
	                    window.location.href="/v1/restaurant_dish?name="+name
	                } else {
	                    layer.msg(out.message)
	                }
	            }, "json");
			}
			return false;
        });
		});
		
</script>
</body>
</html>