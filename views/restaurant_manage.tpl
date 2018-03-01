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
          餐厅管理员
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
        <li class="layui-nav-item"><a href="/v1/restaurant_dish">菜品库</a></li>
        <li class="layui-nav-item"><a href="/v1/restaurant_ready">备餐</a></li>
        <li class="layui-nav-item"><a href="/v1/restaurant_manage">管理</a></li>
      </ul>
    </div>
  </div>
  <div class="layui-body">
    <!-- 内容主体区域 -->
    <div style="padding: 15px;">
		<div class="layui-tab layui-tab-card">
		  <ul class="layui-tab-title">
		    <li class="layui-this">菜品库管理</li>
		    <li>经营时段管理</li>
		    <li>综合管理</li>
		  </ul>
		  <div class="layui-tab-content" style="height:700px;">
		    <div class="layui-tab-item layui-show">
				<blockquote class="layui-elem-quote" style="margin-top:10px;">菜品库分类</blockquote>
				<div style="padding: 15px;">
					{{range .canteen_info}}
				    <button class="layui-btn" id={{.Id}}>
					  {{.Name}} <i class="layui-icon">&#x1006;</i>
					</button>
					{{end}}
					<button class="layui-btn layui-btn-primary" id="addDish"><i class="layui-icon">&#xe654;</i></button>
				</div>
				<blockquote class="layui-elem-quote">菜单分类</blockquote>
				<div style="padding: 15px;">
					{{range .canteen_info}}
				    <button class="layui-btn" id={{.Id}}>
					  {{.Name}} <i class="layui-icon">&#x1006;</i>
					</button>
					{{end}}
					<button class="layui-btn layui-btn-primary" id="addMenu"><i class="layui-icon">&#xe654;</i></button>
				</div>	
			</div>
		    <div class="layui-tab-item">
				<blockquote class="layui-elem-quote">经营时段</blockquote>
				<hr class="layui-bg-green">
				<table id="timeList" lay-filter="time"></table>
				<script type="text/html" id="barDemo">
					<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">管理</a>
				</script>				
				<hr class="layui-bg-green">
			</div>
		    <div class="layui-tab-item">
				<blockquote class="layui-elem-quote">信息管理</blockquote>
				<form class="layui-form layui-form-pane1" action="" onsubmit="javascript:return false;">				 		
				  <div class="layui-form-item layui-form-text">
				    <label class="layui-form-label">餐厅介绍</label>
				    <div class="layui-input-block">
				      <textarea placeholder="请输入内容" class="layui-textarea" name="Info" id="info"></textarea>
				    </div>
				  </div>
				  <div class="layui-form-item">
					<div class="layui-upload">
					<label class="layui-form-label">餐厅照片</label>
					<div class="layui-upload-list" id="demo1">
				    	<button class="layui-btn layui-btn-primary" id="test1" style="width:80px;height:80px;"><i class="layui-icon">&#xe654;</i></button>
						<input type="file" name="file" id="file[]" class="layui-upload-file">
					</div>
					</div>
				  </div>
				  <div class="layui-form-item">
				    <div class="layui-input-block">
				      <button class="layui-btn" id="add">确认修改</button>
				      <button type="reset" class="layui-btn layui-btn-primary">取消</button>
				    </div>
				  </div>
				</form>
		  </div>
		</div>		
	</div>
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
	layui.use(['element','layer','jquery','table','layedit'], function(){
	  var element = layui.element
		,layer=layui.layer
		,$=layui.jquery
		,table=layui.table
		,form=layui.form
		,layedit=layui.layedit;
	  //layer.msg("你好");
	//文本域
	var index=layedit.build('info',{
		hideTool:['image','face']
	});
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
	
	$('#addDish').on('click',function(){
		//layer.msg("点击添加按钮");
		//获取校区
		//var cp=$("#campus").val();
		//iframe窗
		layer.open({
		  type: 2,
		  title: '新增菜品库分类',
		  //closeBtn: 0, //不显示关闭按钮
		  shadeClose: true,
		  area: ['450px', '150px'],
		 // offset: 'rb', //右下角弹出
		  //time: 2000, //2秒后自动关闭
		  maxmin: true,
		  anim: 2,
		  content: ['/v1/restaurant_manage/adddishtype','no'], //iframe的url，no代表不显示滚动条
		  cancel: function(index, layero){ 
			  if(confirm('确定要关闭么')){ //只有当点击confirm框的确定时，该层才会关闭
			    layer.close(index)
				window.location.reload();				
			  }
			  return false; 
		  },
		});
	});	
	
	$('#addMenu').on('click',function(){
		//layer.msg("点击添加按钮");
		//获取校区
		//var cp=$("#campus").val();
		//iframe窗
		layer.open({
		  type: 2,
		  title: '新增菜单分类',
		  //closeBtn: 0, //不显示关闭按钮
		  shadeClose: true,
		  area: ['450px', '150px'],
		 // offset: 'rb', //右下角弹出
		  //time: 2000, //2秒后自动关闭
		  maxmin: true,
		  anim: 2,
		  content: ['/v1/restaurant_manage/addmenutype','no'], //iframe的url，no代表不显示滚动条
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