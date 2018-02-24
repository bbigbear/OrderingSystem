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
    <!-- 头部区域（可配合layui已有的水平导航） -->
    <!--<ul class="layui-nav layui-layout-left">
      <li class="layui-nav-item"><a href="">个人中心</a></li>
      <li class="layui-nav-item"><a href="">内容管理</a></li>
      <li class="layui-nav-item"><a href="">统计报表</a></li>
	  <li class="layui-nav-item"><a href="">客服管理</a></li>
      <li class="layui-nav-item">
        <a href="javascript:;">系统管理</a>
        <dl class="layui-nav-child">
          <dd><a href="">邮件管理</a></dd>
          <dd><a href="">消息管理</a></dd>
          <dd><a href="">授权管理</a></dd>
        </dl>
      </li>
    </ul>-->
    <ul class="layui-nav layui-layout-right">
      <li class="layui-nav-item">
        <a href="javascript:;">
          <img src="../static/img/admin.jpg" class="layui-nav-img">
          学校管理员
        </a>
        <dl class="layui-nav-child">
          <dd><a href="">基本资料</a></dd>
          <dd><a href="">安全设置</a></dd>
        </dl>
      </li>
      <li class="layui-nav-item"><a href="">退出</a></li>
    </ul>
  </div>
  
  <div class="layui-side layui-bg-black">
    <div class="layui-side-scroll">
      <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
      <ul class="layui-nav layui-nav-tree"  lay-filter="test">
        <li class="layui-nav-item"><a href="/v1/canteen">食堂管理</a></li>
        <li class="layui-nav-item"><a href="/v1/dining_room">餐厅管理</a></li>
        <li class="layui-nav-item"><a href="/v1/dining_time">供应时段</a></li>
      </ul>
    </div>
  </div>
  <div class="layui-body">
    <!-- 内容主体区域 -->
    <div style="padding: 15px;">
		<blockquote class="layui-elem-quote">校区选择</blockquote>
		<div  class="layui-form" style="padding: 15px;height:50px;">
			<select name="campus" id="campus" lay-filter="campus_select" style="height:30px;width:200px;">
			  <option value="雁塔校区">雁塔校区</option>
			  <option value="兴庆校区">兴庆校区</option>
			  <option value="曲江校区">曲江校区</option>
			</select> 
		</div>		
		<blockquote class="layui-elem-quote">食堂开设</blockquote>
		<div style="padding: 15px;">
			{{range .canteen_info}}
		    <button class="layui-btn" id={{.Id}}>
			  {{.Name}} <i class="layui-icon">&#x1006;</i>
			</button>
			{{end}}
			<button class="layui-btn layui-btn-primary" id="addCanteen"><i class="layui-icon">&#xe654;</i></button>
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