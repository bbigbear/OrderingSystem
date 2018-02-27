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
    <ul class="layui-nav layui-layout-right">
      <li class="layui-nav-item">
        <a href="javascript:;">
          <img src="../static/img/admin.jpg" class="layui-nav-img">
          学生
        </a>
        <dl class="layui-nav-child">
          <dd><a href="">基本资料</a></dd>
          <dd><a href="">安全设置</a></dd>
        </dl>
      </li>
      <li class="layui-nav-item"><a href="/">退出</a></li>
    </ul>
  </div>
  
  <div class="layui-side layui-bg-black">
    <div class="layui-side-scroll">
      <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
      <ul class="layui-nav layui-nav-tree"  lay-filter="test">
        <li class="layui-nav-item"><a href="/v1/student_index">订餐</a></li>
        <li class="layui-nav-item"><a href="/v1/student_order">我的订单</a></li>
      </ul>
    </div>
  </div>
  <div class="layui-body">
    <!-- 内容主体区域 -->
    <div style="padding: 15px;">
		<blockquote class="layui-elem-quote">食堂选择</blockquote>
		<form class="layui-form layui-form-pane1" action="" onsubmit="javascript:return false;">		
		  <div class="layui-form-item">
			<label class="layui-form-label">选择食堂</label>
		    <div class="layui-input-inline">
				<select name="campus" id="campus" lay-filter="campus_select">
		          <option value="第一食堂">第一食堂</option>
		          <option value="第二食堂">第二食堂</option>
		        </select>
			</div>
			<div class="layui-input-inline" style="margin-left:100px;">
				<input type="text" name="Name" id="name" placeholder="请输入餐厅名称" autocomplete="off" class="layui-input">
			</div>
			<div class="layui-input-inline" >
		      <button class="layui-btn" id="add">搜索</button>
		  	</div>		
		  </div>
		</form>
		<table id="roomList" lay-filter="room"></table>
		<script type="text/html" id="barDemo">
			<a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="edit">详情</a>
		</script>
  </div>  
  <div class="layui-footer">
    <!-- 底部固定区域 -->
    ©2018 智慧校园. All Rights Reserved
  </div>
</div>
<style>
	.layui-tab-title li:first-child > i {
		display: none;
		disabled:true
	}
</style>

<script src="/static/layui.js"></script>
<!--<script src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>-->
<script>
	//JavaScript代码区域
	layui.use(['element','layer','jquery','table'], function(){
	  var element = layui.element
		,layer=layui.layer
		,$=layui.jquery
		,table=layui.table
		,form=layui.form;
	  //layer.msg("你好");
	//自动加载
	$(function(){
		//layer.msg({{.campus}});
		if({{.campus}}!=""){
			//layer.msg({{.campus}});
			$("#campus").val({{.campus}});
			//$("select[name=campus_select]").val({{.campus}});
			form.render('select');	
		}				
	});
	
	$('#addCanteen').on('click',function(){
		//layer.msg("点击添加按钮");
		//获取校区
		var cp=$("#campus").val();
		//iframe窗
		layer.open({
		  type: 2,
		  title: '新增食堂',
		  //closeBtn: 0, //不显示关闭按钮
		  shadeClose: true,
		  area: ['450px', '150px'],
		 // offset: 'rb', //右下角弹出
		  //time: 2000, //2秒后自动关闭
		  maxmin: true,
		  anim: 2,
		  content: ['/v1/canteen/add?campus='+cp,'no'], //iframe的url，no代表不显示滚动条
		  cancel: function(index, layero){ 
			  if(confirm('确定要关闭么')){ //只有当点击confirm框的确定时，该层才会关闭
			    layer.close(index)
				window.location.reload();				
			  }
			  return false; 
		  },
		});
	});	
	//获取下拉列表
	form.on('select(campus_select)',function(data){
		//layer.msg(data)
		console.log(data.value);
		window.location.href="/v1/canteen?campus="+data.value;
		
	});
	//
	{{range .canteen_info}}
	$('#{{.Id}}').on('click',function(){
		//var dc=$("#delCanteen").val();
		//layer.msg({{.Name}});
		if(confirm('确定要删除该食堂？')){ //只有当点击confirm框的确定时，该层才会关闭
			//layer.close(index)
			//window.location.reload();
			//layer.msg({{.Name}});
			//window.location.href="/v1/canteen/del?id="+{{.Id}};
			var jsData={'id':{{.Id}}}
			$.post('/v1/canteen/del', jsData, function (out) {
                if (out.code == 200) {
                    window.location.href="/v1/canteen?campus="+{{.CampusName}};
                } else {
                    layer.msg(out.message)
                }
            }, "json");	
	        //向服务端发送删除指令
		}
	});
	{{end}}
  });

	
	
</script>

</body>
</html>